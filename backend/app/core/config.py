from pydantic import SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # 기존 로그인용 JWT 설정
    JWT_SECRET_KEY: str
    JWT_ALGORITHM: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

    # 이메일 발송 설정
    SMTP_SERVER: str = "smtp.naver.com"
    SMTP_PORT: int = 465
    SMTP_USER: str
    SMTP_PASSWORD: SecretStr

    # 이메일 인증번호 저장용 Redis 설정
    REDIS_HOST: str = "127.0.0.1"
    REDIS_PORT: int = 6379

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
    )


settings = Settings()