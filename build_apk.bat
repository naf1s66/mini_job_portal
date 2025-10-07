@echo off
setlocal enabledelayedexpansion

echo.
echo 🚀 Job Portal APK Build Script
echo ================================

REM Check if Flutter is available
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter not found in PATH
    echo Please ensure Flutter is installed and in your PATH
    pause
    exit /b 1
)
echo ✅ Flutter is available

REM Clean project
echo.
echo 🧹 Cleaning project...
if exist "build" rmdir /s /q "build" >nul 2>&1
if exist ".dart_tool" rmdir /s /q ".dart_tool" >nul 2>&1
if exist "pubspec.lock" del /q "pubspec.lock" >nul 2>&1
echo ✅ Project cleaned

REM Get dependencies
echo.
echo 📦 Getting dependencies...
flutter pub get
if errorlevel 1 (
    echo ❌ Failed to get dependencies
    echo Check your internet connection and pubspec.yaml
    pause
    exit /b 1
)
echo ✅ Dependencies resolved

REM Build APK
echo.
echo 🔨 Building APK...
flutter build apk --debug
if errorlevel 1 (
    echo ❌ APK build failed
    echo Check the error messages above
    pause
    exit /b 1
)

REM Verify APK
set "apkPath=build\app\outputs\flutter-apk\app-debug.apk"
if exist "%apkPath%" (
    echo ✅ APK created successfully!
    echo    Location: %apkPath%
    for %%A in ("%apkPath%") do (
        set /a "apkSizeMB=%%~zA/1048576"
        echo    Size: !apkSizeMB! MB
    )
) else (
    echo ❌ APK not found at expected location
    pause
    exit /b 1
)

echo.
echo 🎉 Build completed successfully!
echo You can now install the APK on your device or emulator.
echo.
pause