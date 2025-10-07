# Flutter Android APK Build Script
# Builds the Android APK for the Job Portal app

Write-Host "Building Android APK for Job Portal..." -ForegroundColor Green
Write-Host ""

Write-Host "Step 1: Cleaning previous builds..." -ForegroundColor Yellow
try {
    flutter clean
    Write-Host "Clean completed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Warning: Clean failed, continuing..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Step 2: Getting dependencies..." -ForegroundColor Yellow
try {
    flutter pub get
    Write-Host "Dependencies updated successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error: Failed to get dependencies." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 3: Building Android APK..." -ForegroundColor Yellow
Set-Location android
try {
    .\gradlew clean
    .\gradlew assembleDebug
    Write-Host ""
    Write-Host "✅ APK built successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📱 Your APK is located at:" -ForegroundColor Cyan
    Write-Host "   android\app\build\outputs\flutter-apk\app-debug.apk" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 To copy APK to current directory, run:" -ForegroundColor Yellow
    Write-Host "   copy android\app\build\outputs\flutter-apk\app-debug.apk .\job_portal.apk" -ForegroundColor White
} catch {
    Write-Host "Error: APK build failed. Check the error messages above." -ForegroundColor Red
} finally {
    Set-Location ..
}

Write-Host ""
Write-Host "Build process completed!" -ForegroundColor Green