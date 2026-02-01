# 🟦 THỰC HÀNH CHƯƠNG 16: CI/CD & RELEASE ỨNG DỤNG FLUTTER

> **📌 DÀNH CHO NGƯỜI ĐÃ CÓ KINH NGHIỆM**
> 
> Bài thực hành này hướng dẫn cách build và release app Flutter lên Google Play và App Store.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Build APK và AAB cho Android
- ✅ Build IPA cho iOS
- ✅ Cấu hình signing cho Android
- ✅ Release app lên Google Play
- ✅ Thiết lập CI/CD cơ bản

---

## 📋 CHECKLIST CHUẨN BỊ

Trước khi bắt đầu, đảm bảo bạn có:
- [ ] Flutter SDK đã cài đặt
- [ ] Android Studio (cho Android build)
- [ ] Xcode (cho iOS build, chỉ trên Mac)
- [ ] Google Play Console account (cho Android)
- [ ] Apple Developer account (cho iOS, $99/năm)

---

## BÀI TẬP 1: CẤU HÌNH VERSION

### Mục đích
Cấu hình version và build number trong pubspec.yaml.

### Yêu cầu

1. **Mở pubspec.yaml:**
Tìm dòng `version:` và sửa:
```yaml
version: 1.0.0+1
#        ↑    ↑
#     version build number
```

**Giải thích:**
- `1.0.0` = Version hiển thị cho user
- `+1` = Build number (phải tăng mỗi lần release)

2. **Tăng version khi cần:**
```yaml
# Sửa bug nhỏ
version: 1.0.1+2

# Thêm tính năng mới
version: 1.1.0+3

# Thay đổi lớn
version: 2.0.0+4
```

### Kết quả mong đợi
- Hiểu cách cấu hình version
- Biết khi nào tăng version nào

---

## BÀI TẬP 2: BUILD APK CHO ANDROID

### Mục đích
Build APK release để cài trên device.

### Yêu cầu

1. **Kiểm tra Flutter setup:**
```bash
flutter doctor
```

2. **Clean build cũ:**
```bash
flutter clean
```

3. **Get dependencies:**
```bash
flutter pub get
```

4. **Build APK release:**
```bash
flutter build apk --release
```

5. **Kiểm tra file output:**
File APK sẽ ở: `build/app/outputs/flutter-apk/app-release.apk`

6. **Cài APK lên device:**
```bash
# Cách 1: Dùng adb
adb install build/app/outputs/flutter-apk/app-release.apk

# Cách 2: Copy file vào device và cài thủ công
```

### Kết quả mong đợi
- Build được APK release
- Cài được APK lên device

---

## BÀI TẬP 3: BUILD AAB CHO GOOGLE PLAY

### Mục đích
Build AAB (Android App Bundle) để upload lên Google Play.

### Yêu cầu

1. **Build AAB:**
```bash
flutter build appbundle --release
```

2. **Kiểm tra file output:**
File AAB sẽ ở: `build/app/outputs/bundle/release/app-release.aab`

3. **Chuẩn bị upload:**
- File `.aab` đã sẵn sàng
- Cần Google Play Console account
- Cần app icon, screenshots, description

### Kết quả mong đợi
- Build được AAB
- Sẵn sàng upload lên Google Play

---

## BÀI TẬP 4: CẤU HÌNH ANDROID SIGNING

### Mục đích
Cấu hình signing để Google Play chấp nhận app.

### Yêu cầu

1. **Tạo keystore:**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**Lưu ý:** 
- Nhớ password!
- Lưu keystore ở nơi an toàn
- KHÔNG commit vào Git

2. **Tạo file key.properties:**
Tạo `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

3. **Cấu hình build.gradle:**
Mở `android/app/build.gradle` và thêm:
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

4. **Build lại:**
```bash
flutter build appbundle --release
```

### Kết quả mong đợi
- Cấu hình được signing
- Build được AAB đã ký

---

## BÀI TẬP 5: RELEASE LÊN GOOGLE PLAY

### Mục đích
Upload app lên Google Play Console.

### Yêu cầu

1. **Chuẩn bị tài liệu:**
- App icon (512x512)
- Screenshots (tối thiểu 2)
- Feature graphic (1024x500)
- Privacy policy URL
- App description

2. **Tạo app trong Google Play Console:**
- Vào https://play.google.com/console
- Tạo app mới
- Điền thông tin cơ bản

3. **Upload AAB:**
- Vào Production → Create new release
- Upload file `.aab`
- Điền release notes
- Review và publish

### Kết quả mong đợi
- Upload được app lên Google Play
- App được review và publish

---

## BÀI TẬP 6: BUILD IPA CHO iOS (CHỈ TRÊN MAC)

### Mục đích
Build IPA để upload lên App Store.

### Yêu cầu

1. **Mở Xcode:**
```bash
open ios/Runner.xcworkspace
```

2. **Cấu hình trong Xcode:**
- Chọn team (Apple Developer account)
- Xcode tự động tạo certificate
- Cấu hình Bundle Identifier

3. **Build IPA:**
```bash
flutter build ipa --release
```

4. **File output:**
File IPA ở: `build/ios/ipa/*.ipa`

5. **Upload lên App Store Connect:**
- Dùng Xcode: Window → Organizer → Distribute App
- Hoặc dùng Transporter app

### Kết quả mong đợi
- Build được IPA
- Sẵn sàng upload lên App Store

---

## BÀI TẬP 7: THIẾT LẬP CI/CD VỚI GITHUB ACTIONS

### Mục đích
Tự động test và build mỗi khi push code.

### Yêu cầu

1. **Tạo workflow file:**
Tạo `.github/workflows/build.yml`:
```yaml
name: Build and Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
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
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-release
        path: build/app/outputs/flutter-apk/app-release.apk
```

2. **Commit và push:**
```bash
git add .github/workflows/build.yml
git commit -m "Add CI/CD workflow"
git push
```

3. **Kiểm tra:**
- Vào GitHub → Actions tab
- Xem workflow chạy
- Download APK từ artifacts

### Kết quả mong đợi
- CI/CD tự động chạy khi push code
- Tự động test và build

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành tất cả bài tập, bạn nên:
- [ ] Build được APK và AAB
- [ ] Cấu hình được Android signing
- [ ] Build được IPA (nếu có Mac)
- [ ] Upload được app lên Google Play
- [ ] Thiết lập được CI/CD

---

## 🎉 KẾT THÚC

Chúc mừng! Bạn đã hoàn thành bài thực hành CI/CD & Release.

👉 **Tiếp theo:** Bài 17 - Laravel + MySQL API hoặc các bài nâng cao khác
