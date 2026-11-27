import secrets
import smtplib
import ssl
from email.message import EmailMessage

import redis
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr, Field

from app.core.config import settings


router = APIRouter(
    prefix="/email",
    tags=["이메일 인증"],
)

# 인증번호를 문자열로 읽도록 설정합니다.
redis_client = redis.Redis(
    host=settings.REDIS_HOST,
    port=settings.REDIS_PORT,
    decode_responses=True,
    socket_connect_timeout=3,
    socket_timeout=3,
)


class EmailRequest(BaseModel):
    email: EmailStr


class VerifyRequest(BaseModel):
    email: EmailStr
    code: str = Field(pattern=r"^[0-9]{6}$")


def send_email(email: str, code: str):
    """네이버 SMTP로 인증번호를 발송합니다."""
    message = EmailMessage()
    message["Subject"] = "[중고거래] 이메일 인증번호"
    message["From"] = settings.SMTP_USER
    message["To"] = email

    message.set_content(
        f"이메일 인증번호는 {code}입니다.\n"
        "5분 안에 입력해주세요.\n"
        "본인이 요청하지 않았다면 이 메일을 무시해주세요."
    )

    with smtplib.SMTP_SSL(
        settings.SMTP_SERVER,
        settings.SMTP_PORT,
        context=ssl.create_default_context(),
        timeout=15,
    ) as server:
        server.login(
            settings.SMTP_USER,
            settings.SMTP_PASSWORD.get_secret_value(),
        )
        server.send_message(message)


@router.post("/send-code")
def send_code(request: EmailRequest):
    email = str(request.email)
    code_key = f"mobile:email:code:{email}"
    cooldown_key = f"mobile:email:cooldown:{email}"
    verified_key = f"mobile:email:verified:{email}"

    # 같은 이메일로는 60초마다 발송할 수 있습니다.
    try:
        allowed = redis_client.set(
            cooldown_key, "1", ex=60, nx=True
        )

        if not allowed:
            raise HTTPException(
                status_code=429,
                detail="60초 후에 다시 요청해주세요.",
            )

        # 앞자리가 0이어도 6자리 문자열을 유지합니다.
        code = f"{secrets.randbelow(1_000_000):06d}"

        with redis_client.pipeline(transaction=True) as pipe:
            pipe.set(code_key, code, ex=300)
            pipe.delete(verified_key)
            pipe.execute()

    except redis.RedisError:
        raise HTTPException(
            status_code=503,
            detail="인증번호 저장소에 연결할 수 없습니다.",
        )

    try:
        send_email(email, code)

    except (smtplib.SMTPException, OSError) as error:
        # 발송 실패 시 인증번호와 재발송 제한을 정리합니다.
        try:
            redis_client.delete(code_key, cooldown_key)
        except redis.RedisError:
            pass

        print(
            "SMTP 오류:",
            type(error).__name__,
            str(error),
            flush=True,
        )

        raise HTTPException(
            status_code=502,
            detail="메일 전송에 실패했습니다. 서버 터미널을 확인해주세요.",
        )

    return {"message": "인증번호를 이메일로 전송했습니다."}


@router.post("/verify-code")
def verify_code(request: VerifyRequest):
    email = str(request.email)
    code_key = f"mobile:email:code:{email}"
    verified_key = f"mobile:email:verified:{email}"

    # 번호 확인·삭제·인증 완료 저장을 한 번에 처리합니다.
    script = """
    local saved = redis.call('GET', KEYS[1])

    if not saved then
        return 0
    end

    if saved ~= ARGV[1] then
        return -1
    end

    redis.call('DEL', KEYS[1])
    redis.call('SET', KEYS[2], 'true', 'EX', 3600)
    return 1
    """

    try:
        result = redis_client.eval(
            script,
            2,
            code_key,
            verified_key,
            request.code,
        )

    except redis.RedisError:
        raise HTTPException(
            status_code=503,
            detail="인증번호 저장소에 연결할 수 없습니다.",
        )

    if result == 0:
        raise HTTPException(
            status_code=400,
            detail="인증번호가 만료되었거나 요청되지 않았습니다.",
        )

    if result == -1:
        raise HTTPException(
            status_code=400,
            detail="인증번호가 일치하지 않습니다.",
        )

    return {"message": "이메일 인증이 완료되었습니다."}