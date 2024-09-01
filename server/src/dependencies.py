import jwt
from bson import ObjectId
from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from pydantic import ValidationError
from starlette import status

from .database import user_collection
from .config import settings
from .exceptions import _get_credential_exception
from .models.auth import TokenPayload
from .models.users import UserModel

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")


def get_token(token: str = Depends(oauth2_scheme)) -> TokenPayload:
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        token_data = TokenPayload(**payload)
        if token_data.sub is None:
            raise _get_credential_exception()
    except (jwt.PyJWTError, ValidationError) as e:
        raise _get_credential_exception(status_code=status.HTTP_403_FORBIDDEN) from e
    return token_data


async def get_current_user(token: TokenPayload = Depends(get_token)):
    user_id = token.sub
    user = await user_collection.find_one({"_id": ObjectId(user_id)})
    if user is None:
        raise _get_credential_exception(status_code=status.HTTP_404_NOT_FOUND, details="User not found")
    return UserModel(**user)
