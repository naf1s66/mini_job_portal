# Fix Kotlin Daemon and Build Issues

Write-Host "Fixing Kotlin Daemon and Build Issues" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Step 1: Kill all Java/Gradle processes
Write-Host "Killing all Java/Gradle processes..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -match "java|gradle|kotlin"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# Step 2: Stop Gradle daemon
Write-Host "Stopping Gradle daemon..." -ForegroundColor Yellow
try {
    & gradle --stop 2>$null
} catch {
    Write-Host "   Gradle command not found, continuing..." -ForegroundColor Gray
}

# Step 3: Aggressive cleanup
Write-Host "Aggressive cleanup of all build files..." -ForegroundColor Yellow

$pathsToClean = @(
    "build",
    ".dart_tool", 
    "android\.gradle",
    "android\app\.cxx",
    "android\app\build",
    "pubspec.lock",
    ".flutter-plugins",
    ".flutter-plugins-dependencies"
)

foreach ($path in $pathsToClean) {
    if (Test-Path $path) {
        Write-Host "   Removing $path..." -ForegroundColor Gray
        try {
            Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
        } catch {
            Write-Host "   Failed to remove $path, trying alternative method..." -ForegroundColor Yellow
            # Try to unlock and remove
            Get-ChildItem -Path $path -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            Remove-Item -Path $path -Force -ErrorAction SilentlyContinue
        }
    }
}

# Step 4: Clean global Gradle cache
Write-Host "Cleaning global Gradle cache..." -ForegroundColor Yellow
$gradleUserHome = "$env:USERPROFILE\.gradle"
if (Test-Path $gradleUserHome) {
    $gradleCaches = "$gradleUserHome\caches"
    if (Test-Path $gradleCaches) {
        Write-Host "   Removing Gradle caches..." -ForegroundColor Gray
        Remove-Item -Path $gradleCaches -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    $gradleDaemon = "$gradleUserHome\daemon"
    if (Test-Path $gradleDaemon) {
        Write-Host "   Removing Gradle daemon files..." -ForegroundColor Gray
        Remove-Item -Path $gradleDaemon -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Step 5: Clean Flutter caches
Write-Host "Cleaning Flutter caches..." -ForegroundColor Yellow
flutter clean
flutter pub cache clean

# Step 6: Configure Gradle JVM options for stability
Write-Host "Configuring Gradle JVM options..." -ForegroundColor Yellow
$gradlePropertiesPath = "android\gradle.properties"
$gradlePropertiesContent = @"
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8 -XX:+UseG1GC
org.gradle.parallel=false
org.gradle.daemon=true
org.gradle.configureondemand=false
android.useAndroidX=true
android.enableJetifier=true
kotlin.daemon.jvm.options=-Xmx2048m -XX:MaxMetaspaceSize=512m
"@

Set-Content -Path $gradlePropertiesPath -Value $gradlePropertiesContent
Write-Host "   Updated gradle.properties with stable JVM settings" -ForegroundColor Green

# Step 7: Get dependencies
Write-Host "Getting fresh dependencies..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to get dependencies" -ForegroundColor Red
    exit 1
}

# Step 8: Build with single architecture to avoid CMake issues
Write-Host "Building APK (arm64 only to avoid CMake issues)..." -ForegroundColor Yellow
flutter build apk --debug --target-platform android-arm64

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS! APK built successfully!" -ForegroundColor Green
    
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length
        $apkSizeMB = [math]::Round($apkSize / 1MB, 2)
        Write-Host "APK created: $apkPath ($apkSizeMB MB)" -ForegroundColor Cyan
    }
} else {
    Write-Host "ERROR: Build still failing" -ForegroundColor Red
    Write-Host ""
    Write-Host "Additional steps to try:" -ForegroundColor Yellow
    Write-Host "1. Restart your computer" -ForegroundColor Gray
    Write-Host "2. Check Java version: java -version" -ForegroundColor Gray
    Write-Host "3. Run: flutter doctor -v" -ForegroundColor Gray
    Write-Host "4. Try building for a single architecture only" -ForegroundColor Gray
}