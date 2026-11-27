from pydantic import BaseModel, EmailStr, Field

class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8)
    nickname: str = Field(min_length=2, max_length=20)

class UserLogin(BaseModel):
    email: EmailStr
    password: str
    