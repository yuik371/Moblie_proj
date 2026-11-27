from fastapi import FastAPI

from app.routers import auth, users, email_verification, posts


app = FastAPI()

# 회원가입·로그인
app.include_router(auth.router, prefix="/api")

# 사용자 정보
app.include_router(users.router, prefix="/api")

# 이메일 인증
app.include_router(email_verification.router, prefix="/api")

# 게시물 등록·목록·상세
app.include_router(posts.router, prefix="/api")