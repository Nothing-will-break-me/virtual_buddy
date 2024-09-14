## Server of the application 
#### Prerequisites
- python 3.11
- MongoDB Server
- Mongo Shell
- openssl

Application packages
```cmd
pip install fastapi[standard] pymongo motor pydantic-settings httpx pytest pytest-asyncio pytest-order pyjwt passlib bcrypt==4.0.1
```

#### 1. To use it run mongodb server as administrator
```cmd
mongod --port 27017 --bind_ip 127.0.0.1
```
#### 2. Then create database and collections with specified names
```cmd
mongosh
use virtual_buddy_db
db.createCollection("users")
db.createCollection("activities")
```

#### 3. Generate self-signed certificates as administrator
```cmd
cd <PROJECT_ROOT>/server
mkdir certs
openssl req -x509 -newkey rsa:4096 -nodes -out certs/cert.pem -keyout certs/key.pem -days 365 \ 
-subj "/C=PL/ST=Pomeranian/L=Gdansk/O=Nothing Will Break Me/OU=IT Department/CN=localhost" \
-addext "subjectAltName = DNS:localhost"
openssl x509 -outform der -in certs/cert.pem -out certs/cert.crt
certutil -addstore my certs/cert.pem 
```
Then go to chrome://settings/security -> Advanced -> Manage Certificates -> Import
and import <PROJECT_ROOT>/server/certs/cert.crt

#### 4. Run python server
```cmd
cd <PROJECT_ROOT>/server
python -m src.server
```
#### 5. Reach the application
- to use API check https://localhost:8000/docs
- to run the Client check [How to build Client](../frontend/README.md) 

#### Tests run
```cmd
cd <PROJECT_ROOT>/server
pytest ./tests -vv
```

### Docker run
```cmd
cd <PROJECT_ROOT>/server
docker build -t vbs .
docker build -t mongo . -f Dockerfile.database
docker-compose up
```
