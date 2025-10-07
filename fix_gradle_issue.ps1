# Flutter/Gradle Compatibility Fix Script
# Fixes the "Unresolved reference: validatePlugins" error

Write-Host "🔧 Flutter/Gradle Compatibility Fix" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Function to check if command exists
function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Step 1: Check Flutter installation
Write-Host "🔍 Checking Flutter installation..." -ForegroundColor Yellow

if (-not (Test-Command "flutter")) {
    Write-Host "❌ Flutter not found in PATH" -ForegroundColor Red
    Write-Host "Please install Flutter and add it to your PATH" -ForegroundColor Red
    exit 1
}

# Step 2: Check Flutter doctor
Write-Host "🩺 Running Flutter doctor..." -ForegroundColor Yellow
flutter doctor

# Step 3: Update Flutter to latest stable
Write-Host "⬆️ Updating Flutter to latest stable..." -ForegroundColor Yellow
flutter upgrade

# Step 4: Clean all caches
Write-Host "🧹 Cleaning all caches..." -ForegroundColor Yellow

# Remove build directories
if (Test-Path "build") { 
    Write-Host "   Removing build directory..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "build" 
}
if (Test-Path ".dart_tool") { 
    Write-Host "   Removing .dart_tool..." -ForegroundColor Gray
    Remove-Item -Recurse -Force ".dart_tool" 
}
if (Test-Path "android\.gradle") { 
    Write-Host "   Removing Android Gradle cache..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "android\.gradle" 
}
if (Test-Path "android\app\.cxx") { 
    Write-Host "   Removing Android C++ cache..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "android\app\.cxx" 
}
if (Test-Path "android\app\build") { 
    Write-Host "   Removing Android app build..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "android\app\build" 
}
if (Test-Path "pubspec.lock") { 
    Write-Host "   Removing pubspec.lock..." -ForegroundColor Gray
    Remove-Item -Force "pubspec.lock" 
}

# Clean Flutter caches
Write-Host "   Cleaning Flutter pub cache..." -ForegroundColor Gray
flutter pub cache clean

Write-Host "   Cleaning Flutter..." -ForegroundColor Gray
flutter clean

# Step 5: Fix Gradle wrapper version
Write-Host "🔧 Updating Gradle wrapper to compatible version..." -ForegroundColor Yellow

$gradleWrapperPath = "android\gradle\wrapper\gradle-wrapper.properties"
if (Test-Path $gradleWrapperPath) {
    $content = @"
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.5-all.zip
"@
    Set-Content -Path $gradleWrapperPath -Value $content
    Write-Host "   ✅ Updated Gradle wrapper to 8.5" -ForegroundColor Green
}

# Step 6: Fix Android Gradle Plugin version
Write-Host "🔧 Updating Android Gradle Plugin..." -ForegroundColor Yellow

$androidBuildGradle = "android\build.gradle"
if (Test-Path $androidBuildGradle) {
    $content = @"
buildscript {
    ext.kotlin_version = '1.9.10'
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.4'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:`$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
"@
    Set-Content -Path $androidBuildGradle -Value $content
    Write-Host "   ✅ Updated Android Gradle Plugin to 8.1.4" -ForegroundColor Green
}

# Step 7: Get dependencies
Write-Host "📦 Getting fresh dependencies..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to get dependencies" -ForegroundColor Red
    Write-Host "Try running: flutter pub get --verbose" -ForegroundColor Yellow
    exit 1
}

# Step 8: Test build
Write-Host "🔨 Testing build..." -ForegroundColor Yellow
flutter build apk --debug

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build successful!" -ForegroundColor Green
    Write-Host "🎉 Gradle compatibility issue fixed!" -ForegroundColor Cyan
    
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    if (Test-Path $apkPath) {
        Write-Host "📱 APK created at: $apkPath" -ForegroundColor Cyan
    }
} else {
    Write-Host "❌ Build still failing" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔍 Additional troubleshooting steps:" -ForegroundColor Yellow
    Write-Host "1. Check Flutter doctor: flutter doctor -v" -ForegroundColor Gray
    Write-Host "2. Update Android SDK: flutter doctor --android-licenses" -ForegroundColor Gray
    Write-Host "3. Restart your IDE/terminal" -ForegroundColor Gray
    Write-Host "4. Try: flutter create --platforms android . --overwrite" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📋 What was fixed:" -ForegroundColor Cyan
Write-Host "• Updated Flutter to latest stable" -ForegroundColor Gray
Write-Host "• Downgraded Gradle to 8.5 (compatible)" -ForegroundColor Gray
Write-Host "• Downgraded Android Gradle Plugin to 8.1.4" -ForegroundColor Gray
Write-Host "• Cleaned all caches" -ForegroundColor Gray
Write-Host "• Updated Kotlin to 1.9.10" -ForegroundColor Gray