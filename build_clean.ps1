# Clean Build Script - No Unicode characters

Write-Host "Job Portal APK Build Script" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan

# Check Flutter
if (-not (Get-Command "flutter" -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Flutter not found in PATH" -ForegroundColor Red
    exit 1
}
Write-Host "Flutter is available" -ForegroundColor Green

# Clean project
Write-Host "Cleaning project..." -ForegroundColor Yellow
if (Test-Path "build") { 
    Remove-Item -Recurse -Force "build"
    Write-Host "   Removed build directory" -ForegroundColor Gray
}
if (Test-Path ".dart_tool") { 
    Remove-Item -Recurse -Force ".dart_tool"
    Write-Host "   Removed .dart_tool directory" -ForegroundColor Gray
}
if (Test-Path "android\.gradle") { 
    Remove-Item -Recurse -Force "android\.gradle"
    Write-Host "   Removed Android Gradle cache" -ForegroundColor Gray
}
if (Test-Path "android\app\.cxx") { 
    Remove-Item -Recurse -Force "android\app\.cxx"
    Write-Host "   Removed Android C++ cache" -ForegroundColor Gray
}
if (Test-Path "android\app\build") { 
    Remove-Item -Recurse -Force "android\app\build"
    Write-Host "   Removed Android app build" -ForegroundColor Gray
}
if (Test-Path "pubspec.lock") { 
    Remove-Item -Force "pubspec.lock"
    Write-Host "   Removed pubspec.lock" -ForegroundColor Gray
}

Write-Host "Project cleaned successfully" -ForegroundColor Green

# Get dependencies
Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to get dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "Dependencies resolved successfully" -ForegroundColor Green

# Build APK
Write-Host "Building APK..." -ForegroundColor Yellow
flutter build apk --debug

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: APK build failed" -ForegroundColor Red
    Write-Host "Check the error messages above" -ForegroundColor Red
    exit 1
}

# Verify APK
$apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
if (Test-Path $apkPath) {
    $apkSize = (Get-Item $apkPath).Length
    $apkSizeMB = [math]::Round($apkSize / 1MB, 2)
    
    Write-Host "SUCCESS: APK created!" -ForegroundColor Green
    Write-Host "Location: $apkPath" -ForegroundColor Gray
    Write-Host "Size: $apkSizeMB MB" -ForegroundColor Gray
} else {
    Write-Host "ERROR: APK not found at expected location" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "You can now install the APK on your device or emulator." -ForegroundColor Cyan