from functools import lru_cache
from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # Ruta relativa a este archivo, no al directorio de ejecución
    model_config = SettingsConfigDict(
        env_file=Path(__file__).resolve().parent / ".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    db_host: str = "127.0.0.1"
    db_port: int = 3306
    db_user: str = "angel"
    db_password: str = ""
    db_name: str = "u417714339_Lovemakeupbd"

    # El JWT lo firma el PHP con RS256 (Lovemakeup-3.0/config/jwt_private.pem);
    # este servicio solo verifica la firma con la llave pública.
    jwt_algorithm: str = "RS256"
    jwt_public_key: str = ""  # PEM público; ruta relativa a este repositorio (JWT_PUBLIC_KEY)
    jwt_secret: str = ""  # solo para el modo legado HS256

    # Toda la IA pasa por OpenRouter con un único cliente compatible con OpenAI:
    # embeddings (baai/bge-m3, 1024 dims nativas) y redacción (chat de Qwen).
    openrouter_api_key: str = ""
    openrouter_base_url: str = "https://openrouter.ai/api/v1"
    embedding_model: str = "baai/bge-m3"
    embedding_dim: int = 1024  # debe coincidir con EMBEDDING_MODEL y con VECTOR(N)

    llm_model: str = "qwen/qwen3-30b-a3b-instruct-2507"
    llm_timeout_seconds: float = 6.0

    cors_origins: str = "http://localhost,http://127.0.0.1"


@lru_cache
def get_settings() -> Settings:
    return Settings()
