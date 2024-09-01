import os

from pydantic_settings import BaseSettings, SettingsConfigDict
from .logs import log


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file="./env/.env.dev", env_file_encoding="utf-8", case_sensitive=True
    )

    PROJECT_NAME: str
    API_VERSION: str
    ENV: str

    LOG_CONFIG: str

    MONGODB_URL: str
    DB_NAME: str

    SERVER_HOST: str
    SERVER_PORT: int

    SECRET_KEY: str
    ALGORITHM: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int

    def __repr__(self):
        text = "\nSettings:\n"
        for attr, value in self.__dict__.items():
            text += f"   {attr}: {value}\n"
        return text


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
    supported_envs = ["dev", "test"]
    log(__name__, "INFO", f"Loading settings for {env.lower()}")
    if env.lower() in "dev":
        return ContainerDevSettings()
    elif env.lower() in "test":
        return ContainerTestSettings()
    raise ValueError(f"Unrecognized env type. Supported are {supported_envs}")


_env = os.environ.get("ENV", "dev")
settings = get_settings(env=_env)
