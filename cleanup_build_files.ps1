# Flutter Build Cleanup Script
# This script removes all hidden build files that consume disk space

Write-Host "🧹 Flutter Build Files Cleanup" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

$totalSaved = 0

function Get-DirectorySize {
    param([string]$Path)
    if (Test-Path $Path) {
        $size = (Get-ChildItem -Path $Path -Recurse -Force | Measure-Object -Property Length -Sum).Sum
        return [math]::Round($size / 1MB, 2)
    }
    return 0
}

function Remove-Directory {
    param([string]$Path, [string]$Description)
    
    if (Test-Path $Path) {
        $sizeMB = Get-DirectorySize $Path
        Write-Host "🗑️  Removing $Description ($sizeMB MB)..." -ForegroundColor Yellow
        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
        $script:totalSaved += $sizeMB
        Write-Host "   ✅ Removed" -ForegroundColor Green
    } else {
        Write-Host "   ⚪ $Description not found" -ForegroundColor Gray
    }
}

Write-Host "Scanning for build files..." -ForegroundColor Yellow

# Main Flutter build directories
Remove-Directory "build" "Main build directory"
Remove-Directory ".dart_tool" "Dart tool cache"

# Android build files (MAJOR SPACE CONSUMERS)
Remove-Directory "android\.gradle" "Android Gradle cache"
Remove-Directory "android\app\.cxx" "Android C++ build cache"
Remove-Directory "android\app\build" "Android app build"

# iOS build files (if present)
Remove-Directory "ios\build" "iOS build directory"
Remove-Directory "ios\Pods" "iOS Pods"
Remove-Directory "ios\.symlinks" "iOS symlinks"

# Other platform builds
Remove-Directory "windows\build" "Windows build"
Remove-Directory "linux\build" "Linux build"
Remove-Directory "macos\build" "macOS build"
Remove-Directory "web\build" "Web build"

# Dependency files
Remove-Directory "pubspec.lock" "Pubspec lock file"

# Hidden Flutter files
Remove-Directory ".flutter-plugins" "Flutter plugins cache"
Remove-Directory ".flutter-plugins-dependencies" "Flutter plugins dependencies"

# Gradle wrapper cache (global)
$gradleHome = "$env:USERPROFILE\.gradle"
if (Test-Path $gradleHome) {
    $gradleSize = Get-DirectorySize $gradleHome
    Write-Host "⚠️  Global Gradle cache found: $gradleSize MB at $gradleHome" -ForegroundColor Yellow
    Write-Host "   To clean global Gradle cache, run: gradle clean" -ForegroundColor Cyan
}

# Flutter global cache info
$flutterCache = "$env:USERPROFILE\.flutter"
if (Test-Path $flutterCache) {
    $flutterSize = Get-DirectorySize $flutterCache
    Write-Host "ℹ️  Flutter SDK cache: $flutterSize MB at $flutterCache" -ForegroundColor Cyan
    Write-Host "   To clean Flutter cache, run: flutter clean" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "🎉 Cleanup completed!" -ForegroundColor Green
Write-Host "💾 Total space saved: $totalSaved MB" -ForegroundColor Cyan

if ($totalSaved -gt 1000) {
    $totalSavedGB = [math]::Round($totalSaved / 1024, 2)
    Write-Host "💾 That's $totalSavedGB GB!" -ForegroundColor Green
}

Write-Host ""
Write-Host "📋 To prevent future space issues:" -ForegroundColor Yellow
Write-Host "   • Run 'flutter clean' before each build" -ForegroundColor Gray
Write-Host "   • Use the build scripts which include cleanup" -ForegroundColor Gray
Write-Host "   • Regularly clean global caches" -ForegroundColor Gray