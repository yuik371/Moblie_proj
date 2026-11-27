# AI & AR 기반 중고거래 플랫폼

2026년 하반기 모바일프로그래밍 팀 프로젝트  
팀원: 유익, 임태진, 김가빈, 박상우

Flutter와 FastAPI를 활용한 중고거래 앱입니다.

사용자가 등록한 상품을 목록과 상세 화면에서 확인하고, 검색·수정·삭제할 수 있습니다. 이메일 인증과 회원가입·로그인을 지원하며, 회원정보와 게시물은 SQLite에 저장합니다.

향후 상품 사진 업로드, AI 결함 탐지와 추천가격 산정, 실제 공간에 상품을 배치하는 AR 기능을 연결할 예정입니다.

## 1. 기술 구성

| 구분             | 기술                        | 용도                                |
| ---------------- | --------------------------- | ----------------------------------- |
| 모바일 앱        | Flutter, Dart               | 화면 및 사용자 인터랙션             |
| 서버             | FastAPI, Python             | 인증 및 게시물 API                  |
| 데이터베이스     | SQLite, SQLAlchemy          | 회원·게시물 저장                    |
| 임시 인증 데이터 | Redis                       | 인증번호 및 인증 완료 기록 저장     |
| 이메일           | 네이버 SMTP                 | 이메일 인증번호 발송                |
| 로그인 인증      | JWT                         | 로그인 사용자 및 게시물 작성자 확인 |
| 비밀번호         | pwdlib, Argon2              | 비밀번호 해싱                       |
| 앱 통신          | http                        | Flutter와 FastAPI 연결              |
| AR 스타일 데모   | sensors_plus, CustomPainter | 센서 기반 움직임 및 배경 렌더링     |

## 2. 현재 구현한 기능

### 이메일 인증 및 회원 기능

- 앱에서 인증번호 이메일 발송
- 6자리 인증번호 확인
- 이메일 인증 후 회원가입
- 이메일 중복 가입 방지
- 이메일·비밀번호 로그인 및 JWT 발급
- 회원정보 SQLite 저장
- 앱 실행 중 로그인 토큰과 회원 번호 공유

인증번호는 5분 동안 유효하며, 같은 이메일의 재발송 간격은 60초입니다. 인증 완료 기록은 최대 1시간 동안 유지되고 회원가입 시 사용됩니다.

### 게시물 기능

- 홈의 `+` 버튼으로 게시물 등록
- 제목·설명·카테고리·거래 지역 입력
- 최신순 게시물 목록 및 상세 조회
- 제목·설명 검색과 서버의 지역·카테고리 필터
- 작성자의 게시물 수정·삭제
- 판매 중·예약 중·판매 완료 상태 변경
- SQLite 저장을 통한 서버 재시작 후 데이터 유지
- 사진 주소 및 AI 추천가격을 저장할 필드 준비

사진 업로드와 AI 분석은 아직 연결하지 않았습니다. 현재 앱에서 새로 등록한 게시물은 사진 없이 가격 미정으로 저장됩니다. 판매가격은 수정 화면에서 입력할 수 있습니다.

### 기존 데모 화면

채팅, 동네 설정, 앱 설정, 센서 기반 AR 스타일 미리보기 화면이 포함되어 있습니다. 일부 기존 화면은 샘플 데이터로 동작합니다.

현재 서버 게시물 상세 화면에는 채팅·AR 진입 기능이 아직 연결되어 있지 않습니다.

## 3. 사용자 흐름

### 회원가입 및 로그인

나의 당근 → 로그인 / 회원가입 → 회원가입  
→ 이메일 인증번호 발송 → 인증번호 확인  
→ 닉네임·비밀번호 입력 → 회원가입 완료 → 로그인

### 게시물 이용

로그인 → 홈의 `+` 버튼 → 상품 정보 입력 → 작성 완료  
→ 홈 목록 → 상품 상세 → 본인 게시물 수정 또는 삭제

검색 탭에서는 검색어를 입력해 실제 DB의 게시물을 조회할 수 있습니다.

## 4. 프로젝트 구조

```text
Moblie_proj/
├── lib/
│   ├── config/                  # 앱 테마
│   ├── models/
│   │   ├── listing.dart         # 기존 데모 상품 모델
│   │   └── post.dart            # 서버 게시물 모델
│   ├── providers/               # 기존 화면 상태 관리
│   ├── screens/
│   │   ├── karrot_shell.dart
│   │   ├── server_posts_view.dart
│   │   ├── server_search_view.dart
│   │   ├── post_detail_view.dart
│   │   ├── post_edit_view.dart
│   │   ├── write_view.dart
│   │   ├── server_login_view.dart
│   │   ├── server_signup_view.dart
│   │   └── 기타 데모 화면
│   ├── services/
│   │   ├── post_service.dart
│   │   ├── auth_service.dart
│   │   ├── auth_session.dart
│   │   └── sensor_service.dart
│   └── widgets/                 # 공통 위젯
├── backend/
│   ├── app/
│   │   ├── core/                # 환경 설정·JWT·비밀번호 처리
│   │   ├── db/
│   │   │   └── session.py       # SQLite 연결 및 DB 세션
│   │   ├── models/              # 회원·게시물 테이블
│   │   ├── routers/             # 인증·사용자·게시물 API
│   │   ├── schemas/             # 요청·응답 데이터 형식
│   │   └── main.py
│   ├── .env.example
│   └── requirements.txt
└── pubspec.yaml
```

