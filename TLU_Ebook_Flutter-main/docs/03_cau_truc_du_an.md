# 🟦 CHƯƠNG 03  
# **CẤU TRÚC DỰ ÁN FLUTTER & TỔ CHỨC FILE CHUẨN**  
*(Hiểu đúng cấu trúc dự án = viết code không rối, học Flutter không mệt)*

Sinh viên yếu thường bị “ngộp” khi mở dự án Flutter vì có nhiều thư mục lạ.  
Chương này sẽ giải thích cặn kẽ từng phần, ví dụ hoá, và hướng dẫn cách tổ chức dự án như lập trình viên chuyên nghiệp.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này, bạn sẽ:

- Hiểu toàn bộ cấu trúc dự án Flutter.  
- Biết file nào quan trọng, file nào không cần đụng đến.  
- Biết tổ chức thư mục theo module để dự án lớn không rối.  
- Biết pubspec.yaml dùng để làm gì.  
- Biết quản lý assets (ảnh, font, icon…).  

---

# 1. **Cấu trúc dự án Flutter – giải thích đơn giản & rõ ràng**

Khi bạn chạy:

```
flutter create my_app
```

Bạn sẽ có cấu trúc:

```
my_app/
│
├── android/
├── ios/
├── web/
├── linux/
├── macos/
├── windows/
│
├── lib/
│   └── main.dart
│
├── test/
├── pubspec.yaml
└── README.md
```

---

# 2. **Giải thích từng thư mục (Hiểu cực nhanh)**

## 🟩 2.1. lib/ — NƠI QUAN TRỌNG NHẤT  
Toàn bộ code Flutter của bạn nằm ở đây.

```
lib/
  main.dart
  screens/
  widgets/
  models/
  services/
  utils/
```

**Sinh viên chỉ cần quan tâm thư mục này.**

---

### 🧠 Lý thuyết chi tiết về lib/

**lib/ là gì?**

- Thư mục chứa **toàn bộ source code** Flutter
- Mọi file `.dart` đều nằm trong đây
- Flutter chỉ compile code trong `lib/`

**Cấu trúc chuẩn:**

```
lib/
├── main.dart              # Entry point
├── screens/              # Các màn hình
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── home_controller.dart
│   └── profile/
│       └── profile_screen.dart
├── widgets/              # Widget tái sử dụng
│   ├── buttons/
│   │   └── app_button.dart
│   └── cards/
│       └── product_card.dart
├── models/               # Data models
│   ├── user.dart
│   └── product.dart
├── services/             # Business logic, API
│   ├── api_service.dart
│   └── auth_service.dart
├── utils/                # Utilities, helpers
│   ├── constants.dart
│   ├── colors.dart
│   └── helpers.dart
└── routes/               # Navigation routes
    └── app_routes.dart
```

**Quy tắc đặt tên:**

- File: `snake_case.dart` (ví dụ: `home_screen.dart`)
- Class: `PascalCase` (ví dụ: `HomeScreen`)
- Variable: `camelCase` (ví dụ: `userName`)

---

## 🟩 2.2. android/ — cấu hình build cho Android  
Không cần động vào trừ khi:

- đổi tên package  
- build release  
- cài permission (camera, file, internet)

