from fastapi import FastAPI
from .routes import (
    users,
    activities,
    auth,
)


app = FastAPI(title="Virtual Buddy API", version="0.0.1dev")
app.include_router(users.router, prefix="/users")
app.include_router(activities.router, prefix="/activities")
app.include_router(auth.router, prefix="/auth")
