from datetime import datetime, timezone

from sqlalchemy import DateTime, Integer, JSON, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.db.session import Base


class Post(Base):
    __tablename__ = "posts"

    # 게시물 번호
    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
    )

    # 상품 기본 정보
    title: Mapped[str] = mapped_column(String(100))
    description: Mapped[str] = mapped_column(Text)
    category: Mapped[str] = mapped_column(String(50))
    region: Mapped[str] = mapped_column(String(100))

    # 사진 업로드 담당 기능에서 받은 주소 목록
    image_urls: Mapped[list[str]] = mapped_column(
        JSON,
        default=list,
    )

    # 가격 결정 전에는 비워둘 수 있습니다.
    price: Mapped[int | None] = mapped_column(
        Integer,
        nullable=True,
    )

    # 작성자 정보
    seller_id: Mapped[int] = mapped_column(Integer, index=True)
    seller_nickname: Mapped[str] = mapped_column(String(100))

    # 거래 상태
    status: Mapped[str] = mapped_column(
        String(20),
        default="판매중",
    )

    # AI 결과를 저장할 자리
    ai_recommended_price: Mapped[int | None] = mapped_column(
        Integer,
        nullable=True,
    )

    analysis_status: Mapped[str] = mapped_column(
        String(20),
        default="분석대기",
    )

    # UTC 기준 등록 시간
    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=lambda: datetime.now(timezone.utc).replace(
            tzinfo=None
        ),
    )