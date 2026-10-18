from functools import lru_cache
from pathlib import Path

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=Path(__file__).resolve().parent / ".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    db_host: str = Field(default="", validation_alias="DB_HOST")
    db_port: int = Field(default=3306, validation_alias="DB_PORT")
    db_user: str = Field(default="", validation_alias="DB_USER")
    db_password: str = Field(default="", validation_alias="DB_PASSWORD")
    db_name: str = Field(default="", validation_alias="DB_NAME")

    jwt_public_key_path: str = Field(validation_alias="JWT_PUBLIC_KEY_PATH")

    openai_api_key: str = Field(default="", validation_alias="OPENAI_API_KEY")
    embedding_model: str = Field(
        default="text-embedding-3-small",
        validation_alias="EMBEDDING_MODEL",
    )

    groq_api_key: str = Field(validation_alias="GROQ_API_KEY")
    llm_model: str = Field(default="qwen/qwen3.8-27b", validation_alias="LLM_MODEL")
    llm_timeout_seconds: float = Field(
        default=30.0,
        validation_alias="LLM_TIMEOUT_SECONDS",
    )

    cors_origins: str = Field(
        default="http://localhost,http://127.0.0.1",
        validation_alias="CORS_ORIGINS",
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()
