<<Instrukcja na podstawie https://pub.dev/packages/flutter_unity_widget>>

1. Otworzyć projekt AvatarsApp w Unity 2022.3.6f1 (inne wersje nie były testowane)
2. W projekcie zaimportować unitypackage ze ścieżki <PROJECT_ROOT>/frontend/unity/<xxx>.unitypackage
    - W projekcie na górnym pasku narzędzi trzeba kliknąć: Assets -> Import Package -> Custom Package -> wybór powyższego pliku
3. Podmienić Build.cs, aby uniknąć niżej wymienionych błędów
    - podmienić ten ze ścieżki <PROJECT_ROOT>/frontend/unity/AvatarsApp/Assets/FlutterUnityIntegration/Editor/Build.cs na ten ze ścieżki <PROJECT_ROOT>/frontend/unity/Build.cs
    - Błąd UnityThemeSelector not found: https://github.com/juicycleff/flutter-unity-view-widget/issues/942
    - Błąd z crashem działającej aplikacji: https://github.com/juicycleff/flutter-unity-view-widget/issues/760
4. Instalacja Android SDK 35 (Wymóg Google Play):
    - W Android Studio: Settings -> System Settings -> Android SDK -> SDK Platforms -> Android API 35 oraz SDK Tools -> Android SDK Build-Tools 35
    - Wyłączyć Unity
    - wejść w folder <...>/AppData/Local/Android/Sdk i przekopiować zawwartość folderów platforms i platforms-tools do ścieżki <UNITY_VERSION_ROOT>\Editor\Data\PlaybackEngines\AndroidPlayer\SDK 
    - pewnie da się jakoś w Unity ustawić, żeby brał SDK bezpośrednio z Android Studio, ale nie chciało mi się tego rozkminiać
5. Wrócić do Unity i ustawić odpowiednie rzeczy w ustawieniach projektu
    - W projekcie na górnym pasku narzędzi: Edit -> Project Settings -> Player -> (Zakładka z robocikiem Androida) -> Other Settings
        - Pod zakładką Identification: Target API Level ustawić na API Level 35 oraz Minimum API Level na Android 9.0 'Pie' (API Level 28)
        - Pod zakładką Configuration: Scripting Backend -> IL2CPP
        - Pod zakładką Configuration: Target Architectures -> Zaznaczone ARMv7 i ARM64
        - Pod zakładką Configuration: Active Input Handling* -> Input Manager (Old) - nowy Input Manager ma podobno problemy
    - W tym samym oknie, ale dla iOS:
        - Pod zakładką Configuration: Target SDK -> Device SDK
    - W tym samym oknie, ale WebGL (ostatnia zakładka po prawej)
        - Pod zakładką Publishing Settings: Compression Format -> Disabled
    - File -> Build Settings -> na górze powinna być wylistowana MainScene (jeżeli nie jest trzeba ją dodać)
6. Aby wyeksportować projekt -> Na górze na pasku narzędzi: Flutter -> Export Android/iOS/WebGL w zależności od platformy 20:22
7. Do ustawień pod iOS trzeba mieć Maca z XCode, więcej info co ustawić w https://pub.dev/packages/flutter_unity_widget
