# 🟦 CHƯƠNG 16  
# **CI/CD & RELEASE ỨNG DỤNG FLUTTER**  
*(Build APK – Build IPA – App Store – Google Play – CI/CD Pipeline)*

Sau khi code xong, bạn cần **đóng gói và phát hành** app lên App Store và Google Play.

Chương này hướng dẫn bạn build và release app Flutter một cách chuyên nghiệp.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Build APK cho Android.  
- Build AAB cho Google Play.  
- Build IPA cho iOS (cần Mac).  
- Cấu hình version và build number.  
- Hiểu quy trình release lên store.  
- Thiết lập CI/CD cơ bản.

---

# 1. **Chuẩn bị trước khi build**

## 1.1. **Cấu hình version**

Trong `pubspec.yaml`:

```yaml
version: 1.0.0+1
#        ↑    ↑
#     version build number
```

- **Version** (1.0.0): Version hiển thị cho user
- **Build number** (+1): Số build tăng dần

---

### 🧠 Giảng giải chi tiết: Version và Build Number

**Version là gì?**

- **Version** (1.0.0) = Version hiển thị cho user
- Format: `major.minor.patch`
  - **Major** (1): Thay đổi lớn, không tương thích ngược
  - **Minor** (0): Thêm tính năng mới, tương thích ngược
  - **Patch** (0): Sửa bug, tương thích ngược

**Build Number là gì?**

- **Build number** (+1) = Số build tăng dần mỗi lần build
- Google Play và App Store yêu cầu build number tăng dần
- Không thể giảm, chỉ có thể tăng

**Ví dụ minh họa:**

```yaml
# pubspec.yaml
version: 1.0.0+1  # Version 1.0.0, build 1
version: 1.0.1+2  # Version 1.0.1 (sửa bug), build 2
version: 1.1.0+3  # Version 1.1.0 (thêm tính năng), build 3
version: 2.0.0+4  # Version 2.0.0 (thay đổi lớn), build 4
```

**Quy tắc tăng version:**

```
Sửa bug nhỏ → Patch: 1.0.0 → 1.0.1
Thêm tính năng → Minor: 1.0.0 → 1.1.0
Thay đổi lớn → Major: 1.0.0 → 2.0.0
```

---

## 1.2. **Cấu hình app name và icon**

### App name

Trong `android/app/src/main/AndroidManifest.xml`:

```xml
<application
  android:label="My App Name"
  ...
>
```

Trong `ios/Runner/Info.plist`:

```xml
<key>CFBundleName</key>
<string>My App Name</string>
```

### App icon

- Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

---

# 2. **Build APK cho Android**

APK là file cài đặt cho Android.

### Build APK debug:

```bash
flutter build apk --debug
```

### Build APK release:

```bash
flutter build apk --release
```

File output: `build/app/outputs/flutter-apk/app-release.apk`

---

### 🧠 Giảng giải chi tiết: Build APK

**APK là gì?**

- **APK** (Android Package) = File cài đặt cho Android
- Có thể cài trực tiếp trên device (sideload)
- Không thể upload lên Google Play (phải dùng AAB)

**Các loại APK:**

```bash
# 1. Debug APK - Có debug info, lớn hơn
flutter build apk --debug
# → build/app/outputs/flutter-apk/app-debug.apk

# 2. Release APK - Tối ưu, nhỏ hơn
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk

# 3. Split APK - Chia theo ABI (arm64, x86_64...)
flutter build apk --split-per-abi
# → Tạo nhiều file APK nhỏ hơn
```

**Ví dụ minh họa từng bước:**

```bash
# BƯỚC 1: Kiểm tra Flutter setup
flutter doctor

# BƯỚC 2: Clean build cũ (tùy chọn)
flutter clean

# BƯỚC 3: Get dependencies
flutter pub get

# BƯỚC 4: Build APK release
flutter build apk --release

# BƯỚC 5: File APK ở đây:
# build/app/outputs/flutter-apk/app-release.apk
```

**Cài APK lên device:**

```bash
# Cách 1: Dùng adb
adb install build/app/outputs/flutter-apk/app-release.apk

# Cách 2: Copy file vào device và cài thủ công
# Bật "Unknown sources" trong Settings
```

---

# 3. **Build AAB cho Google Play**

AAB (Android App Bundle) là format **bắt buộc** cho Google Play.

### Build AAB:

```bash
flutter build appbundle --release
```

File output: `build/app/outputs/bundle/release/app-release.aab`

---

### 🧠 Giảng giải chi tiết: AAB là gì?

**AAB là gì?**

