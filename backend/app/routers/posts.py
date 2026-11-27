from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.post import Post
from app.schemas.post import PostCreate, PostResponse, PostUpdate


router = APIRouter(
    prefix="/posts",
    tags=["게시물"],
)


@router.post(
    "",
    response_model=PostResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_post(
    request: PostCreate,
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """로그인한 사용자의 게시물을 DB에 저장합니다."""

    post = Post(
        **request.model_dump(),
        seller_id=current_user["id"],
        seller_nickname=current_user["nickname"],
        status="판매중",
        analysis_status="분석대기",
    )

    db.add(post)
    db.commit()
    db.refresh(post)

    return post


@router.get("", response_model=list[PostResponse])
def get_posts(
    keyword: str | None = Query(default=None, max_length=100),
    region: str | None = Query(default=None, max_length=100),
    category: str | None = Query(default=None, max_length=50),
    db: Session = Depends(get_db),
):
    """조건에 맞는 게시물을 DB에서 최신순으로 조회합니다."""

    query = select(Post)

    # 제목 또는 설명에서 검색합니다.
    if keyword and keyword.strip():
        search_word = keyword.strip()

        query = query.where(
            or_(
                Post.title.contains(search_word, autoescape=True),
                Post.description.contains(search_word, autoescape=True),
            )
        )

    if region and region.strip():
        query = query.where(Post.region == region.strip())

    if category and category.strip():
        query = query.where(Post.category == category.strip())

    query = query.order_by(Post.id.desc())

    return db.scalars(query).all()


@router.get("/{post_id}", response_model=PostResponse)
def get_post(
    post_id: int,
    db: Session = Depends(get_db),
):
    """게시물 상세 내용을 조회합니다."""

    post = db.get(Post, post_id)

    if post is None:
        raise HTTPException(
            status_code=404,
            detail="게시물을 찾을 수 없습니다.",
        )

    return post


@router.put("/{post_id}", response_model=PostResponse)
def update_post(
    post_id: int,
    request: PostUpdate,
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """작성자만 게시물을 수정할 수 있습니다."""

    post = db.get(Post, post_id)

    if post is None:
        raise HTTPException(
            status_code=404,
            detail="게시물을 찾을 수 없습니다.",
        )

    if post.seller_id != current_user["id"]:
        raise HTTPException(
            status_code=403,
            detail="본인이 작성한 게시물만 수정할 수 있습니다.",
        )

    # 사진이 바뀌면 이전 AI 분석 결과를 초기화합니다.
    if request.image_urls != post.image_urls:
        post.ai_recommended_price = None
        post.analysis_status = "분석대기"

    # 수정 가능한 필드만 반영합니다.
    for field, value in request.model_dump().items():
        setattr(post, field, value)

    db.commit()
    db.refresh(post)

    return post


@router.delete("/{post_id}")
def delete_post(
    post_id: int,
    current_user: dict = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """작성자만 게시물을 삭제할 수 있습니다."""

    post = db.get(Post, post_id)

    if post is None:
        raise HTTPException(
            status_code=404,
            detail="게시물을 찾을 수 없습니다.",
        )

    if post.seller_id != current_user["id"]:
        raise HTTPException(
            status_code=403,
            detail="본인이 작성한 게시물만 삭제할 수 있습니다.",
        )

    db.delete(post)
    db.commit()

    return {"message": "게시물이 삭제되었습니다."}