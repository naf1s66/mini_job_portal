#!/bin/bash
echo "🚀 Building Job Portal APK..."

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found"
    exit 1
fi

# Clean and build
echo "🧹 Cleaning..."
rm -rf build .dart_tool pubspec.lock

echo "📦 Getting dependencies..."
flutter pub get

echo "🔨 Building APK..."
flutter build apk --debug

# Check result
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo "✅ APK built successfully!"
    echo "Location: build/app/outputs/flutter-apk/app-debug.apk"
else
    echo "❌ Build failed"
    exit 1
fi