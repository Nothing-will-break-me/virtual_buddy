from datetime import datetime

from typing import Optional, List, Annotated

from pydantic import BaseModel, Field, ConfigDict, BeforeValidator

PyObjectId = Annotated[str, BeforeValidator(str)]


class ActivityModel(BaseModel):
    """
    Container for a single database record.
    """
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    user_id: PyObjectId = Field(description="The ID of the activity owner", default=None)
    addition_date: datetime = Field(description="Date of addition of the activity", default=datetime.now())
    start_time: datetime = Field(description="Start time of the activity", default=None)
    end_time: datetime = Field(description="End time of the activity", default=None)
    type: str = Field(description="Type of the activity", default=None)
    title: str = Field(description="Title of the activity", default=None)
    description: Optional[str] = Field(description="Description of the activity", default=None)

    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "user_id": "21smj0-dj38bncv31nc93",
                "addition_date": "2024-08-20 16:23:35",
                "start_time": "2024-08-20 15:27:21",
                "end_time": "2024-08-20 16:22:46",
                "type": "Running",
                "title": "Workout",
                "description": "Awesome weather and awesome running. I love running",
            }
        },
    )

    def __repr__(self):
        return f"<Activity(id={self.id}, title={self.title})>"


class ActivityCreate(BaseModel):
    """
    Schema for POST request
    """
    user_id: PyObjectId
    start_time: datetime
    end_time: datetime
    type: str
    title: str
    description: str


class ActivityUpdate(BaseModel):
    """
    A set of optional updates to be made to a document in the database.
    """
    title: Optional[str] = None
    description: Optional[str] = None


class ActivityResponse(BaseModel):
    """
    A container holding object returned in response for a POST request
    """
    id: PyObjectId = Field(default=None)


class ActivityCollection(BaseModel):
    """
    A container holding a list of `UserModel` instances.
    This exists because providing a top-level array in a JSON response can be a [vulnerability](https://haacked.com/archive/2009/06/25/json-hijacking.aspx/)
    """

    activities: List[ActivityModel]
