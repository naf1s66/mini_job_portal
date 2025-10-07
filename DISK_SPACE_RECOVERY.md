# 🚨 URGENT: Disk Space Recovery Guide

## **You Lost 10GB Because of These Hidden Files:**

### **🔥 IMMEDIATE SOLUTION - Run This Now:**

**Windows PowerShell:**
```powershell
.\cleanup_build_files.ps1
```

**Windows Command Prompt:**
```cmd
cleanup_build_files.bat
```

**Manual Commands (Any Platform):**
```bash
# Remove the biggest space consumers
rm -rf android/.gradle          # 2-5 GB
rm -rf android/app/.cxx         # 1-3 GB  
rm -rf android/app/build        # 500MB-2GB
rm -rf build                    # 200-800 MB
rm -rf .dart_tool               # 100-500 MB

# Clean Flutter caches
flutter clean
flutter pub cache clean
```

---

## **🕵️ What Consumed Your 10GB:**

| Hidden Directory | Typical Size | What It Contains |
|------------------|--------------|------------------|
| `android/.gradle/` | **2-5 GB** | Gradle build cache, dependencies |
| `android/app/.cxx/` | **1-3 GB** | C++ compilation for 4 architectures |
| `android/app/build/` | **500MB-2GB** | Android build intermediates |
| `build/` | **200-800 MB** | Flutter build outputs |
| `.dart_tool/` | **100-500 MB** | Dart analysis cache |

**Total: 4-11 GB per project!**

---

## **🛡️ Prevent This From Happening Again:**

### **1. Use the Updated Build Scripts**
The build scripts now include automatic cleanup:
```powershell
.\fix_and_build.ps1  # Now includes deep cleanup
.\build_apk.ps1      # Includes cleanup
```

### **2. Regular Maintenance**
```bash
# Before each build
flutter clean

# Weekly
flutter pub cache clean
```

### **3. Monitor Space Usage**
```bash
# Check current project size
du -sh .

# Check specific directories
du -sh android/.gradle android/app/.cxx android/app/build
```

---

## **📋 Available Cleanup Tools:**

1. **`cleanup_build_files.ps1`** - Comprehensive PowerShell cleanup
2. **`cleanup_build_files.bat`** - Simple batch file cleanup  
3. **`fix_and_build.ps1`** - Updated with deep cleanup + build
4. **Manual commands** - Listed above

---

## **🔍 Why This Happened:**

Flutter APK builds create massive hidden caches:

- **Multi-architecture builds**: Compiles for 4 CPU architectures
- **Gradle caching**: Aggressively caches everything
- **Incremental builds**: Keeps intermediate files
- **Debug information**: Extensive debugging data

---

## **✅ Quick Recovery Checklist:**

- [ ] Run cleanup script: `.\cleanup_build_files.ps1`
- [ ] Verify space recovered: `Get-ChildItem . -Recurse | Measure-Object -Property Length -Sum`
- [ ] Update build process to use new scripts
- [ ] Set up regular cleanup routine

**You should recover 8-10GB immediately!**