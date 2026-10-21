from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    db_host: str = "127.0.0.1"
    db_port: int = 3306
    db_user: str = "angel"
    db_password: str = ""
    db_name: str = "u417714339_Lovemakeupbd"

    jwt_secret: str
    jwt_algorithm: str = "HS256"

    # Toda la IA pasa por OpenRouter con un único cliente compatible con OpenAI:
    # embeddings (Qwen3-Embedding) y redacción (modelo de chat de Qwen).
    openrouter_api_key: str = ""
    openrouter_base_url: str = "https://openrouter.ai/api/v1"
    embedding_model: str = "qwen/qwen3-embedding-0.6b"
    embedding_dim: int = 1024  # debe coincidir con EMBEDDING_MODEL y con VECTOR(N)

    llm_model: str = "qwen/qwen3-30b-a3b:free"
    llm_timeout_seconds: float = 3.0

    cors_origins: str = "http://localhost,http://127.0.0.1"


@lru_cache
def get_settings() -> Settings:
    return Settings()
