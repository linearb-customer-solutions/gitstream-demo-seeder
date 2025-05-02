from fastapi import FastAPI
from app.auth import router as auth_router

app = FastAPI()
app.include_router(auth_router, prefix="/auth")

@app.get("/")
def healthcheck():
    return {"status": "ok"}
