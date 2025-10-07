# Final Gradle Fix - Correct compatible versions

Write-Host "Final Gradle Compatibility Fix" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

Write-Host "Using correct compatible versions:" -ForegroundColor Yellow
Write-Host "   Gradle: 8.6 (required minimum)" -ForegroundColor Gray
Write-Host "   Android Gradle Plugin: 8.2.2 (stable with 8.6)" -ForegroundColor Gray
Write-Host "   Kotlin: 1.9.10 (compatible)" -ForegroundColor Gray

Write-Host "Cleaning all caches..." -ForegroundColor Yellow

# Remove all build artifacts
if (Test-Path "build") { 
    Write-Host "   Removing build..." -ForegroundColor Gray
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

Write-Host "Cleaning Flutter caches..." -ForegroundColor Yellow
flutter clean
flutter pub cache clean

Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to get dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "Building APK with correct versions..." -ForegroundColor Yellow
flutter build apk --debug

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS! APK built successfully!" -ForegroundColor Green
    
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length
        $apkSizeMB = [math]::Round($apkSize / 1MB, 2)
        Write-Host "APK created: $apkPath ($apkSizeMB MB)" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "FINAL SOLUTION APPLIED:" -ForegroundColor Green
    Write-Host "- Gradle 8.6 (meets minimum requirement)" -ForegroundColor Gray
    Write-Host "- Android Gradle Plugin 8.2.2 (stable)" -ForegroundColor Gray
    Write-Host "- All caches cleared" -ForegroundColor Gray
    
} else {
    Write-Host "ERROR: Build failed even with correct versions" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try these additional steps:" -ForegroundColor Yellow
    Write-Host "1. flutter doctor -v" -ForegroundColor Gray
    Write-Host "2. flutter doctor --android-licenses" -ForegroundColor Gray
    Write-Host "3. Restart your computer" -ForegroundColor Gray
    Write-Host "4. Check Java version: java -version" -ForegroundColor Gray
}