Tương tự với thư mục **ios/**.

---

## 🟩 2.3. web/ — build app Flutter web  
Chỉ quan tâm nếu bạn muốn deploy web.

---

## 🟩 2.4. test/ — viết test code  
Dùng cho unit test, widget test.

---

## 🟩 2.5. pubspec.yaml — file QUAN TRỌNG bậc nhất

File này quản lý:

- dependencies (thư viện)  
- dev_dependencies  
- phiên bản Flutter  
- assets (ảnh, font)  
- tên app, mô tả  

Ví dụ:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  provider: ^6.0.0

assets:
  - assets/images/
  - assets/icons/
```

---

### 🧠 Lý thuyết chi tiết về pubspec.yaml

**pubspec.yaml là gì?**

- File cấu hình **trung tâm** của dự án Flutter
- Quản lý dependencies, assets, metadata
- Tương tự `package.json` trong Node.js

**Cấu trúc đầy đủ:**

```yaml
name: my_app                    # Tên package
description: A Flutter app      # Mô tả
version: 1.0.0+1               # Version (major.minor.patch+build)

environment:
  sdk: '>=3.0.0 <4.0.0'        # Dart SDK version
  flutter: ">=3.0.0"            # Flutter version

dependencies:                   # Thư viện production
  flutter:
    sdk: flutter
  http: ^1.2.0                 # Version constraint
  provider: ^6.0.0

dev_dependencies:               # Thư viện development
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true   # Dùng Material Design icons
  
  assets:                        # Assets (ảnh, data)
    - assets/images/
    - assets/icons/
    - assets/data/config.json
  
  fonts:                         # Custom fonts
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
```

**Version constraints:**

- `^1.2.0` - Tương thích với >=1.2.0 và <2.0.0
- `1.2.0` - Chính xác version 1.2.0
- `>=1.2.0 <2.0.0` - Range cụ thể

**Sau khi sửa pubspec.yaml:**

```bash
flutter pub get  # Cài đặt dependencies mới
```

---

# 3. **Hiểu rõ vai trò của main.dart**

`main.dart` là cửa vào của ứng dụng Flutter:

```dart
void main() {
  runApp(const MyApp());
}
```

App bắt đầu chạy từ widget `MyApp`.

Cấu trúc tối thiểu:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
```

---

# 4. **Tổ chức thư mục lib/ theo chuẩn chuyên nghiệp**

Sinh viên thường mắc lỗi **nhét tất cả vào main.dart**.

Để dự án sạch, ta chia như sau:

```
lib/
│
├── main.dart
│
├── screens/          <-- các màn hình
│     ├── home_screen.dart
│     ├── detail_screen.dart
│     └── login_screen.dart
│
├── widgets/          <-- widget tái sử dụng
│     ├── app_button.dart
│     └── user_avatar.dart
│
├── models/           <-- class dữ liệu
│     └── user.dart
│
├── services/         <-- xử lý logic (API, Auth)
│     ├── api_service.dart
│     └── auth_service.dart
│
├── utils/            <-- hàm tiện ích, constants
│     ├── app_colors.dart
│     └── helpers.dart
│
└── data/             <-- json mock, danh sách mẫu
      └── demo_data.dart
```

---

### 🧠 Lý thuyết chi tiết về tổ chức thư mục

**Nguyên tắc tổ chức:**

1. **Separation of Concerns** - Mỗi thư mục có nhiệm vụ riêng
2. **Reusability** - Widget/services có thể tái sử dụng
3. **Scalability** - Dễ mở rộng khi dự án lớn
4. **Maintainability** - Dễ tìm, dễ sửa

**Chi tiết từng thư mục:**

#### screens/ - Các màn hình

```
screens/
├── home/
│   ├── home_screen.dart
│   └── home_controller.dart
├── profile/
│   ├── profile_screen.dart
│   └── profile_controller.dart
└── auth/
    ├── login_screen.dart
    └── register_screen.dart
```

**Lưu ý:** Có thể tổ chức theo feature (home/, profile/) hoặc flat (tất cả trong screens/)

#### widgets/ - Widget tái sử dụng

```
widgets/
├── buttons/
│   ├── app_button.dart
│   └── icon_button.dart
├── cards/
│   ├── product_card.dart
│   └── user_card.dart
└── common/
    ├── loading_indicator.dart
    └── error_widget.dart
```

**Lưu ý:** Chỉ đặt widget được dùng ở nhiều nơi

#### models/ - Data models

```
models/
├── user.dart
├── product.dart
└── order.dart
```

**Lưu ý:** Mỗi model = 1 file, có fromJson/toJson

#### services/ - Business logic

```
services/
├── api/
│   ├── api_client.dart
│   └── api_endpoints.dart
├── auth/
│   └── auth_service.dart
└── storage/
    └── local_storage.dart
```

**Lưu ý:** Tách theo domain (auth, api, storage)

#### utils/ - Utilities

```
utils/
├── constants.dart      # Hằng số
├── app_colors.dart     # Màu sắc
├── app_styles.dart     # Text styles
└── helpers.dart        # Helper functions
```

---

### 🌟 Ví dụ thực tế: Cấu trúc dự án E-commerce

```
lib/
├── main.dart
│
├── screens/
│   ├── home/
│   │   └── home_screen.dart
│   ├── product/
│   │   ├── product_list_screen.dart
│   │   └── product_detail_screen.dart
│   └── cart/
│       └── cart_screen.dart
│
├── widgets/
│   ├── product_card.dart
│   ├── cart_item.dart
│   └── app_button.dart
│
├── models/
│   ├── product.dart
│   ├── cart_item.dart
│   └── user.dart
│
├── services/
│   ├── product_service.dart
│   ├── cart_service.dart
│   └── api_service.dart
│
├── utils/
│   ├── constants.dart
│   ├── app_colors.dart
│   └── formatters.dart
│
└── routes/
    └── app_routes.dart
```

---

# 5. **Asset management – cách thêm ảnh, font, icon vào Flutter**

Tạo thư mục assets:

```
assets/
  images/
  icons/
  fonts/
```

Chỉnh `pubspec.yaml`:

```yaml
assets:
  - assets/images/
  - assets/icons/
```

Ví dụ dùng ảnh:

```dart
Image.asset("assets/images/banner.png");
```

---

### 🧠 Lý thuyết chi tiết về Assets

**Assets là gì?**

- File tĩnh: ảnh, font, icon, JSON data
- Được bundle vào app khi build
- Truy cập qua `Image.asset()`, `rootBundle.loadString()`

**Cấu trúc thư mục assets:**

```
project_root/
├── lib/
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── banner.jpg
│   │   └── icons/
│   │       └── app_icon.png
│   ├── fonts/
│   │   └── custom_font.ttf
│   └── data/
│       └── config.json
└── pubspec.yaml
```

**Khai báo trong pubspec.yaml:**

```yaml
flutter:
  assets:
    # Toàn bộ thư mục
    - assets/images/
    - assets/icons/
    
    # File cụ thể
    - assets/images/logo.png
    - assets/data/config.json
  
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/CustomFont-Regular.ttf
        - asset: assets/fonts/CustomFont-Bold.ttf
          weight: 700
```

**Sử dụng assets:**

```dart
// Ảnh
Image.asset("assets/images/logo.png")

// Font (trong TextStyle)
TextStyle(fontFamily: "CustomFont")

// JSON data
String jsonString = await rootBundle.loadString("assets/data/config.json");
```

**Lưu ý:**

- Đường dẫn bắt đầu từ `assets/`
- Sau khi thêm assets, chạy `flutter pub get`
- Hot reload không áp dụng cho assets mới (cần restart)

---

# 6. **Ví dụ minh họa: Một dự án Flutter sạch sẽ**

```
lib/
  main.dart
  screens/
    home_screen.dart
    profile_screen.dart
  widgets/
    profile_card.dart
  models/
    user.dart
  services/
    user_service.dart
  utils/
    app_styles.dart
    app_colors.dart
  data/
    fake_users.dart
```

Mỗi phần chỉ làm đúng nhiệm vụ của nó → code dễ hiểu ngay cả với sinh viên mới.

---

# 7. **Sai vs Đúng (dành cho sinh viên thụ động)**

## ❌ Sai — dự án của sinh viên năm nhất
```
lib/
  main.dart      <-- 2000 dòng
  home.dart
  a.dart
  b.dart
  c.dart
```

## ✔ Đúng — dự án theo chuẩn
```
lib/
  main.dart
  screens/
  widgets/
  models/
  services/
  utils/
```

---

## 🔴 Case Study: Các lỗi chi tiết và cách xử lý

### Case Study 1: Tất cả code trong main.dart

#### ❌ Vấn đề:

```dart
// main.dart - 2000+ dòng
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 500 dòng code
}

class HomeScreen extends StatelessWidget {
  // 500 dòng code
}

class ProfileScreen extends StatelessWidget {
  // 500 dòng code
}
// ... nhiều class khác
```

**Hậu quả:**
- Khó tìm code
- Khó maintain
- Khó làm việc nhóm
- Performance kém (hot reload chậm)

#### ✅ Giải pháp:

```dart
// main.dart - Chỉ 20 dòng
import 'package:my_app/screens/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
```

```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   └── profile_screen.dart
└── widgets/
    └── app_button.dart
```

---

### Case Study 2: Đặt tên file không chuẩn

#### ❌ Vấn đề:

```
lib/
  screen1.dart
  screen2.dart
  widget1.dart
  data.dart
```

**Hậu quả:**
- Không biết file nào làm gì
- Khó tìm code
- Khó maintain

#### ✅ Giải pháp:

```
lib/
  screens/
    home_screen.dart
    profile_screen.dart
  widgets/
    product_card.dart
    app_button.dart
  models/
    user.dart
    product.dart
```

**Quy tắc đặt tên:**
- File: `snake_case.dart`
- Mô tả rõ ràng: `home_screen.dart` thay vì `screen1.dart`

---

### Case Study 3: Quên khai báo assets

#### ❌ Vấn đề:

```dart
Image.asset("assets/images/logo.png"); // Lỗi: Asset not found
```

**Nguyên nhân:** Quên khai báo trong `pubspec.yaml`

#### ✅ Giải pháp:

```yaml
flutter:
  assets:
    - assets/images/
```

Sau đó chạy: `flutter pub get`

---

### Case Study 4: Import sai đường dẫn

#### ❌ Vấn đề:

```dart
// Trong home_screen.dart
import '../models/user.dart'; // Lỗi nếu cấu trúc sai
```

#### ✅ Giải pháp:

```dart
// Đúng cấu trúc
lib/
├── screens/
│   └── home_screen.dart
└── models/
    └── user.dart

// Import đúng
import 'package:my_app/models/user.dart';
```

**Lưu ý:** Dùng `package:` import thay vì relative import

---

### Case Study 5: Widget không tái sử dụng được

#### ❌ Vấn đề:

```dart
// Trong home_screen.dart
Widget buildButton() {
  return ElevatedButton(...); // Code lặp lại ở nhiều nơi
}
```

#### ✅ Giải pháp:

```dart
// widgets/app_button.dart
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(...);
  }
}

// Sử dụng
AppButton(
  text: "Click me",
  onPressed: () {},
)
```

---

# 8. **Các lỗi thường gặp**

| Lỗi | Nguyên nhân | Cách sửa |
|-----|-------------|----------|
| Asset not found | quên khai trong pubspec.yaml | thêm đường dẫn assets |
| Too many positional arguments | file main.dart quá phình | tách thành screens/widgets |
| Class duplicate | đặt tên file trùng nhau | theo chuẩn snake_case & folder rõ ràng |
| Import sai | file bị ở nhầm folder | kiểm tra đường dẫn lib/... |
| Không chạy được hot reload | sửa file config | chỉ sửa file trong lib/ |

---

# 9. **Best Practices & Tips**

## 9.1. **Tổ chức file Best Practices**

### 1. Mỗi file chỉ làm 1 việc

```dart
// ✅ ĐÚNG: 1 class = 1 file
// user.dart
class User {
  // ...
}

// ❌ SAI: Nhiều class trong 1 file
// models.dart
class User { }
class Product { }
class Order { }
```

### 2. Đặt tên file rõ ràng

```dart
// ✅ ĐÚNG
home_screen.dart
product_card.dart
user_model.dart

// ❌ SAI
screen1.dart
card.dart
data.dart
```

### 3. Tổ chức theo feature hoặc type

```
// Theo feature
lib/
  features/
    home/
      home_screen.dart
      home_controller.dart
    profile/
      profile_screen.dart

// Theo type (đơn giản hơn cho người mới)
lib/
  screens/
    home_screen.dart
  widgets/
    product_card.dart
```

### 4. Import đúng cách

```dart
// ✅ ĐÚNG: Dùng package import
import 'package:my_app/models/user.dart';
import 'package:my_app/widgets/app_button.dart';

// ❌ SAI: Relative import phức tạp
import '../../../models/user.dart';
```

## 9.2. **pubspec.yaml Best Practices**

### 1. Sắp xếp dependencies theo thứ tự

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Third-party packages
  http: ^1.2.0
  provider: ^6.0.0
```

### 2. Dùng version constraints hợp lý

```yaml
# ✅ ĐÚNG: Cho phép patch updates
http: ^1.2.0

# ❌ SAI: Quá chặt
http: 1.2.0
```

### 3. Khai báo assets rõ ràng

```yaml
assets:
  - assets/images/
  - assets/icons/
  # Không nên: - assets/ (quá rộng)
```

---

# 10. **Bài tập thực hành**

1. **Tạo project `flutter_structure_demo`.**  
   → Chạy: `flutter create flutter_structure_demo`

2. **Tự chia lại thư mục lib/ theo đúng chuẩn.**  
   → Xem cấu trúc phần 4

3. **Thêm thư mục assets/images và khai báo trong pubspec.yaml.**  
   → Xem phần 5

4. **Tạo 2 screens: HomeScreen, ProfileScreen.**  
   → Đặt trong `lib/screens/`

5. **Tạo widget button tái sử dụng có tên: `AppButton`.**  
   → Đặt trong `lib/widgets/`

6. **Tạo model User có name, avatar, age.**  
   → Đặt trong `lib/models/`

7. **Tạo service API giả lập fetch users.**  
   → Đặt trong `lib/services/`

8. **Tạo file constants.dart chứa app colors và sizes.**  
   → Đặt trong `lib/utils/`

9. **Tổ chức lại dự án hiện tại theo cấu trúc chuẩn.**

10. **Tạo feature module hoàn chỉnh: Product (screen, model, service, widget).**

---

# 11. **Mini Test cuối chương**

**Câu 1:** Thư mục nào quan trọng nhất trong Flutter?  
→ `lib/` - chứa toàn bộ source code Flutter.

**Câu 2:** File quản lý dependencies là gì?  
→ `pubspec.yaml` - quản lý packages, assets, metadata.

**Câu 3:** Tại sao phải tách screens/widgets/models?  
→ Code sạch, dễ sửa, dễ mở rộng, dễ làm việc nhóm.

**Câu 4:** Cách thêm assets vào Flutter?  
→ Tạo thư mục assets/ → khai báo trong pubspec.yaml → chạy `flutter pub get` → dùng bằng `Image.asset()`.

**Câu 5:** File đầu vào của Flutter app là gì?  
→ `main.dart` - chứa hàm `main()` và `MyApp` widget.

**Câu 6:** Quy tắc đặt tên file trong Flutter?  
→ `snake_case.dart` (ví dụ: `home_screen.dart`).

**Câu 7:** Tại sao không nên viết tất cả code trong main.dart?  
→ Khó maintain, hot reload chậm, khó làm việc nhóm, code rối.

**Câu 8:** Sau khi sửa pubspec.yaml cần làm gì?  
→ Chạy `flutter pub get` để cài đặt dependencies/load assets mới.

**Câu 9:** Import file trong Flutter dùng cách nào?  
→ Dùng `package:` import: `import 'package:my_app/models/user.dart';`.

**Câu 10:** Cấu trúc thư mục lib/ chuẩn gồm những gì?  
→ screens/, widgets/, models/, services/, utils/, routes/.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **Dự án Flutter = lib/** là trung tâm, chứa toàn bộ source code.  
- **Không bao giờ** để mọi thứ trong main.dart - tách thành các file riêng.  
- **Tổ chức thư mục đúng** giúp học Flutter dễ gấp 3 lần, code dễ maintain.  
- **pubspec.yaml** = trái tim cấu hình dự án (dependencies, assets, metadata).  
- **Assets phải được khai báo** trong pubspec.yaml mới dùng được.  
- **Chia module**: screens – widgets – models – services – utils – routes.  
- **Đặt tên file**: snake_case.dart, class: PascalCase, variable: camelCase.  
- **Import**: Dùng package import thay vì relative import.  
- **Mỗi file 1 class**: Dễ tìm, dễ maintain, dễ test.  
- **Sau khi sửa pubspec.yaml**: Chạy `flutter pub get`.

---

# 🎉 Kết thúc chương 03  
Tiếp theo, bạn sẽ bắt đầu xây giao diện bằng các widget:

👉 **Chương 04 – Widget Cơ Bản (Stateless & Stateful + UI cơ bản)**

