# Job Portal APK Build Instructions

## Overview
This document provides instructions for building the Job Portal APK after fixing dependency issues.

## Fixed Issues
- ✅ Updated `path_provider` from `^2.1.4` to `^2.1.1` to resolve version conflicts
- ✅ Updated other dependencies to more stable versions
- ✅ Created automated build scripts for different platforms

## Build Scripts Available

### Windows PowerShell (Recommended)
```powershell
.\build_apk.ps1
```

### Windows Batch File
```cmd
build_apk.bat
```

### Linux/Mac Shell Script
```bash
chmod +x build.sh
./build.sh
```

## Manual Build Process

If you prefer to build manually:

1. **Clean the project:**
   ```bash
   flutter clean
   rm -rf .dart_tool pubspec.lock
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Build APK:**
   ```bash
   flutter build apk --debug
   ```

## Dependency Changes Made

The following dependencies were updated in `pubspec.yaml`:

| Package | Old Version | New Version | Reason |
|---------|-------------|-------------|---------|
| cupertino_icons | ^1.0.8 | ^1.0.6 | Stability |
| http | ^1.2.2 | ^1.1.0 | Compatibility |
| provider | ^6.1.2 | ^6.1.1 | Stability |
| crypto | ^3.0.5 | ^3.0.3 | Compatibility |
| path_provider | ^2.1.4 | ^2.1.1 | **Fix for build error** |

## Troubleshooting

### If build still fails:

1. **Clear Flutter cache:**
   ```bash
   flutter pub cache clean
   flutter pub get
   ```

2. **Update Flutter:**
   ```bash
   flutter upgrade
   ```

3. **Check Android SDK:**
   ```bash
   flutter doctor
   ```

### Common Issues:

- **"Could not find path_provider_android"**: The dependency versions have been fixed
- **"Build failed with Gradle"**: Run `flutter clean` and try again
- **"Flutter not found"**: Ensure Flutter is in your PATH

## Output

Successful build will create:
```
build/app/outputs/flutter-apk/app-debug.apk
```

## Installation

To install on device/emulator:
```bash
flutter install
```

Or manually install the APK:
```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```