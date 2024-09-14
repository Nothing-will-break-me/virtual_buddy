# Frontend part of the application 
#### Prerequisites
- Flutter 3.24.1
- Built Server [(How to build Server)](../server/README.md)
- Built AvatarsApp (Recommended) [(How to build AvatarsApp)](unity/README.md)

## 1. Run mongodb server as administrator
```cmd
mongod --port 27017 --bind_ip 127.0.0.1
```

## 2. Run application Server
```cmd
cd <PROJECT_ROOT>/server
python -m src.server
```

## 3. Run Client on desired platform

### In Windows
```cmd
flutter run -d windows
```
- Note that AvatarsApp doesn't work under windows

### In Chrome browser
- Make sure you added server's cert.crt to Chrome's trusted certificates. More info [(How to build Server)](../server/README.md)
```cmd
flutter run -d chrome --web-renderer canvaskit --web-port 42765 --web-enable-expression-evaluation
```

### In Android
- You need to enable programmer mode in device's settings
- Then connect device via USB cable and accept RSA fingerprint, which pops up on the device to authorize it
- Check the device id `flutter devices`
- Run the Client `flutter run -d <device_id>`
- Expose Android device port to computer `adb reverse tcp:8000 tcp:8000`
