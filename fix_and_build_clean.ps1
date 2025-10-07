# Quick Fix and Build Script for Job Portal
# Addresses the path_provider_android dependency issue and cleans up space-consuming files

Write-Host "Job Portal Quick Fix & Build" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

# Step 1: Comprehensive cleanup (recovers disk space)
Write-Host "Deep cleaning project (recovering disk space)..." -ForegroundColor Yellow

# Remove main build directories
if (Test-Path "build") { 
    Write-Host "   Removing build directory..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "build" 
}
if (Test-Path ".dart_tool") { 
    Write-Host "   Removing .dart_tool directory..." -ForegroundColor Gray
    Remove-Item -Recurse -Force ".dart_tool" 
}
if (Test-Path "pubspec.lock") { 
    Write-Host "   Removing pubspec.lock..." -ForegroundColor Gray
    Remove-Item -Force "pubspec.lock" 
}

# Remove Android build caches (MAJOR space savers)
if (Test-Path "android\.gradle") { 
    Write-Host "   Removing Android Gradle cache (saves 2-5GB)..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "android\.gradle" 
}
if (Test-Path "android\app\.cxx") { 
    Write-Host "   Removing Android C++ cache (saves 1-3GB)..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "android\app\.cxx" 
}
if (Test-Path "android\app\build") { 
    Write-Host "   Removing Android app build (saves 500MB-2GB)..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "android\app\build" 
}

Write-Host "Deep cleanup completed - significant disk space recovered!" -ForegroundColor Green

# Step 2: Clear pub cache for path_provider specifically
Write-Host "Clearing pub cache..." -ForegroundColor Yellow
flutter pub cache clean

# Step 3: Get dependencies
Write-Host "Getting fresh dependencies..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "Dependency resolution failed" -ForegroundColor Red
    exit 1
}

# Step 4: Build APK
Write-Host "Building APK..." -ForegroundColor Yellow
flutter build apk --debug

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful!" -ForegroundColor Green
    Write-Host "APK location: build\app\outputs\flutter-apk\app-debug.apk" -ForegroundColor Cyan
} else {
    Write-Host "Build failed" -ForegroundColor Red
    exit 1
}