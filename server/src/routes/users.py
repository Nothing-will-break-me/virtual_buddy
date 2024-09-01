from typing import Annotated

from bson import ObjectId
from fastapi import APIRouter, Body, HTTPException, Depends
from pymongo import ReturnDocument
from starlette import status
from starlette.responses import Response

from ..dependencies import get_current_user
from ..models.users import UserCollection, UserModel, UserUpdate
from ..database import user_collection
from ..logs import log

router = APIRouter()


@router.get(
    "",
    response_description="List all users",
    response_model=UserCollection,
    response_model_by_alias=False,
)
async def get_users():
    """
    Get all the user records from database.
    The response is unpaginated and limited to 1000 results.
    """
    return UserCollection(users=await user_collection.find().to_list(1000))


@router.get(
    "/{user_id}",
    response_description="Get the user with specified user_id",
    response_model=UserModel,
    response_model_by_alias=False,
)
async def get_user_by_id(user_id: str):
    """
    Get the record of the user with specified user_id.
    """
    if (user := await user_collection.find_one({"_id": ObjectId(user_id)})) is not None:
        return user

    raise HTTPException(status_code=404, detail=f"Not found")


@router.put(
    "/{user_id}",
    response_description="Update a user",
    response_model=UserModel,
    response_model_by_alias=False,
)
async def update_user(user_id: str, user: UserUpdate = Body(...)):
    """
    Update record of an user with specified user_id

    Only the provided fields will be updated.
    Any missing or `null` fields will be ignored.
    """
    user = {
        k: v for k, v in user.model_dump(by_alias=True).items() if v is not None
    }

    if len(user) >= 1:
        update_result = await user_collection.find_one_and_update(
            {"_id": ObjectId(user_id)},
            {"$set": user},
            return_document=ReturnDocument.AFTER,
        )
        if update_result is not None:
            log(__name__, "DEBUG", f"Updated user {update_result}")
            return update_result
        else:
            raise HTTPException(status_code=404, detail=f"Not found")

    # The update is empty, but we should still return the matching document:
    if (existing_user := await user_collection.find_one({"_id": user_id})) is not None:
        log(__name__, "DEBUG", f"User {existing_user} not updated")
        return existing_user

    raise HTTPException(status_code=404, detail=f"Not found")


@router.delete(
    "/{user_id}",
    response_description="Delete a user")
async def delete_user(user_id: str):
    """
    Remove a single user record from the database.
    """
    delete_result = await user_collection.delete_one({"_id": ObjectId(user_id)})

    if delete_result.deleted_count == 1:
        log(__name__, "DEBUG", f"Deleted user {delete_result}")
        return Response(status_code=status.HTTP_204_NO_CONTENT)

    raise HTTPException(status_code=404, detail=f"Not Found")


@router.get(
    "/my/data",
    response_description="Get information about current user",
    response_model=UserModel,)
async def get_users_me(current_user: Annotated[UserModel, Depends(get_current_user)]):
    return current_user
