# Flutter Project Setup Script
# Initializes the project and runs it

Write-Host "Setting up Flutter Job Portal project..." -ForegroundColor Green
Write-Host ""

Write-Host "Step 1: Getting Flutter dependencies..." -ForegroundColor Yellow
try {
    flutter pub get
    Write-Host "Dependencies installed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error: Failed to get dependencies. Make sure Flutter is installed." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 2: Running the Flutter app..." -ForegroundColor Yellow
Write-Host "Note: Make sure you have an emulator running or device connected." -ForegroundColor Cyan
Write-Host ""

try {
    flutter run
} catch {
    Write-Host "Error: Failed to run the app. Check if you have a device/emulator available." -ForegroundColor Red
    Write-Host "You can also try: flutter run -d chrome (for web)" -ForegroundColor Yellow
}