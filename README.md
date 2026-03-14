# TrackMyHabit

Small app to get daily notifications and track stats.

---

# Setup Problems / Fixes

## 1. JDK 17 not installed

Install the required JDK:

```bash
sudo pacman -S jdk17-openjdk
```

---

## 2. Flutter not using JDK 17

Configure Flutter to use the correct JDK:

```bash
flutter config --jdk-dir=/usr/lib/jvm/java-17-openjdk
```


## 4. Android emulator fails on Wayland
(Qt Wayland plugin missing in SDK emulator)

Workaround: run the emulator through **XWayland (`xcb`)** and disable **Vulkan**.

```bash
export QT_QPA_PLATFORM=xcb
$ANDROID_SDK_ROOT/emulator/emulator -avd Pixel_2 -feature -Vulkan
```

If Qt complains about a missing **xcb cursor library**:

```bash
sudo pacman -S xcb-util-cursor
```

---

## 5. Gradle version

Ensure the following line exists in:

```
hello_world/android/gradle/wrapper/gradle-wrapper.properties
```

```
distributionUrl=https://services.gradle.org/distributions/gradle-8.7-all.zip
```

---

## 6. Flutter installed via AUR (permission issue)

```bash
sudo chown -R "$USER:$USER" /usr/lib/flutter/packages/flutter_tools/gradle
```

This was a problem because Flutter was installed via AUR as **root**.
I still prefer this setup because **updates work through pacman**.

---

# Running the App

Start the app from the project directory:

```bash
flutter run
```

Inside:

```
hello_world
```
