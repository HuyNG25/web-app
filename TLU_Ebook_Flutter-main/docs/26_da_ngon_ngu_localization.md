# 🟦 CHƯƠNG 26
# **LOCALIZATION (ĐA NGÔN NGỮ)**
*(i18n – .arb files – Intl)*

Làm sao để app của bạn hiển thị tiếng Anh cho người Mỹ, tiếng Việt cho người Việt?
Đó là **Localization** (còn gọi là i18n).

Trong Flutter, cách chuẩn nhất là dùng file `.arb` (Application Resource Bundle).

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Cài đặt thư viện `flutter_localizations`.
- Tạo file ngôn ngữ `.arb` (en.arb, vi.arb).
- Tự động sinh code Dart từ file `.arb`.
- Chuyển đổi ngôn ngữ động trong App.

---

# 1. **Cài đặt**

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations: # Thư viện chính
    sdk: flutter
  intl: ^0.19.0 # Hỗ trợ format ngày tháng, số

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

Và bật tính năng sinh code trong `pubspec.yaml`:

```yaml
flutter:
  generate: true # Quan trọng!
```

Tạo file `l10n.yaml` ở thư mục gốc (nằm ngang hàng với `pubspec.yaml`):

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

---

# 2. **Tạo file ngôn ngữ (.arb)**

Tạo thư mục `lib/l10n`, sau đó tạo 2 file:

**`lib/l10n/app_en.arb`** (Tiếng Anh - Gốc):
```json
{
  "helloWorld": "Hello World!",
  "welcome": "Welcome {name}",
  "@welcome": {
    "description": "Welcome message with parameter",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

**`lib/l10n/app_vi.arb`** (Tiếng Việt):
```json
{
  "helloWorld": "Xin chào thế giới!",
  "welcome": "Chào mừng {name}"
}
```

Sau khi tạo xong, chạy lệnh:
`flutter gen-l10n` 
(Hoặc chỉ cần chạy `flutter run` là nó tự sinh ra).

---

# 3. **Cấu hình MaterialApp**

Mở `main.dart`:

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // File tự sinh ra

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localizations Sample App',
      // Cấu hình ngôn ngữ
      localizationsDelegates: [
        AppLocalizations.delegate, // Delegate của app mình
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('vi'), // Vietnamese
      ],
      home: const MyHomePage(),
    );
  }
}
```

---

# 4. **Sử dụng trong Code**

Cực kỳ đơn giản:

```dart
Text(AppLocalizations.of(context)!.helloWorld),
```

Hoặc với tham số:

```dart
Text(AppLocalizations.of(context)!.welcome("Tùng")),
// Kết quả: "Chào mừng Tùng" (nếu máy đang set tiếng Việt)
```

---

# 🧠 Chuyển đổi ngôn ngữ thủ công

Mặc định Flutter sẽ theo ngôn ngữ máy. Nếu muốn làm nút "Chuyển ngôn ngữ", bạn cần lưu `Locale` vào State của `MaterialApp`.

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('vi'); // Mặc định tiếng Việt

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale, // Set locale ở đây
      // ... các cấu hình khác
    );
  }
}
```

---

# 🧠 Tổng kết

- Dùng **`.arb`** file để quản lý text.
- Dùng **`AppLocalizations.of(context)!`** để lấy text ra.
- Flutter sẽ tự động chọn ngôn ngữ theo cài đặt máy nếu mình không `locale` cứng.
