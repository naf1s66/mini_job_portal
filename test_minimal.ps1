# Test with minimal app to isolate the issue
Write-Host "Testing with minimal app..." -ForegroundColor Green

# Backup current main.dart
Write-Host "Backing up current main.dart..." -ForegroundColor Yellow
Copy-Item "lib\main.dart" "lib\main_backup.dart" -Force

# Use minimal version
Write-Host "Using minimal main.dart..." -ForegroundColor Yellow
Copy-Item "lib\main_minimal.dart" "lib\main.dart" -Force

# Build APK
Write-Host "Building minimal APK..." -ForegroundColor Yellow
Set-Location android
.\gradlew assembleDebug
Set-Location ..

Write-Host ""
Write-Host "Minimal APK built successfully." -ForegroundColor Green
Write-Host "Install this APK and test it:" -ForegroundColor Cyan
Write-Host "   android\app\build\outputs\flutter-apk\app-debug.apk" -ForegroundColor White
Write-Host ""
Write-Host "If the minimal app works, the issue is in your original code." -ForegroundColor Yellow
Write-Host "If it doesn't work, the issue is with your Flutter/Android setup." -ForegroundColor Yellow
Write-Host ""
Write-Host "To restore original main.dart:" -ForegroundColor Cyan
Write-Host "   Copy-Item lib\main_backup.dart lib\main.dart -Force" -ForegroundColor White
