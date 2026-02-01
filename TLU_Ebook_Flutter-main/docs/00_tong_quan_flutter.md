# 🟦 CHƯƠNG 00  
# **TỔNG QUAN VỀ FLUTTER – BẠN SẮP HỌC GÌ VÀ VÌ SAO?**

Flutter là một bộ công cụ (framework) do Google phát triển, dùng để xây dựng **ứng dụng đa nền tảng**: Android, iOS, Web, Desktop và thậm chí cả Embedded — tất cả từ **một bộ code duy nhất**.

Trong chương này, bạn sẽ hiểu Flutter là gì, vì sao nó mạnh, và bạn sẽ học những gì trong giáo trình này.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này, bạn sẽ:

- Biết Flutter là gì và giải quyết vấn đề gì.  
- Hiểu sự khác biệt giữa Flutter và các framework khác.  
- Nắm được kiến trúc cơ bản của Flutter: Widget Tree → Render → UI.  
- Tự chạy được ứng dụng “Hello Flutter” đầu tiên.  
- Nắm tổng quan toàn giáo trình Flutter.

---

# 1. **Flutter là gì?**

Flutter là framework UI đa nền tảng (cross-platform) được Google phát triển, giúp bạn viết:

- 1 codebase → chạy được **Android**  
- 1 codebase → chạy **iOS**  
- 1 codebase → chạy **Web**  
- 1 codebase → chạy **Desktop** (Windows, macOS, Linux)  

=> Không cần viết lại nhiều lần cho các nền tảng khác nhau.

---

### 🎒 Ví dụ đời sống  
Flutter giống như **một bếp trung tâm nấu được mọi món**:

- Bạn nấu một nồi  
- Nhưng dọn ra được: tô Android, đĩa iOS, khay Desktop, suất Web

Cùng một công thức → nhiều phiên bản.

---

# 2. **Điểm mạnh của Flutter**

## 🟩 2.1. Hot Reload – chỉnh là thấy ngay  
Flutter cho phép thay đổi UI và xem kết quả **ngay lập tức**.

Sinh viên lười cũng thích tính năng này — chỉnh code xíu là thấy khác liền.

## 🟩 2.2. UI mượt như native  
Flutter render UI bằng chính engine của nó (Skia), không phụ thuộc vào UI của hệ điều hành.

=> Mượt như app gốc.

## 🟩 2.3. Hệ sinh thái plugin khổng lồ  
Cần Google Maps? Firebase? Camera?  
→ Một dòng `dependencies:` là xong.

## 🟩 2.4. Dùng Dart – dễ học  
Dart đơn giản hơn Java/Kotlin/Swift rất nhiều.  
Bạn vừa học xong Dart → chuyển sang Flutter rất mượt.

---

# 3. **Kiến trúc Flutter – hiểu đúng ngay từ đầu**

Flutter có 3 tầng chính:

```
UI (Widgets)
↓
Element Tree
↓
Render Tree
```

Nhưng ở mức cơ bản, bạn chỉ cần hiểu:

---

## **Widget Tree là trái tim của Flutter**

Mọi thứ trong Flutter đều là **Widget**:

- Text → là widget  
- Button → là widget  
- Hình ảnh → widget  
- Màn hình → widget  
- App → cũng là widget luôn  

Flutter nói chuyện với bạn bằng Widget.

---

### 🌳 Ví dụ hình dung  
Widget Tree giống như **cây gia phả của một gia đình**:

- Ông A (Scaffold)  
  - Bố B (Column)  
    - Con C (Text)  
    - Con D (Button)  

Tổ chức rõ ràng → dễ sửa.

---

