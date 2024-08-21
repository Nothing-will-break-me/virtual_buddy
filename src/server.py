import uvicorn

from src.config import settings

if __name__ == "__main__":  # pragma: no cover
    uvicorn.run(
        "src.main:app",
        host=settings.SERVER_HOST,
        port=settings.SERVER_PORT,
        reload=True
    )
