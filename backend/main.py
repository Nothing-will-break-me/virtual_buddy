import logging
import os

from bson import ObjectId
from fastapi import FastAPI, Body, status, HTTPException
import motor.motor_asyncio
from pymongo import ReturnDocument
from starlette.responses import Response

from models import FlightModel, FlightCollection, UpdateFlightModel

app = FastAPI(
    title="Minimal async example of FastAPI with MongoDB",
    summary="A sample application showing how to use FastAPI to add a ReST API to a MongoDB collection in asynchronous"
            "manner. "
)
os.environ["MONGODB_URL"] = 'mongodb://127.0.0.1:27017'
client = motor.motor_asyncio.AsyncIOMotorClient(os.environ["MONGODB_URL"])
db = client.flights
flight_collection = db.get_collection("flights")

logger = logging.getLogger('uvicorn.error')
logger.setLevel(logging.DEBUG)


@app.post(
    "/flights/",
    response_description="Add new student",
    response_model=FlightModel,
    status_code=status.HTTP_201_CREATED,
    response_model_by_alias=False,
)
async def create_flight(flight: FlightModel = Body(...)):
    """
    Insert a new flight record.
    A unique `id` will be created and provided in the response.
    """
    new_flight = await flight_collection.insert_one(flight.model_dump(by_alias=True, exclude={"id"}))
    created_flight = await flight_collection.find_one({"_id": new_flight.inserted_id})
    return created_flight


@app.get(
    "/flights/",
    response_description="List all flights",
    response_model=FlightCollection,
    response_model_by_alias=False,
)
async def list_flights():
    """
    List all the flight data in the database.
    The response is unpaginated and limited to 1000 results.
    """
    return FlightCollection(flights=await flight_collection.find().to_list(1000))


@app.get(
    "/flights/{flight_id}",
    response_description="Get a single flight",
    response_model=FlightModel,
    response_model_by_alias=False,
)
async def show_flight(flight_id: str):
    """
    Get the record for a specific flight, looked up by `flight_id`.
    """
    logger.debug('show_flight(): ')
    if (flight := await flight_collection.find_one({"_id": ObjectId(flight_id)})) is not None:
        return flight

    raise HTTPException(status_code=404, detail=f"Flight {flight_id} not found")


@app.put(
    "/flights/{flight_id}",
    response_description="Update a flight",
    response_model=FlightModel,
    response_model_by_alias=False,
)
async def update_flight(flight_id: str, flight: UpdateFlightModel = Body(...)):
    """
    Update individual fields of an existing flight record.

    Only the provided fields will be updated.
    Any missing or `null` fields will be ignored.
    """
    flight = {
        k: v for k, v in flight.model_dump(by_alias=True).items() if v is not None
    }

    if len(flight) >= 1:
        update_result = await flight_collection.find_one_and_update(
            {"_id": ObjectId(flight_id)},
            {"$set": flight},
            return_document=ReturnDocument.AFTER,
        )
        if update_result is not None:
            return update_result
        else:
            raise HTTPException(status_code=404, detail=f"Flight {flight_id} not found")

    # The update is empty, but we should still return the matching document:
    if (existing_flight := await flight_collection.find_one({"_id": flight_id})) is not None:
        return existing_flight

    raise HTTPException(status_code=404, detail=f"Student {flight_id} not found")


@app.delete("/flights/{flight_id}", response_description="Delete a flight")
async def delete_flight(flight_id: str):
    """
    Remove a single student record from the database.
    """
    delete_result = await flight_collection.delete_one({"_id": ObjectId(flight_id)})

    if delete_result.deleted_count == 1:
        return Response(status_code=status.HTTP_204_NO_CONTENT)

    raise HTTPException(status_code=404, detail=f"Flight {flight_id} not found")
