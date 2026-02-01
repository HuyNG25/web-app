# 🟦 THỰC HÀNH CHƯƠNG 01: CÀI ĐẶT & THIẾT LẬP MÔI TRƯỜNG

> **📌 DÀNH CHO NGƯỜI MỚI BẮT ĐẦU**
> 
> Bài thực hành này hướng dẫn từng bước chi tiết để cài đặt Flutter và các công cụ cần thiết.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Cài đặt thành công Flutter SDK
- ✅ Cài đặt và cấu hình VS Code hoặc Android Studio
- ✅ Tạo và chạy được emulator
- ✅ Chạy được app Flutter đầu tiên "Hello World"

---

## 📋 CHECKLIST CHUẨN BỊ

Trước khi bắt đầu, đảm bảo bạn có:
- [ ] Máy tính Windows/macOS/Linux
- [ ] Kết nối Internet ổn định
- [ ] Ít nhất 5GB dung lượng trống
- [ ] Quyền Administrator (Windows) hoặc sudo (macOS/Linux)

---

## BƯỚC 1: CÀI ĐẶT FLUTTER SDK

### 1.1. Tải Flutter SDK

1. Truy cập: https://flutter.dev/docs/get-started/install
2. Chọn hệ điều hành của bạn (Windows/macOS/Linux)
3. Tải file `.zip` (Windows) hoặc `.tar.xz` (macOS/Linux)

**Lưu ý:** Tải phiên bản stable (không phải beta)

### 1.2. Giải nén và đặt thư mục

**Windows:**
```
Giải nén vào: C:\flutter
```

**macOS/Linux:**
```bash
cd ~
tar xf ~/Downloads/flutter_macos_*.tar.xz
mv flutter ~/flutter
```

**⚠️ QUAN TRỌNG:**
- Không đặt trong thư mục có dấu cách hoặc ký tự đặc biệt
- Không đặt trong `Program Files` (Windows)
- Đặt ở thư mục gốc ổ đĩa hoặc thư mục home

### 1.3. Thêm Flutter vào PATH

**Windows:**
1. Tìm kiếm "Environment Variables" trong Start Menu
2. Click "Edit the system environment variables"
3. Click "Environment Variables"
4. Trong "System variables", tìm "Path", click "Edit"
5. Click "New", thêm: `C:\flutter\bin`
6. Click "OK" để lưu

**macOS/Linux:**
Mở terminal và chạy:
```bash
# Thêm vào ~/.zshrc hoặc ~/.bashrc
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### 1.4. Kiểm tra cài đặt

Mở Terminal/Command Prompt mới và chạy:
```bash
flutter --version
```

**Kết quả mong đợi:**
```
Flutter 3.x.x • channel stable
```

Nếu thấy lỗi "command not found", kiểm tra lại PATH.

---

## BƯỚC 2: CHẠY FLUTTER DOCTOR

### 2.1. Chạy lệnh kiểm tra

```bash
flutter doctor
```

### 2.2. Phân tích kết quả

**Kết quả lý tưởng:**
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain
[✓] Chrome
[✓] Visual Studio
[✓] Android Studio
[✓] VS Code
[✓] Connected device
[✓] Network resources
```

**Nếu có dấu [✗] hoặc [!]:**
- Đọc hướng dẫn sửa lỗi bên dưới
- Chạy `flutter doctor -v` để xem chi tiết

---

## BƯỚC 3: CÀI ĐẶT ANDROID STUDIO

### 3.1. Tải Android Studio

1. Truy cập: https://developer.android.com/studio
2. Tải phiên bản mới nhất
3. Cài đặt theo hướng dẫn

### 3.2. Cài đặt Android SDK

1. Mở Android Studio
2. Vào **More Actions → SDK Manager**
3. Chọn tab **SDK Platforms**
4. Chọn **Android 13.0 (Tiramisu)** hoặc mới hơn
5. Chọn tab **SDK Tools**
6. Chọn:
   - ✅ Android SDK Build-Tools
   - ✅ Android SDK Command-line Tools
   - ✅ Android SDK Platform-Tools
   - ✅ Android Emulator
7. Click **Apply** và đợi cài đặt

### 3.3. Cấu hình Flutter với Android Studio

1. Mở Android Studio
2. Vào **File → Settings → Plugins**
3. Tìm và cài **Flutter** plugin
4. Cài **Dart** plugin (tự động cài cùng Flutter)

---

## BƯỚC 4: CÀI ĐẶT VS CODE (Tùy chọn nhưng khuyến nghị)

### 4.1. Tải VS Code

1. Truy cập: https://code.visualstudio.com/
2. Tải và cài đặt

### 4.2. Cài đặt Extensions

1. Mở VS Code
2. Vào **Extensions** (Ctrl+Shift+X)
3. Tìm và cài:
   - ✅ **Flutter** (by Dart Code)
   - ✅ **Dart** (tự động cài cùng Flutter)

### 4.3. Cấu hình Flutter SDK Path

