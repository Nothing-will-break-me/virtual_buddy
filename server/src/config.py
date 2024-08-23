import os

from pydantic_settings import BaseSettings, SettingsConfigDict
from src.logs import logger


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file="./env/.env.dev", env_file_encoding="utf-8", case_sensitive=True
    )

    PROJECT_NAME: str
    API_VERSION: str
    ENV: str

    MONGODB_URL: str
    DB_NAME: str

    SERVER_HOST: str
    SERVER_PORT: int


class ContainerDevSettings(Settings):
    model_config = SettingsConfigDict(
        env_file="./env/.env.dev", env_file_encoding="utf-8", case_sensitive=True
    )
    ENV: str = "dev"


class ContainerTestSettings(Settings):
    model_config = SettingsConfigDict(
        env_file="./env/.env.test", env_file_encoding="utf-8", case_sensitive=True
    )
    ENV: str = "test"


def get_settings(env: str = "dev") -> Settings:
    logger.debug(f"Getting settings for env: {env}")
    supported_envs = ["dev", "test"]

    if env.lower() in "dev":
        return ContainerDevSettings()
    elif env.lower() in "test":
        logger.info(os.getcwd())
        return ContainerTestSettings()
    raise ValueError(f"Unrecognized env type. Supported are {supported_envs}")


_env = os.environ.get("ENV", "dev")
settings = get_settings(env=_env)
