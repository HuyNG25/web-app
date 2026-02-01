# 🟦 CHƯƠNG 01  
# **CÀI ĐẶT & THIẾT LẬP MÔI TRƯỜNG FLUTTER**  
*(Chuẩn “cầm tay chỉ việc”, chống lạc đường cho sinh viên)*

Trong chương này, bạn sẽ cài đặt toàn bộ môi trường để có thể chạy một ứng dụng Flutter đầu tiên.  
Nội dung được trình bày chi tiết để sinh viên không bị “vỡ mặt” vì lỗi cài đặt — điều xảy ra rất thường xuyên.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này, bạn sẽ:

- Cài đặt Flutter SDK.  
- Cấu hình development environment: VSCode hoặc Android Studio.  
- Tạo emulator để chạy app.  
- Kết nối điện thoại thật với máy tính.  
- Fix được hầu hết lỗi cài đặt mà sinh viên hay gặp.  
- Chạy thành công app Flutter đầu tiên.

---

# 1. **Cài đặt Flutter SDK**

## 📥 1.1. Tải Flutter SDK  
Truy cập:  
https://flutter.dev/docs/get-started/install

Chọn **Windows / macOS / Linux** tùy hệ điều hành của bạn.

Ví dụ Windows: tải file `.zip`.

---

## 📦 1.2. Giải nén & đặt thư mục Flutter

Giải nén vào thư mục không dấu, không khoảng trắng.  

**KHÔNG đặt ở:**  
- `C:/Program Files/`  
- `C:/Users/Admin/Desktop/Flutter Final Version Last Update` (tên dài cực kỳ dễ lỗi)

**NÊN đặt ở:**  
```
C:/flutter
```

---

## 🔧 1.3. Thêm Flutter vào PATH

### Windows  
Trong thanh tìm kiếm → gõ “Edit environment variables”.

Thêm đường dẫn:

```
C:/flutter/bin
```

### macOS/Linux  
Thêm vào `.zshrc` hoặc `.bashrc`:

```
export PATH="$PATH:/Users/yourname/flutter/bin"
```

---

## ✔ 1.4. Kiểm tra  
Mở terminal:

```
flutter doctor
```

Nếu hiện:

```
Doctor summary: no issues found!
```

-> Bạn đã cài xong phần 1.

Nếu có lỗi → xem phần “Sửa lỗi thường gặp”.

---

# 2. **Cài đặt Android Studio (bắt buộc để build Android)**

## 📌 2.1. Tải Android Studio  
https://developer.android.com/studio

## 📌 2.2. Cài đặt Android SDK & Tools

Mở Android Studio →  
**More Actions → SDK Manager**

Cài:

- Android SDK  
- Android SDK Platform  
- Android Virtual Device (AVD)  
- Android SDK Platform-Tools  
- Google USB Driver  

---

# 3. **Cài đặt VSCode (Khuyến nghị cho sinh viên)**

VSCode nhẹ, dễ chạy, phù hợp cho sinh viên cấu hình máy yếu.

Cài Extensions cần thiết:

- **Flutter**  
- **Dart**  
- **Error Lens** (hiển thị lỗi rõ hơn)  
- **Flutter Widget Snippets**  
- **Material Icon Theme**

---

# 4. **Tạo Emulator (Máy ảo Android)**

Trong Android Studio:

```
More Actions → Virtual Device Manager → Create Device
```

Chọn:

- Pixel 5 / Pixel 6 (ưu tiên)  
- API 33 trở lên (Android 13)  

Sau khi tạo → nhấn **Start**.

---

# 5. **Kết nối điện thoại thật (khuyến khích)**

Cách học nhanh nhất là chạy Flutter trên điện thoại thật.

## 📱 Android

1. Mở **Developer Options → USB Debugging**.  
2. Kết nối USB.  
3. Terminal:

```
flutter devices
```

Nếu hiện tên điện thoại → kết nối OK.

## 🍎 iPhone (chỉ áp dụng macOS + Xcode)

1. Cài Xcode từ App Store.  
2. Cắm iPhone.  
3. Xcode → Open Dev Tools → Devices.  
4. Trust computer.

---

# 6. **Tạo dự án Flutter đầu tiên**

Trong VSCode hoặc Terminal:

```
flutter create hello_flutter
```

Chạy:

```
cd hello_flutter
flutter run
```

Nếu thấy màn hình màu xanh với chữ:

```
Flutter Demo Home Page
```

→ Bạn đã chính thức chạy thành công ứng dụng Flutter đầu tiên.

---

# 7. **Cấu trúc dự án vừa tạo (Hiểu cực nhanh)**

```
hello_flutter/
│
├── lib/
│   └── main.dart      <-- file chính
│
├── android/           <-- build Android
├── ios/               <-- build iOS
├── web/
├── test/
└── pubspec.yaml       <-- quản lý package + assets
```

Chúng ta sẽ học chi tiết ở chương 03.

---

# 8. **Các lỗi sinh viên thường gặp (và cách tự sửa)**

| Lỗi | Nguyên nhân | Cách sửa |
|-----|-------------|----------|
| flutter: command not found | quên PATH | thêm `flutter/bin` vào PATH |
| adb not found | thiếu Platform-Tools | mở SDK Manager và cài “Platform-Tools” |
| Device not showing | chưa bật USB Debugging / driver | bật Developer Mode / cài Google USB Driver |
| build failed | thiếu SDK hoặc Gradle | chạy lại `flutter doctor` |
| emulator chạy chậm | CPU yếu | dùng điện thoại thật |

---

# 9. **Bài tập thực hành nhẹ**

1. Chạy `flutter doctor` và sửa tất cả cảnh báo.  
2. Tạo project `hello_student` và đổi text thành tên bạn.  
3. Tạo một emulator Pixel 5 chạy Android 13.  
4. Kết nối điện thoại thật và chạy app lên đó.  
5. Thử sửa màu AppBar hoặc background.

---

# 10. **Mini Test cuối chương**

**Câu 1:** Lệnh kiểm tra môi trường Flutter?  
→ `flutter doctor`

**Câu 2:** Thư mục chứa file code chính của Flutter?  
→ `lib/`

**Câu 3:** Công cụ chạy máy ảo Android?  
→ Android Studio AVD Manager

**Câu 4:** Tạo project Flutter bằng lệnh gì?  
→ `flutter create ten_project`

**Câu 5:** File cấu hình dependencies nằm ở đâu?  
→ `pubspec.yaml`

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- Flutter cần SDK + Android Studio (để build Android) + Editor (VSCode/Android Studio).  
- `flutter doctor` là bạn thân.  
- Dùng điện thoại thật chạy Flutter nhanh hơn emulator.  
- Đặt thư mục flutter ở nơi *không có dấu và không quá dài*.  
- Đã chạy được app đầu tiên nghĩa là bạn đã sẵn sàng cho phần UI.

---

# 🎉 Kết thúc chương 01  
Bây giờ ta tiếp tục với phần Dart dành riêng cho Flutter:

👉 **Chương 02 – Dart cho Flutter Developer**

