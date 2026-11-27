from fastapi import FastAPI
from app.routers import auth
from app.routers import users

app = FastAPI()

app.include_router(auth.router, prefix="/api")
app.include_router(users.router, prefix="/api")