- **AAB** (Android App Bundle) = Format mới của Google
- Google Play tự động tạo APK tối ưu cho từng device
- **Bắt buộc** cho app mới trên Google Play (từ 2021)
- Nhỏ hơn APK (chỉ tải code cần thiết)

**So sánh APK vs AAB:**

| Đặc điểm | APK | AAB |
|----------|-----|-----|
| **Kích thước** | Lớn (chứa tất cả) | Nhỏ hơn (tối ưu) |
| **Google Play** | Không chấp nhận (app mới) | Bắt buộc |
| **Cài trực tiếp** | ✅ Có thể | ❌ Không thể |
| **Tối ưu** | Không | ✅ Tự động |

**Ví dụ minh họa:**

```bash
# Build AAB release
flutter build appbundle --release

# File output:
# build/app/outputs/bundle/release/app-release.aab

# Upload lên Google Play Console:
# 1. Vào Google Play Console
# 2. Chọn app
# 3. Production → Create new release
# 4. Upload file .aab
# 5. Review và publish
```

---

# 4. **Build IPA cho iOS (cần Mac)**

IPA là file cài đặt cho iOS.

### Yêu cầu:

- Mac computer
- Xcode đã cài
- Apple Developer account ($99/năm)
- Certificate và Provisioning Profile

### Build IPA:

```bash
flutter build ipa --release
```

File output: `build/ios/ipa/*.ipa`

---

### 🧠 Giảng giải chi tiết: Build IPA

**IPA là gì?**

- **IPA** (iOS App) = File cài đặt cho iOS
- Chỉ build được trên **Mac**
- Cần **Apple Developer account** ($99/năm)
- Upload lên App Store Connect

**Quy trình build IPA:**

```
1. Cấu hình Xcode
   ↓
2. Tạo Certificate & Provisioning Profile
   ↓
3. Build IPA
   ↓
4. Upload lên App Store Connect
   ↓
5. Submit for review
```

**Ví dụ minh họa từng bước:**

```bash
# BƯỚC 1: Mở Xcode để cấu hình
open ios/Runner.xcworkspace

# BƯỚC 2: Trong Xcode:
# - Chọn team (Apple Developer account)
# - Xcode tự động tạo certificate
# - Cấu hình Bundle Identifier

# BƯỚC 3: Build IPA
flutter build ipa --release

# BƯỚC 4: File IPA ở đây:
# build/ios/ipa/*.ipa
```

**Upload lên App Store Connect:**

```bash
# Cách 1: Dùng Xcode
# Xcode → Window → Organizer → Archives → Distribute App

# Cách 2: Dùng command line
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/*.ipa \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID
```

---

# 5. **Cấu hình signing (ký ứng dụng)**

## 5.1. **Android Signing**

Tạo keystore:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Cấu hình trong `android/key.properties`:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

Cấu hình trong `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

---

### 🧠 Giảng giải chi tiết: Android Signing

**Signing là gì?**

- **Signing** = Ký ứng dụng bằng digital certificate
- Đảm bảo app **không bị giả mạo**
- **Bắt buộc** cho release build
- Google Play yêu cầu signing

**Cơ chế hoạt động:**

```
Tạo keystore (1 lần)
    ↓
Lưu keystore an toàn
    ↓
Cấu hình trong build.gradle
    ↓
Mỗi lần build → Tự động ký
```

**Ví dụ minh họa từng bước:**

```bash
# BƯỚC 1: Tạo keystore (CHỈ LÀM 1 LẦN!)
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Nhập thông tin:
# - Password: (nhớ kỹ!)
# - Name, Organization, City, Country...

# BƯỚC 2: Tạo file key.properties
# android/key.properties
storePassword=your_password
keyPassword=your_password
keyAlias=upload
storeFile=/Users/yourname/upload-keystore.jks

# BƯỚC 3: Cấu hình build.gradle
# (Xem code ở trên)

# BƯỚC 4: Build (tự động ký)
flutter build appbundle --release
```

**Lưu ý quan trọng:**

- **Lưu keystore an toàn** - Mất keystore = không update app được!
- **Đừng commit keystore** vào Git
- **Backup keystore** ở nhiều nơi

---

## 5.2. **iOS Signing**

Cấu hình trong Xcode:

1. Mở `ios/Runner.xcworkspace`
2. Chọn target "Runner"
3. Tab "Signing & Capabilities"
4. Chọn Team (Apple Developer account)
5. Xcode tự động tạo certificate

---

# 6. **Release lên Google Play**

## 6.1. **Chuẩn bị**

- Google Play Console account ($25 một lần)
- App icon, screenshots
- Privacy policy URL
- Content rating

## 6.2. **Upload AAB**

1. Vào [Google Play Console](https://play.google.com/console)
2. Chọn app → Production → Create new release
3. Upload file `.aab`
4. Điền release notes
5. Review và publish

---

### 🧠 Giảng giải chi tiết: Release lên Google Play

**Quy trình release:**

```
1. Chuẩn bị tài liệu
   ├── App icon (512x512)
   ├── Screenshots (tối thiểu 2)
   ├── Feature graphic (1024x500)
   ├── Privacy policy URL
   └── Content rating
   ↓
