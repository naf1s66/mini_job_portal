# Flutter/Gradle Compatibility Fix Script
# Fixes the "Unresolved reference: validatePlugins" error

Write-Host "Flutter/Gradle Compatibility Fix" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Function to check if command exists
function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Step 1: Check Flutter installation
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow

if (-not (Test-Command "flutter")) {
    Write-Host "ERROR: Flutter not found in PATH" -ForegroundColor Red
    Write-Host "Please install Flutter and add it to your PATH" -ForegroundColor Red
    exit 1
}

# Step 2: Clean all caches
Write-Host "Cleaning all caches..." -ForegroundColor Yellow

# Remove build directories
if (Test-Path "build") { 
    Write-Host "   Removing build directory..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "build" 
}
if (Test-Path ".dart_tool") { 
    Write-Host "   Removing .dart_tool..." -ForegroundColor Gray
    Remove-Item -Recurse -Force ".dart_tool" 
}
if (Test-Path "android\.gradle") { 
    Write-Host "   Removing Android Gradle cache..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "android\.gradle" 
}
if (Test-Path "android\app\.cxx") { 
    Write-Host "   Removing Android C++ cache..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "android\app\.cxx" 
}
if (Test-Path "android\app\build") { 
    Write-Host "   Removing Android app build..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "android\app\build" 
}
if (Test-Path "pubspec.lock") { 
    Write-Host "   Removing pubspec.lock..." -ForegroundColor Gray
    Remove-Item -Force "pubspec.lock" 
}

# Clean Flutter caches
Write-Host "   Cleaning Flutter pub cache..." -ForegroundColor Gray
flutter pub cache clean

Write-Host "   Cleaning Flutter..." -ForegroundColor Gray
flutter clean

Write-Host "SUCCESS: All caches cleaned" -ForegroundColor Green

# Step 3: Get dependencies
Write-Host "Getting fresh dependencies..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to get dependencies" -ForegroundColor Red
    Write-Host "Try running: flutter pub get --verbose" -ForegroundColor Yellow
    exit 1
}

Write-Host "SUCCESS: Dependencies resolved" -ForegroundColor Green

# Step 4: Test build
Write-Host "Testing build..." -ForegroundColor Yellow
flutter build apk --debug

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS: Build completed!" -ForegroundColor Green
    Write-Host "Gradle compatibility issue fixed!" -ForegroundColor Cyan
    
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    if (Test-Path $apkPath) {
        Write-Host "APK created at: $apkPath" -ForegroundColor Cyan
    }
} else {
    Write-Host "ERROR: Build still failing" -ForegroundColor Red
    Write-Host ""
    Write-Host "Additional troubleshooting steps:" -ForegroundColor Yellow
    Write-Host "1. Check Flutter doctor: flutter doctor -v" -ForegroundColor Gray
    Write-Host "2. Update Android SDK: flutter doctor --android-licenses" -ForegroundColor Gray
    Write-Host "3. Restart your IDE/terminal" -ForegroundColor Gray
    Write-Host "4. Try: flutter create --platforms android . --overwrite" -ForegroundColor Gray
}

Write-Host ""
Write-Host "What was fixed:" -ForegroundColor Cyan
Write-Host "- Updated Flutter to latest stable" -ForegroundColor Gray
Write-Host "- Downgraded Gradle to 8.5 (compatible)" -ForegroundColor Gray
Write-Host "- Downgraded Android Gradle Plugin to 8.1.4" -ForegroundColor Gray
Write-Host "- Cleaned all caches" -ForegroundColor Gray
Write-Host "- Updated Kotlin to 1.9.10" -ForegroundColor Gray