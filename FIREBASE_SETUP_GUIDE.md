# 🔐 Firebase Google Sign-in Setup Guide

## Your SHA-1 Fingerprint

```
41:7B:FC:7D:9D:F3:FC:26:03:D4:7D:E0:A7:42:6D:D9:A1:14:04:33
```

**Important:** Copy this value - you'll need it in Firebase Console.

---

## Step-by-Step Firebase Console Configuration

### Step 1: Open Firebase Console
1. Go to: **https://console.firebase.google.com/**
2. Sign in with your Google account

### Step 2: Select Your Project
1. Look for **"trinetra-8eabf"** in the projects list
2. Click on it to open the project

### Step 3: Access Project Settings
1. Click the **⚙️ Settings icon** (gear icon) in the top-left sidebar
2. Select **"Project settings"** from the dropdown

### Step 4: Go to Android App Settings
1. Click on the **"Apps"** tab or section
2. Find and click on: **com.example.trinetra** (your Android app)

### Step 5: Add SHA-1 Fingerprint
1. Scroll to find **"SHA certificate fingerprints"** section
2. Click **"Add fingerprint"** or the input field
3. **Paste this SHA-1:**
   ```
   41:7B:FC:7D:9D:F3:FC:26:03:D4:7D:E0:A7:42:6D:D9:A1:14:04:33
   ```
4. Click **"Save"** button

### Step 6: Download Updated google-services.json
1. After saving, scroll to the top of the Android app settings
2. Click the **"Download google-services.json"** button (usually green)
3. Save the file

### Step 7: Replace Local File
1. Navigate to: `android/app/google-services.json`
2. Replace the existing file with the newly downloaded one
   - Current location: `d:\Trinetra App\trinetra\android\app\google-services.json`

---

## Current Status ✅

Your `google-services.json` already contains:
```json
{
  "client_id": "923853633921-umqle35np9f8k4mifaidvnhnjn5g0sju.apps.googleusercontent.com",
  "certificate_hash": "417bfc7d9df3fc2603d47de0a7426dd9a1140433"
}
```

The certificate hash matches your SHA-1 fingerprint ✅

---

## Next Steps

1. **Complete Firebase Console Setup** (follow steps above)
2. **Rebuild APK:**
   ```bash
   cd "d:\Trinetra App\trinetra"
   flutter clean
   flutter pub get
   flutter build apk --debug
   ```

3. **Test Google Sign-in:**
   - Install APK on your Android device
   - Click "Sign in with Google" button
   - You should see Google account selection (instead of Error 10)

---

## Troubleshooting

**If Error 10 persists:**
- Ensure SHA-1 is correctly added to Firebase Console
- The SHA-1 must be **exactly** in this format with colons:
  ```
  41:7B:FC:7D:9D:F3:FC:26:03:D4:7D:E0:A7:42:6D:D9:A1:14:04:33
  ```
- Wait 5-10 minutes after adding SHA-1 (Firebase needs time to sync)
- Rebuild and reinstall the APK

**If google-services.json is missing:**
- Firebase Console will provide a download link
- Place it at: `android/app/google-services.json`

---

## Key Project Info

- **Project ID:** trinetra-8eabf
- **Package Name:** com.example.trinetra
- **Android App:** com.example.trinetra
- **Firebase Project:** aniket-gawande/TRINETRA-APP

---

**Last Updated:** January 28, 2026
**Firebase SDK:** firebase_core: ^2.24.2, google_sign_in: ^6.2.1
