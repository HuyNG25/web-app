# 🟦 THỰC HÀNH CHI TIẾT: PROVIDER STATE MANAGEMENT (BÀI 09)

Tài liệu này giúp bạn chuyển đổi tư duy từ `setState` (quản lý cục bộ) sang `Provider` (quản lý tập trung).
Đây là kỹ năng bắt buộc để làm các ứng dụng thực tế quy mô lớn.

> **⚠️ BẮT BUỘC:** Hãy gõ code theo từng bước.
> **💡 TƯ DUY:**
> - **State:** Dữ liệu (VD: điểm số, danh sách sản phẩm).
> - **Provider:** Cái kho chứa State và Logic.
> - **UI:** Chỉ việc lấy State từ kho ra hiện, và gọi hàm trong kho để xử lý.

---

## 🎯 MỤC TIÊU SẢN PHẨM
1.  **Level 1 (Dễ): Counter Provider** - *Chuyển đổi app đếm số sang mô hình Provider.*
2.  **Level 2 (Trung bình): Theme Switcher** - *Quản lý chế độ Sáng/Tối toàn app.*
3.  **Level 3 (Khó): Shopping Cart** - *Giỏ hàng, thêm/xóa sản phẩm, tính tổng tiền tự động.*
4.  **Level 4 (Rất khó): Multi-Provider Architecture** - *Kết hợp User và Cart, mô hình MVVM đơn giản.*

---

## 🛠️ CHUẨN BỊ
1.  Tạo dự án mới:
    ```bash
    flutter create thuc_hanh_provider
    cd thuc_hanh_provider
    ```
2.  **Cài đặt thư viện Provider:**
    Mở `pubspec.yaml`, thêm vào phần `dependencies`:
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      provider: ^6.0.0  # <--- Thêm dòng này
    ```
    Sau đó chạy lệnh: `flutter pub get`

3.  Setup `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import các file bài tập
// import 'bai1_counter.dart';
// import 'providers/counter_provider.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(body: Center(child: Text("SETUP XONG"))),
  ));
}
```

---

## 🟢 LEVEL 1: COUNTER PROVIDER (CẤU TRÚC CƠ BẢN)
**Mục tiêu:** Tách biệt logic ra khỏi UI.
**Tư duy:** Không còn `setState` trong UI nữa. Mọi biến đếm nằm trong một class riêng gọi là `CounterProvider`.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/providers/counter_provider.dart`.

```dart
import 'package:flutter/material.dart';

// 1. Class này kế thừa ChangeNotifier để có khả năng "báo tin"
class CounterProvider extends ChangeNotifier {
  int _count = 0; // State (dữ liệu)

  // Getter để bên ngoài đọc được dữ liệu (nhưng không sửa trực tiếp được)
  int get count => _count;

  void increment() {
    _count++;
    // 2. Quan trọng: Báo cho các Widget đang lắng nghe biết là "Dữ liệu đổi rồi nè!"
    notifyListeners(); 
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}
```

