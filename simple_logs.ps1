# Simple log capture
Write-Host "Manual log capture process:" -ForegroundColor Green
Write-Host ""
Write-Host "Step 1: Clear old logs" -ForegroundColor Yellow
adb logcat -c

Write-Host ""
Write-Host "Step 2: Start your app on the phone now!" -ForegroundColor Cyan
Write-Host "Press Enter when the app has tried to load (even if it shows error)..." -ForegroundColor Yellow
Read-Host

Write-Host ""
Write-Host "Step 3: Capturing recent logs..." -ForegroundColor Yellow
adb logcat -d > recent_logs.txt

Write-Host ""
Write-Host "✅ Logs captured to: recent_logs.txt" -ForegroundColor Green
Write-Host ""
Write-Host "Searching for relevant entries..." -ForegroundColor Yellow

# Search for key terms
$logContent = Get-Content recent_logs.txt -ErrorAction SilentlyContinue

if ($logContent) {
    Write-Host ""
    Write-Host "=== Flutter-related logs ===" -ForegroundColor Cyan
    $logContent | Select-String "flutter" -CaseSensitive:$false | Select-Object -First 10
    
    Write-Host ""
    Write-Host "=== Error logs ===" -ForegroundColor Red
    $logContent | Select-String "error\|exception\|crash" -CaseSensitive:$false | Select-Object -First 10
    
    Write-Host ""
    Write-Host "=== Job Portal logs ===" -ForegroundColor Green
    $logContent | Select-String "job.portal\|JobPortal" -CaseSensitive:$false | Select-Object -First 10
} else {
    Write-Host "No logs captured. Make sure your device is connected and authorized." -ForegroundColor Red
}