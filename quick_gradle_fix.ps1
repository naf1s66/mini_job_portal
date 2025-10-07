# Quick Gradle Fix - Addresses the validatePlugins error immediately

Write-Host "⚡ Quick Gradle Fix" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan

Write-Host "🔧 Fixed Gradle versions to compatible ones:" -ForegroundColor Yellow
Write-Host "   • Gradle: 8.6 → 8.5" -ForegroundColor Gray
Write-Host "   • Android Gradle Plugin: 8.4.1 → 8.1.4" -ForegroundColor Gray
Write-Host "   • Kotlin: 1.9.24 → 1.9.10" -ForegroundColor Gray

Write-Host "🧹 Cleaning caches..." -ForegroundColor Yellow
if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
if (Test-Path ".dart_tool") { Remove-Item -Recurse -Force ".dart_tool" }
if (Test-Path "android\.gradle") { Remove-Item -Recurse -Force "android\.gradle" }
if (Test-Path "pubspec.lock") { Remove-Item -Force "pubspec.lock" }

Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "🔨 Building APK..." -ForegroundColor Yellow
flutter build apk --debug

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ SUCCESS! APK built successfully!" -ForegroundColor Green
    Write-Host "📱 APK location: build\app\outputs\flutter-apk\app-debug.apk" -ForegroundColor Cyan
} else {
    Write-Host "❌ Still failing. Run the comprehensive fix:" -ForegroundColor Red
    Write-Host "   .\fix_gradle_issue.ps1" -ForegroundColor Yellow
}