**Bước 2:** Tạo file `lib/bai1_counter.dart` (UI).

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/counter_provider.dart'; // Import Provider vừa tạo

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("UI Rebuild toàn bộ"); // Log để kiểm tra

    // 1. UI lắng nghe State (Dùng context.watch)
    // Mỗi khi notifyListeners() được gọi, biến 'count' sẽ có giá trị mới
    // và widget này sẽ tự động build lại.
    final count = context.watch<CounterProvider>().count;

    return Scaffold(
      appBar: AppBar(title: const Text("Counter với Provider")),
      body: Center(
        child: Text(
          "$count", 
          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 2. Gọi hàm logic (Dùng context.read)
          // read dùng để thực thi hành động, không lắng nghe thay đổi
          context.read<CounterProvider>().increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Bước 3:** Cấu hình `main.dart` để "tiêm" Provider vào ứng dụng.

```dart
// ... imports

void main() {
  runApp(
    // Bọc app trong ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => CounterProvider(), // Khởi tạo Provider
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CounterScreen(),
      ),
    ),
  );
}
```

> **🧠 Giải thích code:**
> - `ChangeNotifier`: Là cái loa phát thanh.
> - `notifyListeners()`: Là hành động nói vào loa.
> - `context.watch<T>()`: Là người nghe đài (UI tự cập nhật khi có tin mới).
> - `context.read<T>()`: Là người gửi yêu cầu (gọi hàm logic).

---

## 🟡 LEVEL 2: THEME SWITCHER (GLOBAL STATE)
**Mục tiêu:** Đổi màu nền toàn bộ ứng dụng (Sáng/Tối).
**Tư duy:** State này ảnh hưởng đến *nhiều* màn hình -> Cần đặt ở vị trí cao nhất.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo `lib/providers/theme_provider.dart`.

```dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;

  // Trả về ThemeData tương ứng để dùng trong MaterialApp
  ThemeData get currentTheme => _isDarkMode 
      ? ThemeData.dark(useMaterial3: true) 
      : ThemeData.light(useMaterial3: true);

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
```

**Bước 2:** Sửa `main.dart` để ứng dụng đổi màu theo Provider.

```dart
// ...
import 'providers/theme_provider.dart';
import 'bai2_theme_screen.dart'; // Sẽ tạo ở bước 3

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// Tách MyApp ra riêng để có thể dùng context.watch bên trong
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe theme thay đổi
    final themeProvider = context.watch<ThemeProvider>();
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme, // Theme thay đổi -> App đổi màu
      home: const ThemeScreen(),
    );
  }
}
```

**Bước 3:** Tạo `lib/bai2_theme_screen.dart`.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chế độ Sáng/Tối")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Hello World!", 
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Dùng Switch để bật tắt
            Switch(
              value: context.watch<ThemeProvider>().isDarkMode,
              onChanged: (value) {
                // Gọi hàm toggle
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
            const Text("Bật chế độ tối"),
          ],
        ),
      ),
    );
  }
}
```

---

## 🟠 LEVEL 3: SHOPPING CART (DANH SÁCH ĐỘNG)
**Mục tiêu:** Thêm sản phẩm vào giỏ, tính tổng tiền.
**Tư duy:** `CartProvider` sẽ giữ một List các món hàng. UI hiển thị List này và tổng tiền.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Định nghĩa Model sản phẩm (đơn giản).

```dart
class Product {
  final String name;
  final double price;
  Product(this.name, this.price);
}
```

**Bước 2:** Tạo `lib/providers/cart_provider.dart`.

```dart
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  // Getter trả về danh sách (nên trả về UnmodifiableListView để an toàn, nhưng ở đây ta dùng List thường cho dễ hiểu)
  List<Product> get items => _items;

  // Getter tính tổng tiền: Logic kinh doanh nằm ở Provider, không nằm ở UI!
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
```

**Bước 3:** UI Giỏ hàng `lib/bai3_shopping.dart`.
(Nhớ bọc ChangeNotifierProvider cho CartProvider ở main hoặc ở màn hình này).

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Nên dùng Consumer khi chỉ muốn rebuild một phần nhỏ
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng thông minh"),
        actions: [
          // Hiển thị số lượng item trên AppBar
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Badge(
                     label: Text("${cart.items.length}"),
                     child: const Icon(Icons.shopping_cart),
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // DANH SÁCH SẢN PHẨM MẪU (Bên ngoài giỏ hàng)
          Expanded(
            child: ListView(
              children: [
                _buildProductItem(context, Product("iPhone 15", 999)),
                _buildProductItem(context, Product("MacBook Pro", 2000)),
                _buildProductItem(context, Product("AirPods", 150)),
              ],
            ),
          ),
          
          const Divider(thickness: 2),
          
          // GIỎ HÀNG (Phần hiển thị tổng kết)
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                color: Colors.blue[50], // Thay đổi color theo trạng thái nếu muốn
                child: Column(
                  children: [
                    Text("Giỏ hàng của bạn: ${cart.items.length} món"),
                    Text(
                      "TỔNG TIỀN: \$${cart.totalPrice}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                         context.read<CartProvider>().clearCart();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      child: const Text("Xóa sạch giỏ hàng"),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text("\$${product.price}"),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle, color: Colors.blue),
        onPressed: () {
          // Thêm vào giỏ
          context.read<CartProvider>().addToCart(product);
        },
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `Consumer<T>`: Là cách viết khác của `context.watch<T>` nhưng tường minh hơn. Nó chỉ xây dựng lại phần Widget nằm trong hàm `builder` thôi, giúp tối ưu hiệu năng.
> - Logic tính tổng tiền (`totalPrice`): Được viết trong Provider -> UI cực kỳ sạch, chỉ việc hiển thị.

---

## 🔴 LEVEL 4: MULTI-PROVIDER (NÂNG CAO)
**Mục tiêu:** Ứng dụng thực tế thường có nhiều Provider (User, Cart, Setting...). Dùng `MultiProvider` để quản lý.

### 📝 Hướng dẫn:

Trong `main.dart`, thay vì bọc lồng nhau (`Provider` lồng `Provider`), ta dùng `MultiProvider`:

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // Thêm bao nhiêu cũng được...
      ],
      child: const MyApp(),
    ),
  );
}
```

Như vậy, bất kỳ màn hình nào trong `MyApp` cũng có thể gọi:
- `context.read<CounterProvider>()`
- `context.read<ThemeProvider>()`
- `context.read<CartProvider>()`

Thật quyền lực! 💪

---

## 🏆 TỔNG KẾT
Bạn đã nắm được vũ khí mạnh mẽ nhất của Flutter Developer:
- **Tách biệt UI và Logic**: UI chỉ để vẽ, Provider để tính toán.
- **Quản lý State toàn cục**: Theme, User, Cart có thể truy cập từ mọi nơi.
- **Tối ưu hiệu năng**: Chỉ rebuild những chỗ cần thiết với `Consumer` hoặc `Selector`.

Hãy luyện tập thật nhiều với Provider trước khi tìm hiểu BLoC nhé!