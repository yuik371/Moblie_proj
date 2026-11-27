import jwt

from pwdlib import PasswordHash
from datetime import datetime, timedelta, timezone
from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from app.core.config import settings
from app.db import database

password_hash = PasswordHash.recommended()
security = HTTPBearer()

# 비밀번호 해싱
def hash_password(password: str) -> str:
    return password_hash.hash(password)

# 비밀번호 검증
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return password_hash.verify(plain_password, hashed_password)

# JWT 토큰 생성
def create_access_token(user_id: int):
    
    expire = datetime.now(timezone.utc) + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    payload = {"sub": str(user_id), "exp": expire}

    return jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm=settings.JWT_ALGORITHM)

# JWT 검증 및 사용자 확인
def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):

    token = credentials.credentials

    try:
        payload = jwt.decode(token, settings.JWT_SECRET_KEY, algorithms=[settings.JWT_ALGORITHM])
        user_id = int(payload["sub"])

    except (jwt.InvalidTokenError, KeyError, ValueError, TypeError):
        raise HTTPException(
            status_code=401,
            detail="유효하지 않거나 만료된 토큰입니다.",
            headers={"WWW-Authenticate": "Bearer"}
        )

    for user in database.users:
        if user["id"] == user_id:
            return user

    raise HTTPException(
        status_code=401,
        detail="사용자를 찾을 수 없습니다.",
        headers={"WWW-Authenticate": "Bearer"}
    )