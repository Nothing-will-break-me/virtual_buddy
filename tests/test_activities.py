from datetime import datetime, timedelta

import pytest
from httpx import AsyncClient, ASGITransport
from src.main import app

pytest.activity_ids = []


@pytest.fixture(scope="session")
def activity_data():
    start_time = datetime.now().replace(microsecond=0).strftime("%Y-%m-%dT%H:%M:%S")
    end_time = (datetime.now().replace(microsecond=0) + timedelta(minutes=20)).strftime("%Y-%m-%dT%H:%M:%S")
    return [
        {"user_id": "1", "start_time": start_time, "end_time": end_time, "type": "Running",
         "title": "Workout", "description": "Morning run"},
    ]


@pytest.mark.asyncio(scope="session")
@pytest.mark.order(1)
async def test_create(activity_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        for activity in activity_data:
            response = await ac.post("/activities", json=activity)
            activity_id = response.json()["id"]
            assert response.status_code == 201
            assert activity_id is not None
            pytest.activity_ids.append(activity_id)


@pytest.mark.asyncio(scope="session")
async def test_read_activity_by_id(activity_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        for i, activity in enumerate(activity_data):
            activity_id = pytest.activity_ids[i]
            response = await ac.get(f"/activities/{activity_id}")
            body = response.json()
            assert response.status_code == 200
            assert "addition_date" in body.keys()
            body.pop("addition_date", None)
            assert body == {"id": activity_id, **activity_data[i]}


@pytest.mark.asyncio(scope="session")
async def test_read_activities(activity_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        response = await ac.get("/activities")
    assert response.status_code == 200
    for i, obj in enumerate(response.json()["activities"]):
        obj.pop("id", None)
        obj.pop("addition_date", None)
        assert obj == activity_data[i]


@pytest.mark.asyncio(scope="session")
async def test_update_activity(activity_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        activity_id = pytest.activity_ids[0]
        response = await ac.put(f"/activities/{activity_id}", json={"title": "New title"})
        assert response.status_code == 200
        activity_data[0]["title"] = "New title"
        body = response.json()
        body.pop("addition_date", None)
        assert body == {"id": activity_id, **activity_data[0]}


@pytest.mark.asyncio(scope="session")
async def test_delete_activity(activity_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        for i, _ in enumerate(activity_data):
            activity_id = pytest.activity_ids[i]
            response = await ac.delete(f"/activities/{activity_id}")
            assert response.status_code == 204
            response = await ac.delete(f"/activities/{activity_id}")
            assert response.status_code == 404
