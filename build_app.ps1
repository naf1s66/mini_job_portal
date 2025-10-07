param(
  [switch] $Release
)

$configuration = "debug"
$apkPath = "android\app\build\outputs\flutter-apk\app-debug.apk"

if ($Release.IsPresent) {
  $configuration = "release"
  $apkPath = "android\app\build\outputs\flutter-apk\app-release.apk"
}

Write-Host "Preparing Job Portal $configuration APK..." -ForegroundColor Green

Write-Host "Running flutter pub get..." -ForegroundColor Yellow
flutter pub get

Write-Host "Building APK via flutter build..." -ForegroundColor Yellow
$buildArgs = @("apk")
if ($Release.IsPresent) {
  $buildArgs += "--release"
} else {
  $buildArgs += "--debug"
}
flutter build @buildArgs
if ($LASTEXITCODE -ne 0) {
  Write-Error "flutter build failed. Check the logs above for details."
  exit $LASTEXITCODE
}

Write-Host ""
Write-Host "Build succeeded. APK ready at:" -ForegroundColor Green
Write-Host "  $apkPath" -ForegroundColor White
Write-Host ""
Write-Host "Install the APK on a device or emulator to verify the fix." -ForegroundColor Cyan
