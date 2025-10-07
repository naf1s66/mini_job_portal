# Capture device logs for debugging
Write-Host "Capturing device logs..." -ForegroundColor Green
Write-Host "1. Make sure your app is running on the phone" -ForegroundColor Yellow
Write-Host "2. Press Ctrl+C to stop capturing after 30 seconds" -ForegroundColor Yellow
Write-Host ""

# Clear existing logs first
adb logcat -c

Write-Host "Starting log capture..." -ForegroundColor Green
Write-Host "Now open/restart your app on the phone!" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop capturing when done." -ForegroundColor Yellow

# Start capturing logs (run until Ctrl+C)
adb logcat > app_debug_logs.txt

Write-Host ""
Write-Host "Logs saved to: app_debug_logs.txt" -ForegroundColor Green
Write-Host "Search the file for:" -ForegroundColor Yellow
Write-Host "  - 'flutter'" -ForegroundColor White
Write-Host "  - 'JobPortal'" -ForegroundColor White  
Write-Host "  - 'Initializing'" -ForegroundColor White
Write-Host "  - 'Error'" -ForegroundColor White