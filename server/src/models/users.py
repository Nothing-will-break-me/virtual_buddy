from typing import Optional, List, Annotated
from pydantic import BaseModel, Field, ConfigDict, BeforeValidator, EmailStr

PyObjectId = Annotated[str, BeforeValidator(str)]


class UserModel(BaseModel):
    """
    Container for a single database record.
    """
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    username: str = Field(description="Username", default=None)
    hashed_password: str = Field(alias="password", description="Hashed password", default=None)
    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "username": "John",
                "password": "John's password",
            }
        },
    )

    def __repr__(self):
        return f"<User(id={self.id})>"


class UserUpdate(BaseModel):
    """
    A set of optional updates to be made to a document in the database.
    """
    username: Optional[str] = None
    password: Optional[str] = None


class UserCollection(BaseModel):
    """
    A container holding a list of `UserModel` instances.
    This exists because providing a top-level array in a JSON response can be a [vulnerability](https://haacked.com/archive/2009/06/25/json-hijacking.aspx/)
    """

    users: List[UserModel]
