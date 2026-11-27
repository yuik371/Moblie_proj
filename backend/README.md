# 가상환경

버전: python 3.13.17

가상환경 실행:
```
venv/Scripts/activate
```

가상환경 종료:
```
deactivate
```

패키지 정보 저장:
```
pip freeze > requirements.txt
```

# 실행 방법

프로젝트 폴더에서 다음 코드 실행
```
venv/Scripts/activate
uvicorn app.main:app --reload
```

# schemas 폴더

요청 Body와 BaseModel 클래스를 연결

# models

데이터베이스의 테이블 구조를 정의