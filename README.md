# Mini Job Portal (Flutter)

A small Flutter app implementing:
- Email/password auth (local, demo only) via Hive
- Job list page **redirected to after login**
- Jobs fetched from `https://dummyjson.com/products` and mapped to "jobs"
- Job details page
- Saved jobs (local storage via Hive) shown on a separate page
- Profile page (dummy data) with total saved jobs
- Sidebar (Drawer) + top bar with avatar and logout
- Bottom navigation for quick access

> ⚠️ Auth here is **demo only** (hashing with SHA-256, stored locally). Do **not** use as-is for production.

## How to run

1. Install Flutter (latest stable).
2. From the project root:
   ```bash
   flutter pub get
   flutter run
   ```

**Or use the setup script (Windows):**
```powershell
.\setup.ps1
```

## Build Android APK

**Quick build using script (Windows):**
```powershell
.\build_apk.ps1
```

**Manual build:**
```bash
flutter build apk --debug
```

The APK will be located at: `android\app\build\outputs\flutter-apk\app-debug.apk`

## Project structure

```
lib/
  main.dart
  models/
    job.dart
  services/
    api_service.dart       # HTTP -> dummyjson
    auth_service.dart      # demo auth with Hive
    storage_service.dart   # Hive wrappers (users/session/savedJobs)
  widgets/
    job_card.dart
  pages/
    login_page.dart
    signup_page.dart
    home_shell.dart        # App shell with AppBar, Drawer, Bottom Nav
    job_list_page.dart
    job_detail_page.dart
    saved_jobs_page.dart
    profile_page.dart
```

### Notes

- "Company" uses the product `brand`, "Location" uses the product `category` (uppercased) to keep things simple.
- "Salary" is a fake annual salary derived from the product `price * 1000`.
- Tapping **Apply** saves the job into local storage (Hive). It also appears under **Saved Jobs**.
- Logout is implemented in the avatar menu and in the drawer.

Enjoy hacking! 🎯
