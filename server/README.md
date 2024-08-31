## Backend part of the application 
#### Prerequisites
- python 3.11
- MongoDB Server
- Mongo Shell

Application packages
```
pip install fastapi[standard] pymongo motor pydantic-settings httpx pytest pytest-asyncio pytest-order
```

#### 1. To use it run mongodb server as administrator by prompting: 
```
mongod --port 27017 --bind_ip 127.0.0.1
```
#### 2. Then create database and collections with specified names
```
mongosh
use virtual_buddy_db
db.createCollection("users")
db.createCollection("activities")
```
#### 3. Run python server
```
cd <PROJECT_ROOT>/server
uvicorn src.main:app --reload
```
or
```
cd <PROJECT_ROOT>/server
python -m src.server
```
#### 4. To use API check docs at localhost:8080/docs

#### 5. To run the tests
```
cd <PROJECT_ROOT>/server
pytest ./tests -vv
```

### Docker run
```
cd <PROJECT_ROOT>/server
docker build -t vbs .
docker build -t mongo . -f Dockerfile.database
docker-compose up
```
Then you can reach the application the same as in local mode
