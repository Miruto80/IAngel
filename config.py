from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    db_host: str = "127.0.0.1"
    db_port: int = 3306
    db_user: str = "angel"
    db_password: str = ""
    db_name: str = "lovemakeup"

    jwt_secret: str
    jwt_algorithm: str = "HS256"

    openai_api_key: str = ""
    embedding_model: str = "text-embedding-3-small"  # 1536 dimensiones

    anthropic_api_key: str = ""
    llm_model: str = "claude-haiku-5-5"
    llm_timeout_seconds: float = 1.0

    cors_origins: str = "http://localhost"


@lru_cache
def get_settings() -> Settings:
    return Settings()
