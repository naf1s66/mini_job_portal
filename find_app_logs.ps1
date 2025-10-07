# Find Job Portal app logs specifically
Write-Host "Searching for Job Portal app logs..." -ForegroundColor Green

# Clear logs first
adb logcat -c

Write-Host "Starting your app now and press Enter when it shows the error..." -ForegroundColor Yellow
Read-Host

Write-Host "Capturing logs..." -ForegroundColor Yellow
adb logcat -d > clean_logs.txt

Write-Host ""
Write-Host "Searching for app-specific logs..." -ForegroundColor Cyan

# Search for various app identifiers
$content = Get-Content clean_logs.txt -ErrorAction SilentlyContinue

if ($content) {
    Write-Host ""
    Write-Host "=== Flutter Engine logs ===" -ForegroundColor Green
    $content | Select-String "flutter" -CaseSensitive:$false | Select-Object -First 5
    
    Write-Host ""
    Write-Host "=== Job Portal app logs ===" -ForegroundColor Green  
    $content | Select-String "com.example.job_portal" -CaseSensitive:$false | Select-Object -First 5
    
    Write-Host ""
    Write-Host "=== Dart/Flutter runtime logs ===" -ForegroundColor Green
    $content | Select-String "dart\|DartVM\|FlutterEngine" -CaseSensitive:$false | Select-Object -First 5
    
    Write-Host ""
    Write-Host "=== Error/Exception logs ===" -ForegroundColor Red
    $content | Select-String "error\|exception\|crash\|fatal" -CaseSensitive:$false | Select-Object -First 10
    
    Write-Host ""
    Write-Host "=== Hive database logs ===" -ForegroundColor Yellow
    $content | Select-String "hive\|database\|storage" -CaseSensitive:$false | Select-Object -First 5
    
    Write-Host ""
    Write-Host "Full log saved to: clean_logs.txt" -ForegroundColor Cyan
} else {
    Write-Host "No logs captured. Make sure device is connected and app is running." -ForegroundColor Red
}