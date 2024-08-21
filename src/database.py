import motor.motor_asyncio
from src.config import settings


client = motor.motor_asyncio.AsyncIOMotorClient(settings.mongodb_url)
db = client[settings.database_name]
user_collection = db.get_collection("users")
activity_collection = db.get_collection("activities")
