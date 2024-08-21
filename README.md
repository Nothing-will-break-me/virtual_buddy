## Sample app showing how to use FastAPI + MongoDB in asynchronous manner. 
#### Prerequisites
- python 3.11
- MongoDB Server
- Mongo Shell
```
pip install fastapi[standard] pymongo motor pydantic-settings httpx
```

#### 1. To use it run mongodb server as administrator by prompting: 
```
mongod --port 27017 --bind_ip 127.0.0.1
```
#### 2. Then create database flights with collection flights
```
mongosh
use virtual_buddy_db
db.createCollection("users")
db.createCollection("activities")
```
#### 3. Run python server
```
cd <...>/virtual_buddy_backend
uvicorn src.main:app --reload
```
or
```
cd <...>/virtual_buddy_backend
python -m src.server
```
#### 4. To use API check docs at localhost:8080/docs
