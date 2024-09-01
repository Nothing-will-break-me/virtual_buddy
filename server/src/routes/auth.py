from datetime import timedelta
from typing import Annotated

from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm
from starlette.exceptions import HTTPException

from ..config import settings
from ..security import get_password_hash, verify_password, create_access_token
from ..database import user_collection
from ..models.auth import UserRegister, Token
from ..models.users import UserModel

router = APIRouter()


@router.post("/login")
async def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()]) -> Token:
    user_dict = await user_collection.find_one({"username": form_data.username})
    if not user_dict:
        # Actually, wrong username
        raise HTTPException(status_code=400, detail=f"Incorrect username or password")
    user = UserModel(**user_dict)
    if not verify_password(form_data.password, user.hashed_password):
        # Wrong password
        raise HTTPException(status_code=400, detail=f"Incorrect username or password")
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": user.id}, expires_delta=access_token_expires)
    return Token(access_token=access_token, token_type="bearer")


@router.post("/register")
async def register_user(new_user: UserRegister):
    user_in_db = await user_collection.find_one({"username": new_user.username})
    if user_in_db:
        raise HTTPException(status_code=400, detail=f"User with specified username already exists!")
    new_user.password = get_password_hash(new_user.password)
    new_user = UserModel(**new_user.model_dump())
    await user_collection.insert_one(new_user.model_dump(exclude={"id"}))
    return {"message": "User registered successfully."}
