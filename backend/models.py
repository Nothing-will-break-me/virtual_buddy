from datetime import datetime
from typing import Optional, List, Annotated

from bson import ObjectId
from pydantic import BaseModel, Field, ConfigDict, BeforeValidator

PyObjectId = Annotated[str, BeforeValidator(str)]


class FlightModel(BaseModel):
    """
    Container for a single flight record.
    """
    # The primary key for the StudentModel, stored as a `str` on the instance.
    # This will be aliased to `_id` when sent to MongoDB,
    # but provided as `id` in the API requests and responses.
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    departure_country: str = Field(...)
    departure_city: str = Field(...)
    arrival_country: str = Field(...)
    arrival_city: str = Field(...)
    available_seats: int = Field(...)
    date: datetime = Field(...)
    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "departure_country": "Poland",
                "departure_city": "Gdańsk",
                "arrival_country": "Spain",
                "arrival_city": "Madrid",
                "available_seats": 12,
                "date": datetime.now(),
            }
        },
    )


class UpdateFlightModel(BaseModel):
    """
    A set of optional updates to be made to a document in the database.
    """
    departure_country: Optional[str] = None
    departure_city: Optional[str] = None
    arrival_country: Optional[str] = None
    arrival_city: Optional[str] = None
    available_seats: Optional[int] = None
    date: Optional[datetime] = None
    model_config = ConfigDict(
        arbitrary_types_allowed=True,
        json_encoders={ObjectId: str},
        json_schema_extra={
            "example": {
                "departure_country": "Poland",
                "departure_city": "Gdańsk",
                "arrival_country": "Spain",
                "arrival_city": "Madrid",
                "available_seats": 12,
                "date": datetime.now(),
            }
        },
    )


class FlightCollection(BaseModel):
    """
    A container holding a list of `FlightModel` instances.
    This exists because providing a top-level array in a JSON response can be a [vulnerability](https://haacked.com/archive/2009/06/25/json-hijacking.aspx/)
    """

    flights: List[FlightModel]
