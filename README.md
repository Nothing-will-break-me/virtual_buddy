## Virtual buddy
#### Prerequisites
- python 3.11
- MongoDB Server
- Mongo Shell
- Flutter 3.24.1

To use the application create virtualenv and install packages for backend
```
cd <PROJECT_ROOT>/server
python -m venv venv
venv/Scripts/activate.bat
pip install fastapi[standard] pymongo motor pydantic-settings httpx pytest pytest-asyncio pytest-order pyjwt passlib bcrypt==4.0.1
```

#### 1. Run mongodb server inside cmd as administrator by prompting: 
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
#### 3. Run the server
```
cd <PROJECT_ROOT>/server
python -m src.server
```

### Docker run
```
cd <PROJECT_ROOT>/server
docker build -t vbs .
docker build -t mongo . -f Dockerfile.database
docker-compose up
```

### Reach the application
```
cd <ROOT>/frontend
flutter run
```
