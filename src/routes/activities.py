from bson import ObjectId
from fastapi import APIRouter, Body, HTTPException
from pymongo import ReturnDocument
from starlette import status
from starlette.responses import Response

from ..models.activities import ActivityResponse, ActivityCreate, ActivityCollection, ActivityModel, ActivityUpdate
from ..database import activity_collection
from ..logs import logger

router = APIRouter()


@router.post(
    "",
    response_description="Add new activity",
    response_model=ActivityResponse,
    status_code=status.HTTP_201_CREATED,
    response_model_by_alias=False,
)
async def create_activity(activity: ActivityCreate):
    """
    Insert a new record.
    A unique `id` will be created and provided in the response.
    """
    activity = ActivityModel(**activity.model_dump())
    new_activity = await activity_collection.insert_one(activity.model_dump(by_alias=True, exclude={"id"}))
    logger.debug(f"Inserted activity {new_activity}")
    return ActivityResponse(id=new_activity.inserted_id)


@router.get(
    "",
    response_description="List all activities",
    response_model=ActivityCollection,
    response_model_by_alias=False,
)
async def get_activities():
    """
    Get all the activity records from database.
    The response is unpaginated and limited to 1000 results.
    """
    return ActivityCollection(activities=await activity_collection.find().to_list(1000))


@router.get(
    "/{activity_id}",
    response_description="Get the activity with specified activity_id",
    response_model=ActivityModel,
    response_model_by_alias=False,
)
async def get_activity_by_id(activity_id: str):
    """
    Get the record of the activity with specified activity_id.
    """
    if (activity := await activity_collection.find_one({"_id": ObjectId(activity_id)})) is not None:
        return activity

    raise HTTPException(status_code=404, detail=f"Not found")


@router.put(
    "/{activity_id}",
    response_description="Update an activity",
    response_model=ActivityModel,
    response_model_by_alias=False,
)
async def update_activity(activity_id: str, activity: ActivityUpdate = Body(...)):
    """
    Update record of an activity with specified activity_id

    Only the provided fields will be updated.
    Any missing or `null` fields will be ignored.
    """
    activity = {
        k: v for k, v in activity.model_dump(by_alias=True).items() if v is not None
    }

    if len(activity) >= 1:
        update_result = await activity_collection.find_one_and_update(
            {"_id": ObjectId(activity_id)},
            {"$set": activity},
            return_document=ReturnDocument.AFTER,
        )
        if update_result is not None:
            logger.debug(f"Updated activity {update_result}")
            return update_result
        else:
            raise HTTPException(status_code=404, detail=f"Not found")

    # The update is empty, but we should still return the matching document:
    if (existing_activity := await activity_collection.find_one({"_id": activity_id})) is not None:
        logger.debug(f"Activity {existing_activity} not updated")
        return existing_activity

    raise HTTPException(status_code=404, detail=f"Not found")


@router.delete(
    "/{activity_id}",
    response_description="Delete a activity")
async def delete_activity(activity_id: str):
    """
    Remove a single user record from the database.
    """
    delete_result = await activity_collection.delete_one({"_id": ObjectId(activity_id)})

    if delete_result.deleted_count == 1:
        logger.debug(f"Deleted activity {delete_result}")
        return Response(status_code=status.HTTP_204_NO_CONTENT)

    raise HTTPException(status_code=404, detail=f"Not Found")
