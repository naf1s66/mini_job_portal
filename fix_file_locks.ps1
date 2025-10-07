# Fix File Locking Issues - Simple approach

Write-Host "Fixing File Locking Issues" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan

# Kill all Java processes
Write-Host "Killing Java processes..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -match "java"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Stop Gradle daemon
Write-Host "Stopping Gradle daemon..." -ForegroundColor Yellow
try {
    & gradle --stop 2>$null
} catch {
    Write-Host "   Gradle not in PATH, continuing..." -ForegroundColor Gray
}

# Force remove locked directories
Write-Host "Force removing locked build directories..." -ForegroundColor Yellow

$lockedPaths = @(
    "android\app\build\kotlin",
    "android\app\build\intermediates\cxx",
    "android\app\build",
    "android\.gradle",
    "build"
)

foreach ($path in $lockedPaths) {
    if (Test-Path $path) {
        Write-Host "   Force removing $path..." -ForegroundColor Gray
        
        # Try multiple methods to remove locked files
        try {
            # Method 1: Direct removal
            Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
        } catch {
            try {
                # Method 2: Take ownership and remove
                takeown /f $path /r /d y 2>$null
                icacls $path /grant administrators:F /t 2>$null
                Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
            } catch {
                # Method 3: Remove individual files
                Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | 
                    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path $path -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

Write-Host "Cleanup completed" -ForegroundColor Green

# Quick build test
Write-Host "Testing build..." -ForegroundColor Yellow
flutter build apk --debug --target-platform android-arm64

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS! Build works!" -ForegroundColor Green
} else {
    Write-Host "Still failing - try restarting your computer" -ForegroundColor Red
}