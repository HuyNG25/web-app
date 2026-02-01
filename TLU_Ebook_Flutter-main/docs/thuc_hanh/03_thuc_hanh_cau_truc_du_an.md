# 🟦 THỰC HÀNH CHƯƠNG 03: CẤU TRÚC DỰ ÁN FLUTTER & TỔ CHỨC FILE CHUẨN

> **📌 DÀNH CHO NGƯỜI MỚI BẮT ĐẦU**
> 
> Bài thực hành này giúp bạn tổ chức dự án Flutter theo chuẩn chuyên nghiệp.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Hiểu cấu trúc dự án Flutter
- ✅ Tổ chức file theo chuẩn (screens, widgets, models, services)
- ✅ Quản lý dependencies trong pubspec.yaml
- ✅ Thêm và sử dụng assets (ảnh, font)
- ✅ Import file đúng cách

---

## 📋 CHECKLIST CHUẨN BỊ

Trước khi bắt đầu, đảm bảo bạn có:
- [ ] Flutter SDK đã cài đặt
- [ ] VS Code hoặc Android Studio
- [ ] Kiến thức cơ bản về Dart

---

## BÀI TẬP 1: TẠO DỰ ÁN VÀ HIỂU CẤU TRÚC

### Mục đích
Tạo dự án mới và hiểu cấu trúc mặc định.

### Yêu cầu

1. **Tạo dự án mới:**
```bash
flutter create my_structured_app
cd my_structured_app
```

2. **Khám phá cấu trúc:**
Mở thư mục `my_structured_app` và xem các thư mục:
- `lib/` - Chứa source code
- `android/` - Cấu hình Android
- `ios/` - Cấu hình iOS
- `test/` - Test code
- `pubspec.yaml` - Quản lý dependencies

3. **Xem file main.dart:**
Mở `lib/main.dart` và đọc code mặc định.

### Kết quả mong đợi
- Hiểu được cấu trúc dự án Flutter
- Biết file nào quan trọng

---

## BÀI TẬP 2: TỔ CHỨC THƯ MỤC THEO CHUẨN

### Mục đích
Tổ chức lại thư mục `lib/` theo chuẩn chuyên nghiệp.

### Yêu cầu

1. **Tạo cấu trúc thư mục:**
Trong thư mục `lib/`, tạo các thư mục sau:
```
lib/
├── main.dart
├── screens/
├── widgets/
├── models/
├── services/
├── utils/
└── routes/
```

**Cách tạo (Windows PowerShell):**
```powershell
cd lib
mkdir screens, widgets, models, services, utils, routes
```

**Cách tạo (macOS/Linux):**
```bash
cd lib
mkdir -p screens widgets models services utils routes
```

2. **Tạo file mẫu trong mỗi thư mục:**

**lib/screens/home_screen.dart:**
```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
```

**lib/widgets/app_button.dart:**
```dart
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  AppButton({
    required this.text,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
```

**lib/models/user.dart:**
```dart
class User {
  final String id;
  final String name;
  final int age;
  
  User({
    required this.id,
    required this.name,
    required this.age,
  });
}
```

**lib/services/api_service.dart:**
```dart
class ApiService {
  static String baseUrl = 'https://api.example.com';
  
  static Future<void> fetchData() async {
    // API call logic
  }
}
```

**lib/utils/constants.dart:**
```dart
class AppConstants {
  static const String appName = 'My App';
  static const String apiUrl = 'https://api.example.com';
}
```

**lib/utils/app_colors.dart:**
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.blue;
  static const Color secondary = Colors.green;
  static const Color error = Colors.red;
}
```

3. **Cập nhật main.dart:**
```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Structured App',
      home: HomeScreen(),
    );
  }
}
```

### Kết quả mong đợi
- Cấu trúc thư mục rõ ràng, chuyên nghiệp
- Mỗi file có nhiệm vụ riêng

---

## BÀI TẬP 3: QUẢN LÝ DEPENDENCIES

### Mục đích
Thêm và quản lý dependencies trong pubspec.yaml.

### Yêu cầu

1. **Mở pubspec.yaml:**
Tìm file `pubspec.yaml` trong thư mục gốc.

2. **Thêm dependencies:**
Sửa phần `dependencies`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  provider: ^6.0.0
  intl: ^0.19.0
```

3. **Thêm dev_dependencies:**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

4. **Cài đặt dependencies:**
```bash
flutter pub get
```

5. **Kiểm tra:**
Xem thư mục `.dart_tool/package_config.json` để xác nhận packages đã được cài.

### Kết quả mong đợi
- Thêm được dependencies vào pubspec.yaml
- Cài đặt thành công bằng flutter pub get

---

