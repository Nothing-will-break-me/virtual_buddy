from typing import Optional, List, Annotated
from pydantic import BaseModel, Field, ConfigDict, BeforeValidator, EmailStr

PyObjectId = Annotated[str, BeforeValidator(str)]


class FriendModel(BaseModel):
    id: str = Field(..., description="The ID of the friendly user")


class UserModel(BaseModel):
    """
    Container for a single database record.
    """
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    username: str = Field(description="Username", default=None)
    email: EmailStr = Field(description="User email", default=None)
    friends: List[FriendModel] = Field(default_factory=list, description="List of user's friends")
    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "name": "John",
                "surname": "Doe",
                "email": "john.doe@domain.com",
                "friends": [
                    {
                        "id": "fdha3289-kdflsn32s3jf90g21"
                    }
                ],
            }
        },
    )

    def __repr__(self):
        return f"<User(id={self.id})>"


class UserCreate(BaseModel):
    """
    Schema for POST request
    """
    username: str
    email: EmailStr


class UserUpdate(BaseModel):
    """
    A set of optional updates to be made to a document in the database.
    """
    username: Optional[str] = None
    email: Optional[EmailStr] = None


class UserResponse(BaseModel):
    """
    A container holding object returned in response for a POST request
    """
    id: PyObjectId = Field(default=None)


class UserCollection(BaseModel):
    """
    A container holding a list of `UserModel` instances.
    This exists because providing a top-level array in a JSON response can be a [vulnerability](https://haacked.com/archive/2009/06/25/json-hijacking.aspx/)
    """

    users: List[UserModel]
