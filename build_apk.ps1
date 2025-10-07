#!/usr/bin/env pwsh

# Job Portal APK Build Script
# This script handles dependency resolution and builds the APK

Write-Host "🚀 Job Portal APK Build Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Function to check if Flutter is available
function Test-Flutter {
    try {
        $flutterVersion = flutter --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Flutter is available" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "❌ Flutter not found in PATH" -ForegroundColor Red
        return $false
    }
    return $false
}

# Function to clean project
function Clean-Project {
    Write-Host "🧹 Cleaning project..." -ForegroundColor Yellow
    
    if (Test-Path "build") {
        Remove-Item -Recurse -Force "build"
        Write-Host "   Removed build directory" -ForegroundColor Gray
    }
    
    if (Test-Path ".dart_tool") {
        Remove-Item -Recurse -Force ".dart_tool"
        Write-Host "   Removed .dart_tool directory" -ForegroundColor Gray
    }
    
    if (Test-Path "pubspec.lock") {
        Remove-Item -Force "pubspec.lock"
        Write-Host "   Removed pubspec.lock" -ForegroundColor Gray
    }
    
    Write-Host "✅ Project cleaned" -ForegroundColor Green
}

# Function to get dependencies
function Get-Dependencies {
    Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
    
    Write-Host "   Running flutter pub get..." -ForegroundColor Gray
    flutter pub get
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to get dependencies" -ForegroundColor Red
        return $false
    }
    
    Write-Host "✅ Dependencies resolved" -ForegroundColor Green
    return $true
}

# Function to build APK
function Build-APK {
    Write-Host "🔨 Building APK..." -ForegroundColor Yellow
    
    Write-Host "   Running flutter build apk..." -ForegroundColor Gray
    flutter build apk --debug
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ APK build failed" -ForegroundColor Red
        return $false
    }
    
    Write-Host "✅ APK build successful" -ForegroundColor Green
    return $true
}

# Function to verify APK
function Test-APK {
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length
        $apkSizeMB = [math]::Round($apkSize / 1MB, 2)
        
        Write-Host "✅ APK created successfully!" -ForegroundColor Green
        Write-Host "   Location: $apkPath" -ForegroundColor Gray
        Write-Host "   Size: $apkSizeMB MB" -ForegroundColor Gray
        return $true
    } else {
        Write-Host "❌ APK not found at expected location" -ForegroundColor Red
        return $false
    }
}

# Main execution
try {
    # Check Flutter availability
    if (-not (Test-Flutter)) {
        Write-Host "Please ensure Flutter is installed and in your PATH" -ForegroundColor Red
        exit 1
    }
    
    # Clean project
    Clean-Project
    
    # Get dependencies
    if (-not (Get-Dependencies)) {
        Write-Host "Failed to resolve dependencies. Check your internet connection and pubspec.yaml" -ForegroundColor Red
        exit 1
    }
    
    # Build APK
    if (-not (Build-APK)) {
        Write-Host "APK build failed. Check the error messages above." -ForegroundColor Red
        exit 1
    }
    
    # Verify APK
    if (-not (Test-APK)) {
        exit 1
    }
    
    Write-Host ""
    Write-Host "🎉 Build completed successfully!" -ForegroundColor Green
    Write-Host "You can now install the APK on your device or emulator." -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ An unexpected error occurred: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}