## BÀI TẬP 4: THÊM VÀ SỬ DỤNG ASSETS

### Mục đích
Thêm ảnh và sử dụng trong app.

### Yêu cầu

1. **Tạo thư mục assets:**
Trong thư mục gốc, tạo:
```
assets/
├── images/
└── icons/
```

2. **Thêm ảnh mẫu:**
- Tải một ảnh bất kỳ (ví dụ: logo.png)
- Đặt vào `assets/images/logo.png`

3. **Khai báo trong pubspec.yaml:**
```yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
```

4. **Cài đặt lại:**
```bash
flutter pub get
```

5. **Sử dụng trong code:**
Tạo file `lib/screens/assets_demo_screen.dart`:
```dart
import 'package:flutter/material.dart';

class AssetsDemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assets Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sử dụng ảnh từ assets
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text('Ảnh từ assets'),
          ],
        ),
      ),
    );
  }
}
```

### Kết quả mong đợi
- Thêm được assets vào pubspec.yaml
- Sử dụng được ảnh trong app

---

## BÀI TẬP 5: IMPORT FILE ĐÚNG CÁCH

### Mục đích
Hiểu cách import file trong Flutter.

### Yêu cầu

1. **Tạo các file:**
- `lib/models/product.dart`
- `lib/services/product_service.dart`
- `lib/screens/product_screen.dart`

2. **Code mẫu:**

**lib/models/product.dart:**
```dart
class Product {
  final String id;
  final String name;
  final double price;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}
```

**lib/services/product_service.dart:**
```dart
import '../models/product.dart';

class ProductService {
  static List<Product> getProducts() {
    return [
      Product(id: '1', name: 'Laptop', price: 1000),
      Product(id: '2', name: 'Phone', price: 500),
    ];
  }
}
```

**lib/screens/product_screen.dart:**
```dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = ProductService.getProducts();
    
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
          );
        },
      ),
    );
  }
}
```

### Kết quả mong đợi
- Import file đúng cách
- Sử dụng được class từ file khác

---

## BÀI TẬP 6: XÂY DỰNG ỨNG DỤNG HOÀN CHỈNH

### Mục đích
Áp dụng tất cả kiến thức vào một ứng dụng thực tế.

### Yêu cầu

Xây dựng ứng dụng **Product Manager** với cấu trúc:

```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   └── product_list_screen.dart
├── widgets/
│   └── product_card.dart
├── models/
│   └── product.dart
├── services/
│   └── product_service.dart
└── utils/
    ├── constants.dart
    └── app_colors.dart
```

### Code mẫu

**lib/main.dart:**
```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
```

**lib/models/product.dart:**
```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String? description;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });
}
```

**lib/services/product_service.dart:**
```dart
import '../models/product.dart';

class ProductService {
  static List<Product> _products = [
    Product(
      id: '1',
      name: 'Laptop',
      price: 1000,
      description: 'High performance laptop',
    ),
    Product(
      id: '2',
      name: 'Phone',
      price: 500,
      description: 'Smartphone',
    ),
  ];
  
  static List<Product> getAllProducts() {
    return _products;
  }
  
  static void addProduct(Product product) {
    _products.add(product);
  }
}
```

**lib/widgets/product_card.dart:**
```dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  
  ProductCard({required this.product});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(Icons.shopping_bag),
        title: Text(product.name),
        subtitle: Text(product.description ?? ''),
        trailing: Text(
          '\$${product.price}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
```

**lib/screens/home_screen.dart:**
```dart
import 'package:flutter/material.dart';
import '../screens/product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Manager')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListScreen(),
              ),
            );
          },
          child: Text('Xem danh sách sản phẩm'),
        ),
      ),
    );
  }
}
```

**lib/screens/product_list_screen.dart:**
```dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = ProductService.getAllProducts();
    
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách sản phẩm')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}
```

### Kết quả mong đợi
- Ứng dụng hoàn chỉnh với cấu trúc rõ ràng
- Mỗi file có nhiệm vụ riêng
- Dễ maintain và mở rộng

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành tất cả bài tập, bạn nên:
- [ ] Hiểu cấu trúc dự án Flutter
- [ ] Tổ chức file theo chuẩn (screens, widgets, models, services)
- [ ] Quản lý dependencies trong pubspec.yaml
- [ ] Thêm và sử dụng assets
- [ ] Import file đúng cách
- [ ] Xây dựng được ứng dụng với cấu trúc rõ ràng

---

## 🎉 KẾT THÚC

Chúc mừng! Bạn đã hoàn thành bài thực hành Cấu trúc dự án Flutter.

👉 **Tiếp theo:** Bài 04-05 - Widget & Layout