2. Tạo app trong Google Play Console
   ↓
3. Upload AAB
   ↓
4. Điền thông tin
   ├── App name, description
   ├── Screenshots
   ├── Release notes
   └── Content rating
   ↓
5. Review (1-3 ngày)
   ↓
6. Published!
```

**Ví dụ minh họa từng bước:**

```bash
# BƯỚC 1: Build AAB
flutter build appbundle --release

# BƯỚC 2: Vào Google Play Console
# https://play.google.com/console

# BƯỚC 3: Tạo app mới (lần đầu)
# - App name
# - Default language
# - App type (Free/Paid)
# - Privacy policy URL

# BƯỚC 4: Production → Create new release
# - Upload app-release.aab
# - Release name: "1.0.0"
# - Release notes: "Initial release"

# BƯỚC 5: Store listing
# - Short description (80 ký tự)
# - Full description (4000 ký tự)
# - Screenshots (tối thiểu 2)
# - App icon (512x512)

# BƯỚC 6: Content rating
# - Điền questionnaire
# - Submit for rating

# BƯỚC 7: Review và publish
# - Google review (1-3 ngày)
# - Nếu OK → Published!
```

**Lưu ý quan trọng:**

- **Version code** phải tăng dần mỗi lần release
- **Privacy policy** bắt buộc nếu app thu thập data
- **Content rating** bắt buộc
- **Review time**: 1-3 ngày (lần đầu có thể lâu hơn)

---

# 7. **Release lên App Store**

## 7.1. **Chuẩn bị**

- Apple Developer account ($99/năm)
- App icon, screenshots
- Privacy policy URL
- App Store Connect setup

## 7.2. **Upload IPA**

1. Build IPA: `flutter build ipa --release`
2. Upload lên App Store Connect (dùng Xcode hoặc Transporter)
3. Điền thông tin app
4. Submit for review

---

### 🧠 Giảng giải chi tiết: Release lên App Store

**Quy trình release:**

```
1. Chuẩn bị tài liệu
   ├── App icon (1024x1024)
   ├── Screenshots (nhiều kích thước)
   ├── Privacy policy URL
   └── App description
   ↓
2. Tạo app trong App Store Connect
   ↓
3. Build và upload IPA
   ↓
4. Điền thông tin
   ├── App name, description
   ├── Screenshots
   ├── Keywords
   └── Privacy policy
   ↓
5. Submit for review (1-7 ngày)
   ↓
6. Approved!
```

**Ví dụ minh họa từng bước:**

```bash
# BƯỚC 1: Build IPA
flutter build ipa --release

# BƯỚC 2: Vào App Store Connect
# https://appstoreconnect.apple.com

# BƯỚC 3: Tạo app mới (lần đầu)
# - App name
# - Primary language
# - Bundle ID
# - SKU (unique identifier)

# BƯỚC 4: Upload IPA
# Cách 1: Dùng Xcode
# Xcode → Window → Organizer → Distribute App

# Cách 2: Dùng Transporter app
# Download Transporter từ Mac App Store
# Upload file .ipa

# BƯỚC 5: Điền thông tin
# - App description
# - Screenshots (nhiều kích thước)
# - Keywords
# - Privacy policy URL
# - Support URL

# BƯỚC 6: Submit for review
# - Chọn build
# - Điền review information
# - Submit

# BƯỚC 7: Chờ review (1-7 ngày)
# - Nếu OK → Approved!
# - Nếu reject → Sửa và resubmit
```

**Lưu ý quan trọng:**

- **Build number** phải tăng dần
- **Privacy policy** bắt buộc
- **Review time**: 1-7 ngày (lần đầu có thể lâu hơn)
- **Rejection** có thể xảy ra → Đọc feedback và sửa

---

# 8. **CI/CD cơ bản**

CI/CD = **Continuous Integration / Continuous Deployment**

## 8.1. **GitHub Actions**

Tạo file `.github/workflows/build.yml`:

```yaml
name: Build and Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test
    
    - name: Build APK
      run: flutter build apk --release
