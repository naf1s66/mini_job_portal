# Check Flutter SDK and find ADB
Write-Host "Checking Flutter SDK location..." -ForegroundColor Green

# Get Flutter doctor output
$flutterDoctor = flutter doctor -v

# Extract Android SDK path
$androidSdkPath = $flutterDoctor | Select-String "Android SDK at (.+)" | ForEach-Object { $_.Matches[0].Groups[1].Value }

if ($androidSdkPath) {
    Write-Host "Android SDK found at: $androidSdkPath" -ForegroundColor Green
    
    $adbPath = Join-Path $androidSdkPath "platform-tools\adb.exe"
    
    if (Test-Path $adbPath) {
        Write-Host "ADB found at: $adbPath" -ForegroundColor Green
        Write-Host ""
        Write-Host "Testing ADB connection..." -ForegroundColor Yellow
        
        & $adbPath devices
        
        Write-Host ""
        Write-Host "To use ADB in this session, run:" -ForegroundColor Cyan
        Write-Host "`$env:PATH += `";$androidSdkPath\platform-tools`"" -ForegroundColor White
        Write-Host "adb devices" -ForegroundColor White
    } else {
        Write-Host "ADB not found in platform-tools" -ForegroundColor Red
    }
} else {
    Write-Host "Android SDK path not found in flutter doctor output" -ForegroundColor Red
    Write-Host ""
    Write-Host "Flutter doctor output:" -ForegroundColor Yellow
    $flutterDoctor
}