from datetime import datetime, timezone
from itertools import count
from threading import Lock

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.core.security import get_current_user
from app.schemas.post import PostCreate, PostResponse, PostUpdate


router = APIRouter(
    prefix="/posts",
    tags=["게시물"],
)

# 임시 게시물 저장소
posts: dict[int, PostResponse] = {}

# 게시물 번호와 동시 등록 처리용 잠금
post_ids = count(1)
posts_lock = Lock()


@router.post(
    "",
    response_model=PostResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_post(
    request: PostCreate,
    current_user: dict = Depends(get_current_user),
):
    """로그인한 사용자가 게시물을 등록합니다."""

    with posts_lock:
        post_id = next(post_ids)

        post = PostResponse(
            **request.model_dump(),
            id=post_id,
            # 작성자 정보는 로그인 토큰으로 확인합니다.
            seller_id=current_user["id"],
            seller_nickname=current_user["nickname"],
            status="판매중",
            created_at=datetime.now(timezone.utc),
        )

        posts[post_id] = post

    return post


@router.get("", response_model=list[PostResponse])
def get_posts(
    keyword: str | None = Query(default=None, max_length=100),
    region: str | None = Query(default=None, max_length=100),
    category: str | None = Query(default=None, max_length=50),
):
    """검색 조건에 맞는 게시물을 최신순으로 조회합니다."""

    with posts_lock:
        result = list(posts.values())

    # 제목 또는 설명에 검색어가 포함된 게시물을 찾습니다.
    if keyword and keyword.strip():
        search_word = keyword.strip().casefold()
        result = [
            post
            for post in result
            if search_word in post.title.casefold()
            or search_word in post.description.casefold()
        ]

    # 지역이 일치하는 게시물을 찾습니다.
    if region and region.strip():
        result = [
            post
            for post in result
            if post.region == region.strip()
        ]

    # 카테고리가 일치하는 게시물을 찾습니다.
    if category and category.strip():
        result = [
            post
            for post in result
            if post.category == category.strip()
        ]

    return sorted(
        result,
        key=lambda post: post.id,
        reverse=True,
    )


@router.get("/{post_id}", response_model=PostResponse)
def get_post(post_id: int):
    """게시물 번호로 상세 내용을 조회합니다."""

    with posts_lock:
        post = posts.get(post_id)

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
):
    """작성자만 게시물을 수정할 수 있습니다."""

    with posts_lock:
        post = posts.get(post_id)

        if post is None:
            raise HTTPException(
                status_code=404,
                detail="게시물을 찾을 수 없습니다.",
            )

        # 로그인한 사용자와 게시물 작성자를 비교합니다.
        if post.seller_id != current_user["id"]:
            raise HTTPException(
                status_code=403,
                detail="본인이 작성한 게시물만 수정할 수 있습니다.",
            )

        # 기존 작성자·등록일·AI 결과는 유지합니다.
        updated_data = post.model_dump()
        updated_data.update(request.model_dump())

        # 사진이 바뀌면 기존 AI 분석 결과를 초기화합니다.
        if request.image_urls != post.image_urls:
            updated_data["ai_recommended_price"] = None
            updated_data["analysis_status"] = "분석대기"

        updated_post = PostResponse(**updated_data)
        posts[post_id] = updated_post

    return updated_post

@router.delete("/{post_id}")
def delete_post(
    post_id: int,
    current_user: dict = Depends(get_current_user),
):
    """작성자만 게시물을 삭제할 수 있습니다."""

    with posts_lock:
        post = posts.get(post_id)

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

        # 게시물 정보만 삭제합니다.
        # 사진 원본 삭제는 업로드 담당 기능과 연결할 때 처리합니다.
        del posts[post_id]

    return {"message": "게시물이 삭제되었습니다."}