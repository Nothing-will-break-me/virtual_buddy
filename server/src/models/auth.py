from typing import Optional

from pydantic import BaseModel


class UserRegister(BaseModel):
    username: str
    password: str


class Token(BaseModel):
    """Bearer Access Token"""

    access_token: str
    token_type: str


class TokenPayload(BaseModel):
    """Payload for Bearer Access Token"""

    sub: Optional[str] = None
