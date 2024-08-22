import pytest
from src.database import db


@pytest.fixture
def anyio_backend():
    return 'asyncio'


@pytest.fixture(scope="session")
def db_cleanup(request):
    yield
    db.drop_collection("users")
    db.drop_collection("activities")
