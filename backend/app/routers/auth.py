from fastapi import APIRouter, status, HTTPException
from app.schemas.auth import UserCreate, UserLogin
from app.core.security import password_hash, create_access_token

# 임시 사용자 저장소
from app.db import database

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/register", status_code=status.HTTP_201_CREATED)
def register(user: UserCreate):

    # 이메일 중복 검사
    for existing_user in database.users:
        if existing_user["email"] == user.email:
            raise HTTPException(status_code=409, detail="이미 가입된 이메일입니다.")

    # 사용자 정보 저장
    new_user = {
        "id": database.next_user_id,
        "email": user.email,
        "password": password_hash.hash(user.password),
        "nickname": user.nickname
    }

    database.users.append(new_user)
    database.next_user_id += 1

    return {"message": "회원가입 성공", "user_id": new_user["id"]}

@router.post("/login")
def login(user: UserLogin):
    # 이메일 검색
    for existing_user in database.users:
        if existing_user["email"] == user.email:
            # 비밀번호 확인
            if not password_hash.verify(user.password, existing_user["password"]):
                raise HTTPException(status_code=401, detail="비밀번호가 올바르지 않습니다.")

            access_token = create_access_token(existing_user["id"])
            return {
                "message": "로그인 성공",
                "user_id": existing_user["id"],
                "nickname": existing_user["nickname"],
                "access_token": access_token,
                "token_type": "bearer"
            }

    raise HTTPException(status_code=401, detail="존재하지 않는 이메일입니다.")