```

---

### 🧠 Giảng giải chi tiết: CI/CD là gì?

**CI/CD là gì?**

- **CI** (Continuous Integration) = Tự động test mỗi khi push code
- **CD** (Continuous Deployment) = Tự động deploy khi test pass
- Giúp **phát hiện bug sớm**
- **Tự động hóa** quy trình build và release

**Lợi ích:**

1. ✅ **Phát hiện bug sớm** - Test tự động chạy mỗi khi push
2. ✅ **Tự động build** - Không cần build thủ công
3. ✅ **Consistency** - Môi trường build giống nhau
4. ✅ **Time saving** - Không cần build thủ công

**Ví dụ minh họa: GitHub Actions**

```yaml
# .github/workflows/build.yml
name: Build and Test

# Khi nào chạy?
on:
  push:
    branches: [ main, develop ]  # Push vào main/develop
  pull_request:
    branches: [ main ]            # PR vào main

jobs:
  test:
    runs-on: ubuntu-latest        # Chạy trên Ubuntu
    
    steps:
    # BƯỚC 1: Checkout code
    - uses: actions/checkout@v3
    
    # BƯỚC 2: Setup Flutter
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    # BƯỚC 3: Install dependencies
    - name: Install dependencies
      run: flutter pub get
    
    # BƯỚC 4: Run tests
    - name: Run tests
      run: flutter test
    
    # BƯỚC 5: Build APK
    - name: Build APK
      run: flutter build apk --release
    
    # BƯỚC 6: Upload artifact
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-release
        path: build/app/outputs/flutter-apk/app-release.apk
```

**Các CI/CD platform phổ biến:**

- **GitHub Actions** - Tích hợp với GitHub
- **GitLab CI** - Tích hợp với GitLab
- **Jenkins** - Self-hosted
- **CircleCI** - Cloud-based
- **Codemagic** - Chuyên cho Flutter

---

# 9. **Sai vs Đúng – lỗi sinh viên hay gặp**

## ❌ Sai: Quên tăng build number

```yaml
version: 1.0.0+1  # Vẫn là build 1
# → Google Play/App Store từ chối!
```

---

### 🔍 Giảng giải chi tiết: Tại sao cần tăng build number?

**Ví dụ minh họa lỗi:**

```yaml
# ❌ SAI: Build number không tăng
# Lần 1:
version: 1.0.0+1

# Lần 2 (release mới):
version: 1.0.1+1  # ← Vẫn là build 1!
# → Google Play từ chối: "Version code must be higher"
```

**✅ Giải pháp:**

```yaml
# ✅ ĐÚNG: Build number tăng dần
# Lần 1:
version: 1.0.0+1

# Lần 2:
version: 1.0.1+2  # ← Tăng build number

# Lần 3:
version: 1.1.0+3  # ← Tăng build number
```

---

## ✔ Đúng: Luôn tăng build number mỗi lần release

---

## ❌ Sai: Commit keystore vào Git

```bash
git add android/upload-keystore.jks  # Nguy hiểm!
```

---

### 🔍 Giảng giải chi tiết: Tại sao không commit keystore?

**Vấn đề:**

- Keystore chứa **private key** để ký app
- Nếu leak → Người khác có thể ký app thay bạn
- **Không thể recover** nếu mất keystore
- Google Play không cho update app nếu mất keystore

**✅ Giải pháp:**

```bash
# Thêm vào .gitignore
echo "*.jks" >> .gitignore
echo "*.keystore" >> .gitignore
echo "key.properties" >> .gitignore

# Lưu keystore ở nơi an toàn:
# - Password manager
# - Encrypted backup
# - Cloud storage (encrypted)
```

---

## ✔ Đúng: Thêm keystore vào .gitignore, lưu an toàn

---

## ❌ Sai: Build release mà chưa test

```bash
flutter build apk --release  # Chưa test!
# → Có thể có bug trong production!
```

---

### 🔍 Giảng giải chi tiết: Tại sao cần test trước khi build?

**Ví dụ minh họa:**

```bash
# ❌ SAI: Build ngay không test
flutter build apk --release
# → Có thể có bug, crash, performance issue!

