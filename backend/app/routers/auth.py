import redis
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.core.security import (
    create_access_token,
    hash_password,
    verify_password,
)
from app.db.session import get_db
from app.models.user import User
from app.routers.email_verification import redis_client
from app.schemas.auth import UserCreate, UserLogin


router = APIRouter(
    prefix="/auth",
    tags=["auth"],
)


@router.post("/register", status_code=status.HTTP_201_CREATED)
def register(
    user: UserCreate,
    db: Session = Depends(get_db),
):
    email = str(user.email)

    # DB에서 이메일 중복 여부를 확인합니다.
    existing_user = db.scalar(
        select(User).where(User.email == email)
    )

    if existing_user is not None:
        raise HTTPException(
            status_code=409,
            detail="이미 가입된 이메일입니다.",
        )

    # 가입에 사용할 비밀번호를 해싱합니다.
    hashed_password = hash_password(user.password)

    # 이메일 인증 완료 기록을 확인하고 사용합니다.
    verified_key = f"mobile:email:verified:{email}"

    verification_script = """
    if redis.call('GET', KEYS[1]) == 'true' then
        redis.call('DEL', KEYS[1])
        return 1
    end
    return 0
    """

    try:
        verified = redis_client.eval(
            verification_script,
            1,
            verified_key,
        )
    except redis.RedisError:
        raise HTTPException(
            status_code=503,
            detail="이메일 인증 상태를 확인할 수 없습니다.",
        )

    if verified != 1:
        raise HTTPException(
            status_code=403,
            detail="이메일 인증을 먼저 완료해주세요.",
        )

    # 새 회원을 DB에 저장합니다.
    new_user = User(
        email=email,
        password_hash=hashed_password,
        nickname=user.nickname,
    )

    db.add(new_user)

    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="회원정보가 중복되어 가입할 수 없습니다.",
        )

    db.refresh(new_user)

    return {
        "message": "회원가입 성공",
        "user_id": new_user.id,
    }


@router.post("/login")
def login(
    user: UserLogin,
    db: Session = Depends(get_db),
):
    # DB에 저장된 회원을 조회합니다.
    existing_user = db.scalar(
        select(User).where(User.email == str(user.email))
    )

    if existing_user is None:
        raise HTTPException(
            status_code=401,
            detail="이메일 또는 비밀번호가 올바르지 않습니다.",
        )

    if not verify_password(
        user.password,
        existing_user.password_hash,
    ):
        raise HTTPException(
            status_code=401,
            detail="이메일 또는 비밀번호가 올바르지 않습니다.",
        )

    access_token = create_access_token(existing_user.id)

    return {
        "message": "로그인 성공",
        "user_id": existing_user.id,
        "nickname": existing_user.nickname,
        "access_token": access_token,
        "token_type": "bearer",
    }