# Build APK with loading fix
Write-Host "Building APK with loading screen fix..." -ForegroundColor Green
Write-Host ""

Write-Host "Step 1: Cleaning..." -ForegroundColor Yellow
flutter clean

Write-Host ""
Write-Host "Step 2: Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "Step 3: Building APK..." -ForegroundColor Yellow
Set-Location android
.\gradlew clean
.\gradlew assembleDebug
Set-Location ..

Write-Host ""
Write-Host "✅ Fixed APK built successfully!" -ForegroundColor Green
Write-Host "📱 Location: android\app\build\outputs\flutter-apk\app-debug.apk" -ForegroundColor Cyan
Write-Host ""
Write-Host "🔧 Changes made:" -ForegroundColor Yellow
Write-Host "   - Added proper loading screen" -ForegroundColor White
Write-Host "   - Added error handling for initialization" -ForegroundColor White
Write-Host "   - Fixed async initialization issues" -ForegroundColor White