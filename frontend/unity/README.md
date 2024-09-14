## Unity-based AvatarsApp part of the application
#### Instruction based on https://pub.dev/packages/flutter_unity_widget
#### Prerequisites
- Unity 2022.3.6f1 (2023 won't work for sure)
- Android Studio

### 1. Open Project AvatarsApp in Unity
   - from path `<PROJECT_ROOT>/frontend/unity/AvatarsApp`
   - then import `<PROJECT_ROOT>/frontend/unity/fuw-2022.2.0.unitypackage` from upper menu: Assets -> Import Package -> Custom Package

### 2. Swap Build.cs to avoid errors linked below
```cmd
cp <PROJECT_ROOT>/frontend/unity/Build.cs <PROJECT_ROOT>/frontend/unity/AvatarsApp/Assets/FlutterUnityIntegration/Editor/Build.cs
```
   - Error: UnityThemeSelector not found: https://github.com/juicycleff/flutter-unity-view-widget/issues/942
   - Error with crash: https://github.com/juicycleff/flutter-unity-view-widget/issues/760

### 3. Install Android SDK 35 (Google Play requirement)
   - In Android Studio: Settings -> System Settings -> Android SDK -> SDK Platforms -> Android API 35 and SDK Tools -> Android SDK Build-Tools 35
   - Exit Unity
   - Copy folder `platforms` and `platforms-tools` from Android Studio to Unity
   ```cmd
      cp <...>/AppData/Local/Android/Sdk/platforms <UNITY_VERSION_ROOT>\Editor\Data\PlaybackEngines\AndroidPlayer\SDK\platforms 
      cp <...>/AppData/Local/Android/Sdk/platforms-tools <UNITY_VERSION_ROOT>\Editor\Data\PlaybackEngines\AndroidPlayer\SDK\platforms-tools 
   ```
   - AppData can be reached via Win+R %appdata% and UNITY_VERSION_ROOT is where specific Unity version is installed

### 4. Back to Unity and configure Project Settings
- from upper menu: Edit -> Project Settings -> Player -> (Icon with Android robot) -> Other Settings
  - Under Identification: Set Target API Level to `API Level 35` and Minimum API Level to `Android 9.0 'Pie' (API Level 28)`
  - Under Configuration:
    - Set Scripting Backend to `IL2CPP`
    - Set Target Architectures to `ARMv7` and `ARM64`
    - Set Active Input Handling* to `Input Method (old)` https://github.com/juicycleff/flutter-unity-view-widget/pull/958/files
  - (Icon with iOS) -> Other Settings
    - Under Configuration: Target SDK -> Device SDK
  - (Icon with WebGL (last at the right side)) -> Publishing Settings
    - Compression Format -> Disabled
- Then Add MainScene to the build via: File -> Build Settings

### 5. Export a project to the desired platform
- from the upper menu: Flutter -> Export Android/iOS/WebGL
- For Android: if info about SDK 41 pops up just accept highest available (it's a bug)