1. Vào **File → Preferences → Settings**
2. Tìm "Flutter SDK Path"
3. Nhập đường dẫn: `C:\flutter` (Windows) hoặc `~/flutter` (macOS/Linux)

---

## BƯỚC 5: TẠO VÀ CHẠY EMULATOR

### 5.1. Tạo Emulator trong Android Studio

1. Mở Android Studio
2. Vào **Tools → Device Manager**
3. Click **Create Device**
4. Chọn **Phone → Pixel 5** (hoặc thiết bị khác)
5. Chọn **System Image:**
   - Chọn **Tiramisu (API 33)** hoặc mới hơn
   - Nếu chưa có, click **Download**
6. Click **Finish**

### 5.2. Khởi động Emulator

1. Trong Device Manager, click nút **Play** ▶️ bên cạnh emulator
2. Đợi emulator khởi động (có thể mất 1-2 phút lần đầu)

### 5.3. Kiểm tra kết nối

Chạy lệnh:
```bash
flutter devices
```

**Kết quả mong đợi:**
```
2 connected devices:

sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 13
Chrome (web)                 • chrome        • web-javascript • Google Chrome
```

---

## BƯỚC 6: TẠO VÀ CHẠY APP ĐẦU TIÊN

### 6.1. Tạo project mới

**Cách 1: Dùng Terminal**
```bash
flutter create my_first_app
cd my_first_app
```

**Cách 2: Dùng VS Code**
1. Mở VS Code
2. **Ctrl+Shift+P** → Gõ "Flutter: New Project"
3. Chọn **Application**
4. Đặt tên: `my_first_app`
5. Chọn thư mục lưu

### 6.2. Mở project

**VS Code:**
```bash
code my_first_app
```

**Android Studio:**
1. **File → Open**
2. Chọn thư mục `my_first_app`

### 6.3. Chạy app

**Cách 1: Terminal**
```bash
flutter run
```

**Cách 2: VS Code**
1. Đảm bảo emulator đang chạy
2. Nhấn **F5** hoặc click nút **Run** ▶️

**Cách 3: Android Studio**
1. Click nút **Run** ▶️ ở thanh toolbar

### 6.4. Kết quả mong đợi

- Emulator hiển thị app Flutter
- Màn hình có text "You have pushed the button this many times:"
- Có nút FloatingActionButton với icon ➕

---

## BƯỚC 7: SỬA CODE VÀ TEST HOT RELOAD

### 7.1. Sửa code

Mở file `lib/main.dart`, tìm dòng:
```dart
title: const Text('Flutter Demo Home Page'),
```

Sửa thành:
```dart
title: const Text('My First App'),
```

### 7.2. Test Hot Reload

**Cách 1:** Nhấn **r** trong terminal đang chạy `flutter run`
**Cách 2:** Click nút **Hot Reload** 🔄 trong VS Code/Android Studio

**Kết quả:** AppBar title thay đổi ngay lập tức!

---

## 🐛 XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi: "Flutter command not found"

**Nguyên nhân:** PATH chưa được cấu hình đúng

**Giải pháp:**
1. Kiểm tra lại PATH
2. Đóng và mở lại Terminal
3. Windows: Restart máy tính

### Lỗi: "Android SDK not found"

**Nguyên nhân:** Android SDK chưa được cài đặt

**Giải pháp:**
1. Cài Android Studio
2. Cài Android SDK qua SDK Manager
3. Chạy `flutter doctor --android-licenses` và chấp nhận tất cả

### Lỗi: "No devices found"

**Nguyên nhân:** Emulator chưa được khởi động

**Giải pháp:**
1. Khởi động emulator từ Android Studio
2. Chạy `flutter devices` để kiểm tra
3. Đảm bảo emulator đã boot xong (không còn màn hình loading)

### Lỗi: "Gradle build failed"

**Nguyên nhân:** Android SDK hoặc Gradle chưa được cấu hình đúng

**Giải pháp:**
1. Chạy `flutter clean`
2. Chạy `flutter pub get`
3. Xóa thư mục `.gradle` trong `android/`
4. Chạy lại `flutter run`

---

## ✅ KIỂM TRA CUỐI CÙNG

Sau khi hoàn thành, đảm bảo:

- [ ] `flutter doctor` không có lỗi nghiêm trọng
- [ ] Emulator chạy được
- [ ] App Flutter chạy được trên emulator
- [ ] Hot reload hoạt động
- [ ] VS Code/Android Studio nhận diện Flutter project

---

## 🎉 HOÀN THÀNH!

Bạn đã cài đặt thành công môi trường Flutter!

**Bước tiếp theo:**
- Đọc [Chương 02: Dart cho Flutter](../02_dart_cho_flutter.md)
- Làm [Bài thực hành 02: Dart](../thuc_hanh/02_thuc_hanh_dart.md)

---

**Cần hỗ trợ?** Xem [Tài liệu chính thức Flutter](https://flutter.dev/docs/get-started/install)
