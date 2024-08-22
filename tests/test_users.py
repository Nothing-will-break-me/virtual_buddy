import asyncio

import pytest
from httpx import AsyncClient, ASGITransport
from src.main import app

pytest.user_ids = []


@pytest.fixture(scope="session")
def user_data():
    return [
        {"username": "test name 1", "email": "test1@example.com"},
        {"username": "test name 2", "email": "test2@example.com"},
        {"username": "test name 3", "email": "test3@example.com"}
    ]


@pytest.mark.asyncio(scope="session")
@pytest.mark.order(1)
async def test_create(user_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        for user in user_data:
            response = await ac.post("/users", json=user)
            user_id = response.json()["id"]
            assert response.status_code == 201
            assert user_id is not None
            pytest.user_ids.append(user_id)


@pytest.mark.asyncio(scope="session")
async def test_read_user_by_id(user_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        for i, user in enumerate(user_data):
            user_id = pytest.user_ids[i]
            response = await ac.get(f"/users/{user_id}")
            assert response.status_code == 200
            assert response.json() == {"id": user_id, "friends": [], **user_data[i]}


@pytest.mark.asyncio(scope="session")
async def test_read_users(user_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        response = await ac.get("/users")
    assert response.status_code == 200
    for i, obj in enumerate(response.json()["users"]):
        obj.pop("id", None)
        assert obj == {"friends": [], **user_data[i]}


@pytest.mark.asyncio(scope="session")
async def test_update_user(user_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        user_id = pytest.user_ids[0]
        response = await ac.put(f"/users/{user_id}", json={"username": "test name 1 update"})
        assert response.status_code == 200
        user_data[0]["username"] = "test name 1 update"
        assert response.json() == {"id": user_id, "friends": [], **user_data[0]}


@pytest.mark.asyncio(scope="session")
async def test_delete_user(user_data):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost:8000") as ac:
        for i, _ in enumerate(user_data):
            user_id = pytest.user_ids[i]
            response = await ac.delete(f"/users/{user_id}")
            assert response.status_code == 204
            response = await ac.delete(f"/users/{user_id}")
            assert response.status_code == 404