# ✅ ĐÚNG: Test trước khi build
flutter test                    # Unit test
flutter test integration_test   # Integration test
flutter build apk --release     # Build sau khi test pass
```

---

## ✔ Đúng: Test đầy đủ trước khi build release

---

## 🔴 Case Study: Các lỗi khác thường gặp

### Case Study 1: Build number giảm

#### ❌ Vấn đề:

```yaml
# Lần 1: version: 1.0.0+5
# Lần 2: version: 1.0.1+3  # ← Giảm từ 5 xuống 3!
# → Google Play từ chối!
```

#### ✅ Giải pháp:

```yaml
# Luôn tăng build number
# Lần 1: version: 1.0.0+5
# Lần 2: version: 1.0.1+6  # ← Tăng lên 6
```

---

### Case Study 2: Quên cấu hình signing

#### ❌ Vấn đề:

```bash
flutter build appbundle --release
# → Build thành công nhưng không được ký
# → Google Play từ chối: "App not signed"
```

#### ✅ Giải pháp:

```bash
# 1. Tạo keystore
keytool -genkey -v -keystore ~/upload-keystore.jks ...

# 2. Cấu hình key.properties
# 3. Cấu hình build.gradle
# 4. Build lại
flutter build appbundle --release
```

---

### Case Study 3: Build trên Windows cho iOS

#### ❌ Vấn đề:

```bash
# Trên Windows:
flutter build ipa --release
# → Lỗi: iOS build chỉ chạy trên Mac!
```

#### ✅ Giải pháp:

```bash
# Phải build trên Mac
# Hoặc dùng CI/CD service có Mac runner
# Hoặc dùng Codemagic (có Mac)
```

---

# 10. **Best Practices**

## 10.1. **Version Management**

- **Semantic Versioning**: `major.minor.patch`
- **Build number** luôn tăng
- **Changelog** rõ ràng cho mỗi version

## 10.2. **Security**

- **Không commit** keystore vào Git
- **Backup keystore** ở nhiều nơi an toàn
- **Dùng environment variables** cho sensitive data

## 10.3. **Testing**

- **Test đầy đủ** trước khi build release
- **Test trên device thật** trước khi release
- **Beta testing** với TestFlight (iOS) / Internal testing (Android)

## 10.4. **CI/CD**

- **Tự động test** mỗi khi push code
- **Tự động build** khi merge vào main
- **Tự động deploy** (nếu cần)

---

# 11. Bài tập thực hành

1. Build APK release và cài lên Android device.  
2. Build AAB và chuẩn bị upload lên Google Play.  
3. Cấu hình Android signing với keystore.  
4. Tăng version và build number trong pubspec.yaml.  
5. Thiết lập GitHub Actions để tự động test và build.

---

# 12. Mini Test cuối chương

**Câu 1:** APK và AAB khác nhau như thế nào?  
→ APK cài trực tiếp được, AAB chỉ dùng cho Google Play (tối ưu hơn).

**Câu 2:** Build number là gì?  
→ Số build tăng dần, bắt buộc phải tăng mỗi lần release.

**Câu 3:** Tại sao cần signing?  
→ Đảm bảo app không bị giả mạo, bắt buộc cho release.

**Câu 4:** Tại sao không commit keystore vào Git?  
→ Keystore chứa private key, nếu leak → nguy hiểm bảo mật.

**Câu 5:** CI/CD là gì?  
→ Tự động test và build mỗi khi push code.

**Câu 6:** Version 1.0.0+1 nghĩa là gì?  
→ Version 1.0.0, build number 1.

**Câu 7:** Tại sao build number không thể giảm?  
→ Google Play và App Store yêu cầu build number tăng dần.

**Câu 8:** IPA build được trên Windows không?  
→ Không, chỉ build được trên Mac (cần Xcode).

**Câu 9:** AAB có thể cài trực tiếp lên device không?  
→ Không, chỉ upload lên Google Play, Google tự tạo APK.

**Câu 10:** Tại sao cần test trước khi build release?  
→ Đảm bảo không có bug, crash, performance issue trong production.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **APK** = File cài Android (sideload), **AAB** = File cho Google Play (bắt buộc).  
- **IPA** = File cài iOS, chỉ build được trên **Mac**.  
- **Version** = Hiển thị cho user (1.0.0), **Build number** = Số build (+1).  
- **Signing** = Ký app bằng keystore, **bắt buộc** cho release.  
- **Không commit keystore** vào Git, **backup an toàn**.  
- **Build number** phải **tăng dần**, không thể giảm.  
- **Test đầy đủ** trước khi build release.  
- **CI/CD** = Tự động test và build mỗi khi push code.  
- **Google Play** yêu cầu AAB, **App Store** yêu cầu IPA.  
- **Review time**: Google Play 1-3 ngày, App Store 1-7 ngày.

---

# 🎉 Kết thúc chương 16  
Bạn đã hoàn thành toàn bộ khóa học Flutter! Chúc mừng! 🎊

👉 **Bây giờ bạn đã sẵn sàng xây dựng ứng dụng Flutter thực tế!**

