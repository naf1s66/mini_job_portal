# Build APK for Single Architecture - Avoids CMake issues

Write-Host "Building APK for Single Architecture" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

Write-Host "This avoids CMake multi-architecture issues" -ForegroundColor Yellow

# Quick cleanup
Write-Host "Quick cleanup..." -ForegroundColor Yellow
if (Test-Path "build") { Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue }
if (Test-Path "android\app\build") { Remove-Item -Recurse -Force "android\app\build" -ErrorAction SilentlyContinue }

# Build for ARM64 only (most common architecture)
Write-Host "Building for ARM64 architecture only..." -ForegroundColor Yellow
flutter build apk --debug --target-platform android-arm64

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS! APK built for ARM64!" -ForegroundColor Green
    
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length
        $apkSizeMB = [math]::Round($apkSize / 1MB, 2)
        Write-Host "APK: $apkPath ($apkSizeMB MB)" -ForegroundColor Cyan
        Write-Host "Note: This APK only works on ARM64 devices (most modern phones)" -ForegroundColor Yellow
    }
} else {
    Write-Host "ERROR: Build failed even for single architecture" -ForegroundColor Red
    Write-Host "Try: .\fix_kotlin_daemon.ps1" -ForegroundColor Yellow
}