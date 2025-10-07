# Setup ADB for this session
Write-Host "Setting up ADB..." -ForegroundColor Green

# Add Android SDK platform-tools to PATH for this session
$androidSdkPath = "C:\Users\Admin\AppData\Local\Android\sdk\platform-tools"

if (Test-Path $androidSdkPath) {
    $env:PATH += ";$androidSdkPath"
    Write-Host "ADB added to PATH for this session." -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Testing ADB connection..." -ForegroundColor Yellow
    adb devices
    
    Write-Host ""
    Write-Host "Now you can use these commands:" -ForegroundColor Cyan
    Write-Host "  adb devices          - List connected devices" -ForegroundColor White
    Write-Host "  adb logcat           - View all logs" -ForegroundColor White
    Write-Host "  adb logcat | findstr flutter - View Flutter logs only" -ForegroundColor White
    
} else {
    Write-Host "Android SDK not found at expected location." -ForegroundColor Red
    Write-Host "Please check if Android SDK is installed." -ForegroundColor Yellow
}