## 5. 개발 환경

- macOS
- VS Code
- Flutter SDK
- Python 3.13
- Redis
- iOS Simulator 및 Xcode

현재 앱과 서버의 연결은 같은 맥북에서 실행하는 iPhone 시뮬레이터 기준으로 확인했습니다.

## 6. 백엔드 실행

### 가상환경 및 패키지 설치

프로젝트 최상위 폴더의 터미널에서 실행합니다.

```bash
cd backend
python3.13 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

### 환경변수 설정

`backend/.env` 파일을 만들고 본인의 설정값을 입력합니다.

```dotenv
JWT_SECRET_KEY=본인이_생성한_랜덤_비밀키
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60

SMTP_SERVER=smtp.naver.com
SMTP_PORT=465
SMTP_USER=발신용_네이버_이메일
SMTP_PASSWORD=네이버_애플리케이션_비밀번호

REDIS_HOST=127.0.0.1
REDIS_PORT=6379
```

JWT 비밀키 생성 예시:

```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

SMTP에는 메일 발송이 허용된 계정의 애플리케이션 비밀번호를 사용합니다. 실제 비밀번호와 `.env` 파일은 저장소에 올리지 않습니다.

### DB 테이블 생성

`backend` 폴더에서 실행합니다.

```bash
python -c "from app.db.session import Base, engine; from app.models.user import User; from app.models.post import Post; Base.metadata.create_all(bind=engine)"
```

`backend/marketplace.db`가 생성됩니다. 기존 테이블이 있으면 유지되며, 이 명령은 기존 테이블의 구조를 변경하지 않습니다.

### Redis 실행

별도 터미널에서 실행합니다.

```bash
redis-server
```

연결 확인:

```bash
redis-cli ping
```

`PONG`이 나오면 정상입니다.

### FastAPI 실행

가상환경이 활성화된 `backend` 터미널에서 실행합니다.

```bash
python -m uvicorn app.main:app --reload
```

API 문서: http://127.0.0.1:8000/docs

## 7. Flutter 실행

프로젝트 최상위 폴더에서 실행합니다.

```bash
flutter pub get
open -a Simulator
flutter devices
flutter run
```

기기 선택 화면에서 iPhone 시뮬레이터를 선택합니다.

현재 서버 주소는 `lib/services/post_service.dart`에 설정되어 있습니다.

```dart
static const baseUrl = 'http://127.0.0.1:8000';
```

이 주소는 같은 맥북에서 실행 중인 iPhone 시뮬레이터 기준입니다. 실제 휴대폰·Android 에뮬레이터·웹에서 실행할 때는 연결 주소와 플랫폼별 네트워크 설정을 조정해야 합니다.

## 8. 주요 API

| 메서드 | 경로                     | 기능                |
| ------ | ------------------------ | ------------------- |
| POST   | `/api/email/send-code`   | 인증번호 발송       |
| POST   | `/api/email/verify-code` | 인증번호 확인       |
| POST   | `/api/auth/register`     | 회원가입            |
| POST   | `/api/auth/login`        | 로그인 및 토큰 발급 |
| POST   | `/api/posts`             | 게시물 등록         |
| GET    | `/api/posts`             | 목록·검색·필터      |
| GET    | `/api/posts/{post_id}`   | 상세 조회           |
| PUT    | `/api/posts/{post_id}`   | 게시물 전체 수정    |
| DELETE | `/api/posts/{post_id}`   | 게시물 삭제         |

게시물 등록·수정·삭제에는 로그인 토큰이 필요합니다. 수정·삭제 시 서버에서 작성자 여부를 검사합니다.

## 9. 확인한 기능 및 현재 제한

### 확인 완료

- 이메일 발송·인증 및 미인증 회원가입 차단
- 앱 회원가입·로그인
- 서버 재시작 후 회원정보 유지
- 게시물 등록·조회·수정·삭제·검색
- 서버 재시작 후 게시물 유지
- Flutter 화면과 FastAPI 연동

### 추가 확인 및 구현 예정

- 다른 계정의 게시물 수정·삭제 차단 테스트
- 실제 로그인 닉네임의 프로필 표시
- 로그아웃 및 앱 재시작 후 로그인 유지
- 사진 업로드 담당 기능 연결
- AI 결함 탐지·추천가격 결과 연결
- 실제 AR 공간 인식 및 3D 상품 배치
- 서버 게시물과 채팅 기능 연결

현재 로그인 정보는 앱 메모리에 보관하므로 앱을 완전히 재시작하면 다시 로그인해야 합니다. 회원정보와 게시물은 SQLite에 유지됩니다.

## 10. 개발 방향

기획서의 목표 흐름은 다음과 같습니다.

상품 사진 촬영·업로드 → AI 결함 탐지 → 추천가격 제안  
→ 구매자의 AR 배치 확인 → 거래

현재 구현은 이 흐름의 기반이 되는 이메일 인증, 회원 관리, 게시판 및 앱·서버 연결에 해당합니다.

사진 파일 업로드와 AI 모델 자체는 별도 담당 기능과 연동할 예정입니다. 실제 결제·실시간 채팅·공간 인식 AR은 아직 구현 완료 상태가 아닙니다.

## 라이선스

모바일프로그래밍 학습 및 팀 프로젝트 목적으로 제작했습니다. 외부 패키지·이미지·모델·서비스 사용 시 해당 라이선스와 이용 조건을 확인합니다.
