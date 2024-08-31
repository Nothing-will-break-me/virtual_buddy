import motor.motor_asyncio
from .config import settings


client = motor.motor_asyncio.AsyncIOMotorClient(settings.MONGODB_URL)
db = client[settings.DB_NAME]
user_collection = db.get_collection("users")
activity_collection = db.get_collection("activities")
