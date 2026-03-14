# TrackMyHabit

Small app to get daily notifications and track stats.

## Problems / Fixes

1.  **JDK 17 not installed**

    ``` bash
    sudo pacman -S jdk17-openjdk
    ```

2.  **Flutter not using JDK 17**

    ``` bash
    flutter config --jdk-dir=/usr/lib/jvm/java-17-openjdk
    ```

3.  **Flutter tool Gradle cache is in an inaccessible system folder**
    Fix permissions for Flutter's internal Gradle cache directory:

    ``` bash
    sudo mkdir -p /usr/lib/flutter/packages/flutter_tools/gradle/.gradle
    sudo chown -R "$USER":"$USER" /usr/lib/flutter/packages/flutter_tools/gradle/.gradle
    ```

    Optional: reset the broken Kotlin cache/sessions:

    ``` bash
    rm -rf /usr/lib/flutter/packages/flutter_tools/gradle/.gradle/kotlin
    ```

4.  **Android emulator fails on Wayland (Qt wayland plugin missing in
    SDK emulator)** Workaround: run emulator through XWayland (`xcb`)
    and disable Vulkan:

    ``` bash
    export QT_QPA_PLATFORM=xcb
    $ANDROID_SDK_ROOT/emulator/emulator -avd Pixel_2 -feature -Vulkan
    ```

    If Qt complains about missing xcb cursor library:

    ``` bash
    sudo pacman -S xcb-util-cursor
    ```
5.  Start with `flutter run` in hello_world 