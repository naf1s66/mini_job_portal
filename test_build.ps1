# Test Build Script - Quick verification

Write-Host "Testing Build with Fixed Versions" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Quick cleanup
Write-Host "Quick cleanup..." -ForegroundColor Yellow
if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
if (Test-Path ".dart_tool") { Remove-Item -Recurse -Force ".dart_tool" }
if (Test-Path "android\.gradle") { Remove-Item -Recurse -Force "android\.gradle" }

# Test build
Write-Host "Testing build..." -ForegroundColor Yellow
flutter build apk --debug

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS! Build works!" -ForegroundColor Green
    
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    if (Test-Path $apkPath) {
        Write-Host "APK created at: $apkPath" -ForegroundColor Cyan
    }
} else {
    Write-Host "FAILED: Build still not working" -ForegroundColor Red
    Write-Host "Run the full fix: .\fix_gradle_final.ps1" -ForegroundColor Yellow
}