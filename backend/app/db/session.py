from pathlib import Path

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker


# backend 폴더에 marketplace.db 파일을 생성합니다.
BACKEND_DIR = Path(__file__).resolve().parents[2]
DB_PATH = BACKEND_DIR / "marketplace.db"

DATABASE_URL = f"sqlite:///{DB_PATH}"

# SQLite 연결 설정
engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False},
)

# 요청마다 사용할 DB 세션 생성기
SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    expire_on_commit=False,
)


# DB 테이블 클래스의 공통 부모
class Base(DeclarativeBase):
    pass


# API 요청이 끝나면 DB 세션을 닫습니다.
def get_db():
    with SessionLocal() as db:
        yield db