@echo off
echo.
echo 🧹 Flutter Build Files Cleanup
echo ===============================

echo 🗑️  Removing build directories...
if exist "build" (
    echo    Removing build directory...
    rmdir /s /q "build" 2>nul
    echo    ✅ build removed
) else (
    echo    ⚪ build not found
)

if exist ".dart_tool" (
    echo    Removing .dart_tool directory...
    rmdir /s /q ".dart_tool" 2>nul
    echo    ✅ .dart_tool removed
) else (
    echo    ⚪ .dart_tool not found
)

if exist "android\.gradle" (
    echo    Removing Android Gradle cache...
    rmdir /s /q "android\.gradle" 2>nul
    echo    ✅ Android Gradle cache removed
) else (
    echo    ⚪ Android Gradle cache not found
)

if exist "android\app\.cxx" (
    echo    Removing Android C++ cache...
    rmdir /s /q "android\app\.cxx" 2>nul
    echo    ✅ Android C++ cache removed
) else (
    echo    ⚪ Android C++ cache not found
)

if exist "android\app\build" (
    echo    Removing Android app build...
    rmdir /s /q "android\app\build" 2>nul
    echo    ✅ Android app build removed
) else (
    echo    ⚪ Android app build not found
)

if exist "pubspec.lock" (
    echo    Removing pubspec.lock...
    del /q "pubspec.lock" 2>nul
    echo    ✅ pubspec.lock removed
) else (
    echo    ⚪ pubspec.lock not found
)

if exist ".flutter-plugins" (
    del /q ".flutter-plugins" 2>nul
    echo    ✅ .flutter-plugins removed
)

if exist ".flutter-plugins-dependencies" (
    del /q ".flutter-plugins-dependencies" 2>nul
    echo    ✅ .flutter-plugins-dependencies removed
)

echo.
echo 🎉 Cleanup completed!
echo 💾 Your disk space has been recovered.
echo.
echo 📋 To prevent future space issues:
echo    • Run 'flutter clean' before each build
echo    • Use the build scripts which include cleanup
echo    • Run this cleanup script regularly
echo.
pause