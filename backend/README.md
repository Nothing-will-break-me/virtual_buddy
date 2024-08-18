## Sample app showing how to use FastAPI + MongoDB in asynchronous manner. 
#### Prerequisites
- python 3.11
- MongoDB Server
```
pip install fastapi[standard] pymongo motor
```

#### 1. To use it run mongodb server as administrator by prompting: 
```
mongod --port 27017 --bind_ip 127.0.0.1
```
#### 2. Then create database flights with collection flights
#### 3. Run python server
```
cd <...>/virtual_buddy/backend
uvicorn main:app --reload
```
#### 4. To use API check docs at localhost:8080/docs