from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field


# 사용자가 게시물을 등록할 때 입력하는 정보
class PostCreate(BaseModel):
    title: str = Field(min_length=1, max_length=100)
    description: str = Field(min_length=1, max_length=5000)
    category: str = Field(min_length=1, max_length=50)
    region: str = Field(min_length=1, max_length=100)

    # 팀원의 사진 업로드 기능에서 받은 주소
    image_urls: list[str] = Field(default_factory=list, max_length=20)

    # 판매가격: 결정 전에는 비워둘 수 있습니다.
    price: int | None = Field(default=None, ge=0)


# 게시물 조회 시 서버가 보내는 정보
class PostResponse(PostCreate):
    id: int
    seller_id: int
    seller_nickname: str

    status: Literal["판매중", "예약중", "판매완료"]

    # AI 기능 연결 전에는 분석 결과를 비워둡니다.
    ai_recommended_price: int | None = Field(default=None, ge=0)
    analysis_status: Literal[
        "분석대기", "분석중", "완료", "실패"
    ] = "분석대기"

    created_at: datetime

    # 게시물 수정 시 받는 정보
class PostUpdate(BaseModel):
    title: str = Field(min_length=1, max_length=100)
    description: str = Field(min_length=1, max_length=5000)
    category: str = Field(min_length=1, max_length=50)
    region: str = Field(min_length=1, max_length=100)
    image_urls: list[str] = Field(default_factory=list, max_length=20)
    price: int | None = Field(default=None, ge=0)
    status: Literal["판매중", "예약중", "판매완료"] = "판매중"