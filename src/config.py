from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    mongodb_url: str = "mongodb://localhost:27017/"
    database_name: str = "virtual_buddy_db"

    SERVER_HOST: str = "127.0.0.1"
    SERVER_PORT: int = 8000


settings = Settings()
