# Hidden Files Created During Flutter APK Build

## 🚨 **Major Space Consumers (10GB+ possible)**

### **1. Android Gradle Cache (`android/.gradle/`)**
- **Size**: 2-5 GB typically
- **Contains**: Gradle build cache, dependencies, compiled artifacts
- **Subdirectories**:
  - `8.6/` - Gradle version cache
  - `checksums/`, `dependencies-accessors/`, `executionHistory/`
  - `fileChanges/`, `fileHashes/`, `vcsMetadata/`
  - `buildOutputCleanup/`, `kotlin/`

### **2. Android C++ Build Cache (`android/app/.cxx/`)**
- **Size**: 1-3 GB
- **Contains**: Native C++ compilation artifacts for multiple architectures
- **Architectures**: `arm64-v8a`, `armeabi-v7a`, `x86`, `x86_64`
- **Each contains**: CMake files, compiler outputs, build logs

### **3. Android App Build (`android/app/build/`)**
- **Size**: 500MB - 2GB
- **Contains**: 
  - Compiled DEX files (`intermediates/dex/`)
  - Merged resources (`intermediates/merged_res/`)
  - Asset processing (`intermediates/assets/`)
  - APK intermediates and outputs

### **4. Main Build Directory (`build/`)**
- **Size**: 200-800 MB
- **Contains**: Flutter compilation outputs, web builds, etc.

### **5. Dart Tool Cache (`.dart_tool/`)**
- **Size**: 100-500 MB
- **Contains**: Dart analysis cache, package resolution

## 📁 **Complete List of Hidden Build Files**

### **Project-Level Hidden Files**
```
.dart_tool/                    # Dart tooling cache
.flutter-plugins               # Plugin registry
.flutter-plugins-dependencies  # Plugin dependencies
.metadata                      # Flutter metadata
build/                         # Main build output
pubspec.lock                   # Dependency lock file
```

### **Android-Specific Hidden Files**
```
android/.gradle/               # Gradle cache (HUGE!)
android/app/.cxx/              # C++ build cache (HUGE!)
android/app/build/             # Android build outputs (LARGE)
android/gradle/                # Gradle wrapper
android/local.properties       # Local Android config
```

### **iOS-Specific Hidden Files** (if building for iOS)
```
ios/build/                     # iOS build outputs
ios/Pods/                      # CocoaPods dependencies
ios/.symlinks/                 # Flutter symlinks
ios/Runner.xcworkspace/        # Xcode workspace
```

### **Other Platform Build Files**
```
windows/build/                 # Windows build
linux/build/                   # Linux build
macos/build/                   # macOS build
web/build/                     # Web build
```

## 🧹 **Cleanup Strategies**

### **Immediate Cleanup (Run These Commands)**
```bash
# Clean Flutter project
flutter clean

# Remove all build artifacts
rm -rf build .dart_tool pubspec.lock

# Clean Android specifically
rm -rf android/.gradle android/app/.cxx android/app/build

# Clean iOS (if applicable)
rm -rf ios/build ios/Pods ios/.symlinks
```

### **Global Cache Cleanup**
```bash
# Clean Flutter global cache
flutter pub cache clean

# Clean Gradle global cache
gradle clean
# Or manually: rm -rf ~/.gradle/caches/

# Clean pub cache
dart pub cache clean
```

### **Automated Cleanup Script**
Use the provided `cleanup_build_files.ps1` script:
```powershell
.\cleanup_build_files.ps1
```

## 🔍 **Why These Files Consume So Much Space**

1. **Multi-Architecture Builds**: Android builds for 4 architectures simultaneously
2. **Gradle Caching**: Gradle aggressively caches dependencies and build artifacts
3. **Incremental Builds**: Build systems keep intermediate files for faster rebuilds
4. **Resource Processing**: Images, fonts, and assets are processed multiple times
5. **Debug Information**: Debug builds include extensive debugging information

## 🛡️ **Prevention Strategies**

### **1. Use Build Scripts with Cleanup**
The provided build scripts automatically clean before building:
```powershell
.\build_apk.ps1  # Includes automatic cleanup
```

### **2. Regular Maintenance**
```bash
# Weekly cleanup
flutter clean
flutter pub cache clean

# Before each build
rm -rf build .dart_tool android/.gradle android/app/.cxx
```

### **3. Gitignore Configuration**
Ensure your `.gitignore` includes:
```gitignore
# Build outputs
build/
.dart_tool/
pubspec.lock

# Android
android/.gradle/
android/app/.cxx/
android/app/build/
android/local.properties

# iOS
ios/build/
ios/Pods/
ios/.symlinks/
```

### **4. Build Configuration**
In `android/app/build.gradle`, you can limit architectures:
```gradle
android {
    defaultConfig {
        ndk {
            abiFilters 'arm64-v8a'  // Only build for 64-bit ARM
        }
    }
}
```

## 📊 **Typical Space Usage**

| Component | Typical Size | Max Observed |
|-----------|-------------|--------------|
| `android/.gradle/` | 2-5 GB | 8 GB |
| `android/app/.cxx/` | 1-3 GB | 5 GB |
| `android/app/build/` | 500MB-2GB | 3 GB |
| `build/` | 200-800 MB | 1.5 GB |
| `.dart_tool/` | 100-500 MB | 1 GB |
| **TOTAL** | **4-11 GB** | **18+ GB** |

## 🚀 **Quick Recovery Commands**

If you've lost 10GB+ of space, run these immediately:

```powershell
# PowerShell (Windows)
.\cleanup_build_files.ps1

# Or manually:
Remove-Item -Recurse -Force build, .dart_tool, android\.gradle, android\app\.cxx, android\app\build
```

```bash
# Bash (Linux/Mac)
rm -rf build .dart_tool android/.gradle android/app/.cxx android/app/build
flutter clean
flutter pub cache clean
```

This should recover most of your lost disk space!