# 4. **Một ứng dụng Flutter cơ bản trông như thế nào?**

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Hello Flutter")),
        body: const Center(child: Text("Xin chào!")),
      ),
    );
  }
}
```

Đây là cấu trúc **chuẩn**:

- `main()` chạy app  
- `MyApp` là widget gốc  
- `MaterialApp` cấu hình app  
- `Scaffold` → khung UI  
- `Text` → hiển thị chữ  

---

# 5. **Flutter hoạt động như thế nào? — Giải thích siêu dễ**

Flutter **không** dùng UI gốc của Android/iOS.  

Nó:

1. Lấy Widget Tree bạn tạo  
2. Tự render UI bằng engine Skia  
3. Gửi hình ảnh “đã xử lý” lên màn hình  

Giống như:

- Bạn vẽ lên canvas  
- Flutter lấy canvas đó hiển thị

=> Không phụ thuộc nền tảng → nhất quán → nhanh.

---

# 6. **Flutter dùng Dart – vì sao?**

Dart được chọn vì:

- Fast JIT (hot reload)  
- Fast AOT (build release cực nhanh)  
- Cú pháp sạch, dễ học  
- Hỗ trợ async tuyệt vời  
- Tối ưu cho UI  

Bạn đã học Dart xong → học Flutter như “gắn động cơ vào khung xe”.

---

# 7. **Những gì bạn sẽ học trong giáo trình này**

## PHẦN I – Flutter Cơ bản  
- Widgets  
- Layout  
- Navigation  
- Input & Form  
- State Management

## PHẦN II – Flutter Trung cấp  
- HTTP API  
- JSON  
- Provider  
- Local Storage (SQLite + SharedPreferences)

## PHẦN III – Flutter Nâng cao  
- Firebase  
- Animation  
- Clean Architecture  
- Testing  
- CI/CD  
- Build & Release App thật

Mỗi chương có **Mini Projects**.

---

# 8. **Các lỗi thường gặp của sinh viên (và cách tránh)**

| Lỗi | Nguyên nhân | Cách sửa |
|-----|-------------|----------|
| Không hiểu Stateless/Stateful | thiếu nền tảng OOP | sẽ học kỹ ở chương 04 |
| Bối rối vì quá nhiều widget | chưa hiểu widget tree | vẽ cây widget trước khi code |
| Code tất cả trong 1 file | copy code từ YouTube | luôn tách file theo modules |
| Layout bị lệch, đổ vỡ | quên dùng Expanded/Flexible | có ví dụ chi tiết ở chương 05 |
| Build lỗi vì thiếu dependency | quên `pub get` | luôn chạy `flutter pub get` |

---

# 9. **Bài tập nhẹ – làm quen**

1. Cài Flutter và chạy thử lệnh:  
   ```
   flutter doctor
   ```
2. Tạo dự án đầu tiên và đổi text “Hello World” thành tên bạn.  
3. Thêm một widget Text thứ 2.  
4. Tự vẽ cây Widget Tree cho màn hình đó.

---

# 10. **Mini Test cuối chương**

**Câu 1:** Flutter là framework gì?  
→ Framework UI đa nền tảng.

**Câu 2:** Flutter render UI thông qua gì?  
→ Engine Skia.

**Câu 3:** Mọi thứ trong Flutter đều là gì?  
→ Widget.

**Câu 4:** Tính năng giúp xem kết quả ngay khi sửa code?  
→ Hot reload.

**Câu 5:** Một code Flutter có thể chạy ở đâu?  
→ Android, iOS, Web, Desktop.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- Flutter = đa nền tảng, 1 code chạy khắp nơi.  
- UI của Flutter = Widget Tree.  
- Dart giúp hot reload + build nhanh.  
- Scaffold + MaterialApp = bộ khung cơ bản của mọi app.  
- Bạn sửa code → UI đổi ngay.  
- Flutter dễ học hơn React Native/Android Native rất nhiều.

---

# 🎉 Kết thúc chương 00  
Tiếp theo hãy bắt đầu vào phần thực hành cốt lõi:

👉 **Chương 01 – Cài đặt & Thiết lập môi trường Flutter**

