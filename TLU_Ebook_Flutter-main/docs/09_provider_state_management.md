# 🟦 CHƯƠNG 09  
# **STATE MANAGEMENT NÂNG CAO VỚI PROVIDER**  
*(ChangeNotifier – Provider – Consumer – MultiProvider – Tổ chức kiến trúc)*

Khi ứng dụng lớn dần, `setState()` trở nên rối:

- state nằm lung tung  
- truyền xuống quá nhiều widget con  
- khó bảo trì  
- màn hình rebuild quá nhiều  

Đây là lúc **Provider** tỏa sáng.  
Provider là state management đơn giản nhất, gọn nhất và được chính Google khuyến nghị.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn có thể:

- Hiểu Provider là gì và tại sao cần dùng.  
- Tạo ChangeNotifier để quản lý state.  
- Sử dụng Provider, Consumer, context.watch(), context.read().  
- Áp dụng MultiProvider cho dự án lớn.  
- Chia kiến trúc Model → Provider → UI.  
- Xây một mini app với Provider.

---

# 1. **Provider là gì?**

Provider là "bình chứa state + logic" đặt ở trên cao (root) để mọi widget bên dưới có thể:

- đọc state  
- lắng nghe thay đổi  
- cập nhật UI  

Provider giúp loại bỏ việc truyền state lòng vòng giữa các widget.

---

### 🧠 Giảng giải chi tiết: Tại sao cần Provider?

**Vấn đề với setState() khi app lớn:**

```dart
// ❌ VẤN ĐỀ: State phải truyền qua nhiều widget
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen(user: user, cart: cart, theme: theme);
    // Phải truyền state xuống
  }
}

class HomeScreen extends StatelessWidget {
  final User user;
  final Cart cart;
  final Theme theme;
  
  @override
  Widget build(BuildContext context) {
    return ProductListScreen(user: user, cart: cart);
    // Phải truyền tiếp xuống
  }
}

class ProductListScreen extends StatelessWidget {
  final User user;
  final Cart cart;
  
  @override
  Widget build(BuildContext context) {
    return ProductCard(user: user, cart: cart);
    // Phải truyền tiếp xuống
  }
}

// ❌ Vấn đề:
// - Phải truyền state qua nhiều widget
// - Code rối, khó maintain
// - Nếu thêm state mới → phải sửa nhiều nơi
```

**Giải pháp với Provider:**

```dart
// ✅ ĐÚNG: Provider ở root, mọi widget đều truy cập được
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ Không cần truyền state qua constructor
    return ProductListScreen();
  }
}

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ Lấy state trực tiếp từ Provider
    final cart = context.watch<CartProvider>();
    final user = context.watch<UserProvider>();
    
    return ProductCard();  // Không cần truyền gì!
  }
}

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ Lấy state trực tiếp từ Provider
    final cart = context.watch<CartProvider>();
    
    return ElevatedButton(
      onPressed: () {
        context.read<CartProvider>().addItem(product);
      },
    );
  }
}
```

**So sánh trực quan:**

```
❌ KHÔNG DÙNG PROVIDER (setState):
App (có state)
  ↓ truyền state
HomeScreen (nhận state)
  ↓ truyền state
ProductListScreen (nhận state)
  ↓ truyền state
ProductCard (nhận state)
  ↓ truyền callback
ProductCard (gọi callback)
  ↑ callback
ProductListScreen (gọi callback)
  ↑ callback
HomeScreen (gọi callback)
  ↑ callback
App (setState)
  ↓ rebuild toàn bộ

✅ DÙNG PROVIDER:
Provider (có state) ← ở root
  ↓
Mọi widget đều truy cập trực tiếp
  - HomeScreen → context.watch<CartProvider>()
  - ProductListScreen → context.watch<CartProvider>()
  - ProductCard → context.read<CartProvider>().addItem()
  
→ Không cần truyền state qua constructor!
→ Chỉ rebuild widget nào cần!
```

**Lợi ích của Provider:**

1. ✅ **Không cần truyền state** qua nhiều widget
2. ✅ **Single source of truth** - State ở 1 nơi
3. ✅ **Dễ maintain** - Sửa ở Provider, tất cả cập nhật
4. ✅ **Performance tốt** - Chỉ rebuild widget cần thiết
5. ✅ **Code sạch** - UI tách biệt với logic

---

### 🎒 Ví dụ đời sống  
Provider giống **loa phát thanh của khu dân cư**:

- thông báo được phát 1 lần ở trạm loa  
- mọi nhà đều nghe được  
- không ai phải truyền miệng vòng vòng nữa

**Giải thích chi tiết:**

```
Loa phát thanh (Provider)
├── Phát thông báo 1 lần (notifyListeners)
├── Mọi nhà đều nghe được (context.watch)
└── Không cần truyền miệng (không cần truyền state)

Tương tự:
Provider (ở root)
├── notifyListeners() khi state đổi
├── Mọi widget đều truy cập được (context.watch/read)
└── Không cần truyền state qua constructor
```  

---

# 2. **Cài đặt Provider**

Thêm vào pubspec.yaml:

```yaml
dependencies:
  provider: ^6.0.0
```

---

# 3. **ChangeNotifier – nơi giữ state và logic**

Tạo file:

```
lib/providers/counter_provider.dart
```

```dart
import 'package:flutter/foundation.dart';

class CounterProvider extends ChangeNotifier {
  int count = 0;

  void increase() {
    count++;
    notifyListeners();
  }

  void decrease() {
    count--;
    notifyListeners();
  }
}
```

### Giải thích:

- `count` là state  
- `increase()` thay đổi state  
- `notifyListeners()` báo UI rebuild

---

### 🧠 Giảng giải chi tiết về ChangeNotifier

**ChangeNotifier là gì?**

- Class từ Flutter SDK cho phép **lắng nghe thay đổi**
- Khi gọi `notifyListeners()`, tất cả listeners được thông báo
- Provider sử dụng ChangeNotifier để quản lý state

**Cơ chế hoạt động:**

```
ChangeNotifier
├── addListener() - Đăng ký lắng nghe
├── removeListener() - Hủy đăng ký
└── notifyListeners() - Thông báo tất cả listeners

Flow:
1. Widget đăng ký listener (qua context.watch)
2. Provider thay đổi state
3. notifyListeners() được gọi
4. Tất cả listeners được thông báo
5. Widget rebuild với state mới
```

**Ví dụ minh họa từng bước:**

```dart
// BƯỚC 1: Tạo Provider kế thừa ChangeNotifier
class CounterProvider extends ChangeNotifier {
  // BƯỚC 2: Định nghĩa state
  int count = 0;  // ← State
  
  // BƯỚC 3: Method thay đổi state
  void increase() {
    count++;  // ← Thay đổi state
    notifyListeners();  // ← Báo tất cả listeners: "State đã đổi!"
  }
  
  void decrease() {
    count--;  // ← Thay đổi state
    notifyListeners();  // ← Báo tất cả listeners: "State đã đổi!"
  }
}
```

**So sánh với setState():**

```dart
// ❌ setState() - State trong widget
class _CounterState extends State<Counter> {
  int count = 0;  // ← State trong widget
  
  void increase() {
    setState(() {
      count++;  // ← Chỉ rebuild widget này
    });
  }
}

// ✅ Provider - State trong Provider
class CounterProvider extends ChangeNotifier {
  int count = 0;  // ← State trong Provider
  
  void increase() {
    count++;
    notifyListeners();  // ← Rebuild TẤT CẢ widget đang lắng nghe
  }
}
```

**Lợi ích của ChangeNotifier:**

1. ✅ **State tách biệt** khỏi UI
2. ✅ **Nhiều widget** có thể lắng nghe cùng 1 state
3. ✅ **Logic tập trung** ở 1 nơi
4. ✅ **Dễ test** - Test logic riêng, không cần UI

**Ví dụ minh họa: Provider với nhiều state**

```dart
class UserProvider extends ChangeNotifier {
  // State
  String? _name;
  String? _email;
  bool _isLoggedIn = false;
  
  // Getters
  String? get name => _name;
  String? get email => _email;
  bool get isLoggedIn => _isLoggedIn;
  
  // Methods
  void login(String name, String email) {
    _name = name;
    _email = email;
    _isLoggedIn = true;
    notifyListeners();  // ← Báo UI: "Đã đăng nhập!"
  }
  
  void logout() {
    _name = null;
    _email = null;
    _isLoggedIn = false;
    notifyListeners();  // ← Báo UI: "Đã đăng xuất!"
  }
  
  void updateName(String newName) {
    _name = newName;
    notifyListeners();  // ← Báo UI: "Tên đã đổi!"
  }
}
```

**Flow minh họa:**

```
User nhấn nút "Đăng nhập"
    ↓
login("John", "john@email.com") được gọi
    ↓
_name = "John", _email = "john@email.com", _isLoggedIn = true
    ↓
notifyListeners() được gọi
    ↓
Tất cả widget đang lắng nghe (context.watch) được thông báo
    ↓
Widget rebuild với state mới
    ↓
UI cập nhật: Hiển thị "Xin chào John" thay vì "Đăng nhập"
```  

---

# 4. **Khởi tạo Provider trong ứng dụng**

Trong `main.dart`:

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: const MyApp(),
    ),
  );
}
```

Từ giờ, mọi widget trong MyApp đều truy cập được CounterProvider.

---

# 5. **Đọc state từ Provider**

## Cách 1 — context.watch<T>()  
UI tự rebuild khi giá trị thay đổi.

```dart
final count = context.watch<CounterProvider>().count;
```

---

### 🧠 Giảng giải chi tiết: context.watch()

**context.watch() là gì?**

- Đăng ký **lắng nghe** Provider
- Widget sẽ **rebuild** khi Provider thay đổi
- Dùng khi **cần hiển thị** state trong UI

**Cơ chế hoạt động:**

```
context.watch<CounterProvider>()
    ↓
Widget đăng ký listener với Provider
    ↓
Provider thay đổi → notifyListeners()
    ↓
Widget được thông báo
    ↓
Widget rebuild với state mới
```

**Ví dụ minh họa:**

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ ĐÚNG: watch() để lắng nghe và hiển thị
    final count = context.watch<CounterProvider>().count;
    // ↑ Widget này sẽ rebuild khi count thay đổi
    
    return Text("Count: $count");
  }
}

// Flow:
// 1. Widget build() → watch() đăng ký listener
// 2. User nhấn nút → Provider.increase() → notifyListeners()
// 3. Widget được thông báo → build() được gọi lại
// 4. Text("Count: $count") hiển thị giá trị mới
```

**Lưu ý quan trọng:**

- `watch()` chỉ dùng trong `build()` method
- Widget sẽ rebuild mỗi khi Provider thay đổi
- Không dùng `watch()` trong `onPressed` (dùng `read()`)

---

## Cách 2 — context.read<T>()  
Chỉ gọi hành động, **không rebuild**.

```dart
context.read<CounterProvider>().increase();
```

→ Dùng trong onPressed là tốt nhất.

---

### 🧠 Giảng giải chi tiết: context.read()

**context.read() là gì?**

- **Chỉ đọc** Provider, **KHÔNG đăng ký** listener
- **KHÔNG rebuild** widget khi Provider thay đổi
- Dùng khi **chỉ cần gọi method**, không cần hiển thị state

**Cơ chế hoạt động:**

```
context.read<CounterProvider>()
    ↓
Lấy Provider instance
    ↓
Gọi method (increase, decrease...)
    ↓
KHÔNG đăng ký listener
    ↓
Widget KHÔNG rebuild
```

**Ví dụ minh họa:**

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // ✅ ĐÚNG: read() để gọi action, không rebuild
        context.read<CounterProvider>().increase();
        // ↑ Widget này KHÔNG rebuild
        // ↑ Chỉ gọi method increase()
      },
      child: Text("Tăng"),
    );
  }
}

// Flow:
// 1. User nhấn nút
// 2. read() lấy Provider → gọi increase()
// 3. Provider.increase() → notifyListeners()
// 4. Widget KHÁC đang watch() sẽ rebuild
// 5. Widget này (dùng read()) KHÔNG rebuild
```

**So sánh watch() vs read():**

```dart
class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ watch() - Để hiển thị (sẽ rebuild)
    final count = context.watch<CounterProvider>().count;
    
    return Column(
      children: [
        Text("Count: $count"),  // ← Hiển thị state
        ElevatedButton(
          onPressed: () {
            // ✅ read() - Để gọi action (không rebuild)
            context.read<CounterProvider>().increase();
          },
          child: Text("Tăng"),
        ),
      ],
    );
  }
}
```

**Khi nào dùng watch() vs read()?**

| Tình huống | Dùng gì? | Ví dụ |
|-----------|---------|-------|
| Hiển thị state trong UI | `watch()` | `final count = context.watch<CounterProvider>().count;` |
| Gọi method trong onPressed | `read()` | `context.read<CounterProvider>().increase();` |
| Gọi method trong initState | `read()` | `context.read<CounterProvider>().loadData();` |
| Conditional rendering | `watch()` | `if (context.watch<UserProvider>().isLoggedIn) ...` |

---

## Cách 3 — Consumer<T>()  
Chỉ rebuild đúng widget chứa Consumer.

```dart
Consumer<CounterProvider>(
  builder: (context, provider, child) {
    return Text("Count: ${provider.count}");
  },
)
```

---

### 🧠 Giảng giải chi tiết: Consumer

**Consumer là gì?**

- Widget đặc biệt chỉ rebuild **phần bên trong**
- Tối ưu performance - không rebuild widget cha
- Dùng khi muốn **giới hạn phạm vi rebuild**

**Cơ chế hoạt động:**

```
Consumer<CounterProvider>
├── Chỉ rebuild phần bên trong builder
├── Widget cha KHÔNG rebuild
└── child parameter không rebuild (nếu dùng)
```

**Ví dụ minh họa:**

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Widget này KHÔNG rebuild khi Provider thay đổi
    return Scaffold(
      appBar: AppBar(title: Text("Counter")),  // ← Không rebuild
      body: Center(
        child: Consumer<CounterProvider>(
          // ✅ Chỉ phần này rebuild
          builder: (context, provider, child) {
            return Text("Count: ${provider.count}");  // ← Chỉ rebuild Text này
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterProvider>().increase();
        },
      ),  // ← Không rebuild
    );
  }
}
```

**Consumer với child parameter (tối ưu hơn):**

```dart
Consumer<CounterProvider>(
  builder: (context, provider, child) {
    // provider.count thay đổi → chỉ rebuild Text
    return Column(
      children: [
        Text("Count: ${provider.count}"),  // ← Rebuild
        child!,  // ← KHÔNG rebuild (tối ưu!)
      ],
    );
  },
  child: ExpensiveWidget(),  // ← Widget này KHÔNG rebuild
)
```

**So sánh 3 cách:**

```dart
// Cách 1: context.watch() - Rebuild toàn bộ widget
class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterProvider>().count;
    // ↑ Toàn bộ Screen1 sẽ rebuild
    
    return Scaffold(
      appBar: AppBar(),  // ← Rebuild
      body: Text("Count: $count"),  // ← Rebuild
    );
  }
}

// Cách 2: Consumer - Chỉ rebuild phần bên trong
class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Screen2 KHÔNG rebuild
    return Scaffold(
      appBar: AppBar(),  // ← Không rebuild
      body: Consumer<CounterProvider>(
        builder: (context, provider, child) {
          return Text("Count: ${provider.count}");  // ← Chỉ rebuild Text
        },
      ),
    );
  }
}

// Cách 3: context.read() - Không rebuild
class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Screen3 KHÔNG rebuild
    return ElevatedButton(
      onPressed: () {
        context.read<CounterProvider>().increase();  // ← Chỉ gọi method
      },
    );
  }
}
```

**Bảng so sánh:**

| Cách | Rebuild? | Khi nào dùng? |
|------|----------|---------------|
| `context.watch()` | ✅ Có (toàn bộ widget) | Hiển thị state trong UI |
| `context.read()` | ❌ Không | Gọi method trong onPressed |
| `Consumer` | ✅ Có (chỉ phần bên trong) | Tối ưu performance |

---

# 6. **Ví dụ hoàn chỉnh: Counter App bằng Provider**

### HomeScreen

```dart
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterProvider>().count;

    return Scaffold(
      appBar: AppBar(title: const Text("Counter Provider")),
      body: Center(
        child: Text(
          "Count: $count",
          style: const TextStyle(fontSize: 32),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterProvider>().increase(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () => context.read<CounterProvider>().decrease(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

---

### 🧠 Giảng giải từng bước: Counter App hoạt động như thế nào?

**Bước 1: Setup Provider**

```dart
// main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),  // ← Tạo Provider instance
      child: MyApp(),  // ← Tất cả widget trong MyApp đều truy cập được
    ),
  );
}
```

**Bước 2: Provider được tạo**

```dart
// providers/counter_provider.dart
class CounterProvider extends ChangeNotifier {
  int count = 0;  // ← State = 0
  
  void increase() {
    count++;  // count: 0 → 1
    notifyListeners();  // ← Báo tất cả listeners
  }
}
```

**Bước 3: Widget đăng ký listener**

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ watch() đăng ký listener
    final count = context.watch<CounterProvider>().count;
    // ↑ Widget này đã đăng ký lắng nghe CounterProvider
    
    return Text("Count: $count");  // Hiển thị: "Count: 0"
  }
}
```

**Bước 4: User nhấn nút "+"**

```dart
FloatingActionButton(
  onPressed: () {
    // ✅ read() gọi method, không rebuild
    context.read<CounterProvider>().increase();
    // ↑ Gọi increase() → count = 1 → notifyListeners()
  },
)
```

**Bước 5: Provider thông báo listeners**

```
Provider.increase() được gọi
    ↓
count++ → count = 1
    ↓
notifyListeners() được gọi
    ↓
Tất cả listeners được thông báo
    ↓
Widget đang watch() được rebuild
    ↓
Text("Count: $count") hiển thị "Count: 1" ✅
```

**Flow minh họa đầy đủ:**

```
[INITIAL STATE]
Provider: count = 0
UI: "Count: 0"

[USER ACTION]
User nhấn nút "+"
    ↓
[PROVIDER]
context.read<CounterProvider>().increase()
    ↓
count++ → count = 1
notifyListeners()
    ↓
[UI UPDATE]
Widget đang watch() được thông báo
build() được gọi lại
context.watch<CounterProvider>().count → 1
    ↓
[RESULT]
UI: "Count: 1" ✅
```

**Ví dụ minh họa với debug:**

```dart
class DebugCounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("🔵 build() được gọi");
    
    final count = context.watch<CounterProvider>().count;
    print("🟢 count = $count");
    
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Count: $count"),
            ElevatedButton(
              onPressed: () {
                print("👆 User nhấn nút");
                context.read<CounterProvider>().increase();
                print("📢 notifyListeners() đã được gọi");
                print("📱 build() SẼ được gọi lại!");
              },
              child: Text("Tăng"),
            ),
          ],
        ),
      ),
    );
  }
}

// Kết quả console:
/*
🔵 build() được gọi
🟢 count = 0
👆 User nhấn nút
📢 notifyListeners() đã được gọi
📱 build() SẼ được gọi lại!
🔵 build() được gọi
🟢 count = 1
*/
```

---

# 7. Sử dụng MultiProvider – nhiều provider trong ứng dụng lớn

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => CounterProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ],
  child: const MyApp(),
);
```

---

### 🧠 Giảng giải chi tiết: MultiProvider

**MultiProvider là gì?**

- Widget cho phép đăng ký **nhiều Provider** cùng lúc
- Tất cả Provider đều có thể truy cập từ mọi widget bên dưới
- Dùng cho ứng dụng lớn có nhiều state cần quản lý

**Cấu trúc:**

```
MultiProvider
├── Provider 1 (CounterProvider)
├── Provider 2 (UserProvider)
├── Provider 3 (CartProvider)
└── Provider 4 (ThemeProvider)
    ↓
MyApp
└── Tất cả widget đều truy cập được tất cả Provider
```

**Ví dụ minh họa đầy đủ:**

```dart
// main.dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        // ✅ Đăng ký nhiều Provider
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

// screens/home_screen.dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ Có thể truy cập nhiều Provider
    final counter = context.watch<CounterProvider>();
    final user = context.watch<UserProvider>();
    final cart = context.watch<CartProvider>();
    final theme = context.watch<ThemeProvider>();
    
    return Scaffold(
      body: Column(
        children: [
          Text("Counter: ${counter.count}"),
          Text("User: ${user.name ?? 'Chưa đăng nhập'}"),
          Text("Cart: ${cart.count} items"),
          Text("Theme: ${theme.isDarkMode ? 'Dark' : 'Light'}"),
        ],
      ),
    );
  }
}
```

**Lưu ý quan trọng:**

- Thứ tự Provider không quan trọng
- Mỗi Provider là độc lập
- Widget có thể watch nhiều Provider cùng lúc

---

# 8. **Quy tắc vàng khi dùng Provider**

1. **State đặt ở Provider**, không đặt ở UI.  
2. UI chỉ hiển thị và gọi action (`increase()`, `addToCart()`).  
3. Không thay đổi state bên ngoài Provider.  
4. Không dùng watch trong build nếu không cần.  
5. Consumer dùng khi muốn tối ưu hiệu năng.

---

### 🧠 Giảng giải chi tiết: Best Practices

**1. State đặt ở Provider, không đặt ở UI**

```dart
// ❌ SAI: State ở UI
class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int count = 0;  // ← State ở UI (SAI!)
  
  void increase() {
    setState(() => count++);
  }
}

// ✅ ĐÚNG: State ở Provider
class CounterProvider extends ChangeNotifier {
  int count = 0;  // ← State ở Provider (ĐÚNG!)
  
  void increase() {
    count++;
    notifyListeners();
  }
}
```

**2. UI chỉ hiển thị và gọi action**

```dart
// ✅ ĐÚNG: UI chỉ hiển thị và gọi method
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterProvider>().count;  // Hiển thị
    
    return Column(
      children: [
        Text("Count: $count"),  // ← Hiển thị
        ElevatedButton(
          onPressed: () {
            context.read<CounterProvider>().increase();  // ← Gọi action
          },
        ),
      ],
    );
  }
}
```

**3. Không thay đổi state bên ngoài Provider**

```dart
// ❌ SAI: Thay đổi state trực tiếp
final provider = context.watch<CounterProvider>();
provider.count++;  // ← SAI! Phải dùng method

// ✅ ĐÚNG: Dùng method của Provider
context.read<CounterProvider>().increase();  // ← ĐÚNG!
```

**4. Không dùng watch nếu không cần**

```dart
// ❌ SAI: watch() nhưng không dùng
@override
Widget build(BuildContext context) {
  final provider = context.watch<CounterProvider>();  // ← watch() không cần thiết
  
  return ElevatedButton(
    onPressed: () {
      provider.increase();  // ← Chỉ cần read()
    },
  );
}

// ✅ ĐÚNG: Dùng read() nếu không cần hiển thị
@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      context.read<CounterProvider>().increase();  // ← ĐÚNG!
    },
  );
}
```

**5. Consumer để tối ưu performance**

```dart
// ❌ SAI: watch() rebuild toàn bộ widget
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterProvider>().count;
    // ← Toàn bộ CounterScreen rebuild
    
    return Scaffold(
      appBar: AppBar(),  // ← Rebuild không cần thiết
      body: Text("Count: $count"),  // ← Chỉ cần rebuild Text
    );
  }
}

// ✅ ĐÚNG: Consumer chỉ rebuild phần cần
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),  // ← Không rebuild
      body: Consumer<CounterProvider>(
        builder: (context, provider, child) {
          return Text("Count: ${provider.count}");  // ← Chỉ rebuild Text
        },
      ),
    );
  }
}
```

---

# 9. **Sai vs Đúng (sinh viên rất hay gặp)**

## ❌ Sai: gọi notifyListeners() trong build()

```dart
build() {
  provider.notifyListeners();  // Đây là tội ác lập trình
}
```

→ vòng lặp vô hạn.

---

### 🔍 Giảng giải chi tiết: Tại sao gọi notifyListeners() trong build() gây vòng lặp?

**Ví dụ minh họa lỗi:**

```dart
class WrongScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounterProvider>();
    
    // ❌ SAI: Gọi notifyListeners() trong build()
    provider.notifyListeners();  // ← TỘI ÁC!
    
    return Text("Count: ${provider.count}");
  }
}
```

**Flow gây vòng lặp:**

```
Bước 1: build() được gọi
    ↓
Bước 2: context.watch() đăng ký listener
    ↓
Bước 3: notifyListeners() được gọi
    ↓
Bước 4: Tất cả listeners được thông báo
    ↓
Bước 5: Widget rebuild → build() được gọi lại
    ↓
Bước 6: Lặp lại từ bước 2 → VÒNG LẶP VÔ HẠN! 🔥
```

**Kết quả:**
- App bị đơ
- CPU 100%
- Có thể crash

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Chỉ gọi notifyListeners() trong method của Provider
class CounterProvider extends ChangeNotifier {
  int count = 0;
  
  void increase() {
    count++;
    notifyListeners();  // ← ĐÚNG: Gọi trong method
  }
}

// UI chỉ gọi method
context.read<CounterProvider>().increase();
```

---

## ✔ Đúng:
Chỉ gọi trong hàm xử lý (increase, decrease,…)

---

## ❌ Sai: dùng watch trong onPressed

```dart
onPressed: () => context.watch<CounterProvider>().increase(),
```

---

### 🔍 Giảng giải chi tiết: Tại sao không dùng watch() trong onPressed?

**Ví dụ minh họa lỗi:**

```dart
ElevatedButton(
  onPressed: () {
    // ❌ SAI: watch() trong onPressed
    context.watch<CounterProvider>().increase();
    // ↑ Vấn đề:
    // 1. watch() đăng ký listener mỗi lần onPressed được gọi
    // 2. Tạo nhiều listeners không cần thiết
    // 3. Performance kém
  },
)
```

**Vấn đề:**

```
User nhấn nút lần 1:
    ↓
watch() đăng ký listener 1
    ↓
User nhấn nút lần 2:
    ↓
watch() đăng ký listener 2 (trùng!)
    ↓
User nhấn nút lần 3:
    ↓
watch() đăng ký listener 3 (trùng!)
    ↓
→ Nhiều listeners trùng lặp → Memory leak!
```

**✅ Giải pháp:**

```dart
ElevatedButton(
  onPressed: () {
    // ✅ ĐÚNG: read() trong onPressed
    context.read<CounterProvider>().increase();
    // ↑ Chỉ gọi method, không đăng ký listener
  },
)
```

**So sánh:**

| Cách | Đăng ký listener? | Khi nào dùng? |
|------|-------------------|---------------|
| `watch()` trong build() | ✅ Có (1 lần) | Hiển thị state |
| `watch()` trong onPressed | ❌ Có (nhiều lần - SAI!) | KHÔNG BAO GIỜ |
| `read()` trong onPressed | ❌ Không | Gọi method |

---

## ✔ Đúng:

```dart
onPressed: () => context.read<CounterProvider>().increase(),
```

---

## ❌ Sai: truyền state thủ công giữa widget con  
→ rối, trùng lặp, khó bảo trì

---

### 🔍 Giảng giải chi tiết: Vấn đề truyền state thủ công

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Truyền state qua nhiều widget
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Cart();  // State ở đây
    
    return HomeScreen(cart: cart);  // Truyền xuống
  }
}

class HomeScreen extends StatelessWidget {
  final Cart cart;
  
  @override
  Widget build(BuildContext context) {
    return ProductListScreen(cart: cart);  // Truyền tiếp
  }
}

class ProductListScreen extends StatelessWidget {
  final Cart cart;
  
  @override
  Widget build(BuildContext context) {
    return ProductCard(cart: cart);  // Truyền tiếp
  }
}

class ProductCard extends StatelessWidget {
  final Cart cart;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        cart.addItem(product);  // Cuối cùng mới dùng được
      },
    );
  }
}
```

**Vấn đề:**
- Phải truyền state qua 4 widget
- Nếu thêm state mới → phải sửa 4 nơi
- Code rối, khó maintain

**✅ Giải pháp với Provider:**

```dart
// ✅ ĐÚNG: Provider ở root, mọi widget đều truy cập
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductListScreen();  // Không cần truyền gì!
  }
}

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductCard();  // Không cần truyền gì!
  }
}

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // ✅ Lấy trực tiếp từ Provider
        context.read<CartProvider>().addItem(product);
      },
    );
  }
}
```

---

## ✔ Đúng: để Provider quản lý

---

## ❌ Sai: đặt quá nhiều state trong 1 provider  
→ class phình to

---

### 🔍 Giảng giải chi tiết: Vấn đề Provider quá lớn

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Tất cả state trong 1 Provider
class AppProvider extends ChangeNotifier {
  // User state
  String? userName;
  String? userEmail;
  bool isLoggedIn;
  
  // Cart state
  List<Product> cartItems;
  double totalPrice;
  
  // Theme state
  bool isDarkMode;
  
  // Settings state
  String language;
  bool notificationsEnabled;
  
  // ... 50 methods khác
  // → Class quá lớn, khó maintain!
}
```

**Vấn đề:**
- Class quá lớn (1000+ dòng)
- Khó tìm code
- Khó test
- Nhiều widget rebuild không cần thiết

**✅ Giải pháp: Chia nhỏ Provider**

```dart
// ✅ ĐÚNG: Chia thành nhiều Provider nhỏ
class UserProvider extends ChangeNotifier {
  String? userName;
  String? userEmail;
  bool isLoggedIn;
  // Chỉ quản lý User state
}

class CartProvider extends ChangeNotifier {
  List<Product> cartItems;
  double totalPrice;
  // Chỉ quản lý Cart state
}

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode;
  // Chỉ quản lý Theme state
}

// Mỗi Provider nhỏ, dễ maintain
```

---

## ✔ Đúng: chia thành nhiều provider nhỏ

---

## 🔴 Case Study: Các lỗi khác thường gặp

### Case Study 1: Quên notifyListeners()

#### ❌ Vấn đề:

```dart
class CounterProvider extends ChangeNotifier {
  int count = 0;
  
  void increase() {
    count++;  // ← Quên notifyListeners()!
    // UI không cập nhật!
  }
}
```

#### ✅ Giải pháp:

```dart
void increase() {
  count++;
  notifyListeners();  // ← QUAN TRỌNG!
}
```

---

### Case Study 2: Dùng watch() thay vì read() trong onPressed

#### ❌ Vấn đề:

```dart
ElevatedButton(
  onPressed: () {
    context.watch<CounterProvider>().increase();  // ← SAI!
  },
)
```

#### ✅ Giải pháp:

```dart
ElevatedButton(
  onPressed: () {
    context.read<CounterProvider>().increase();  // ← ĐÚNG!
  },
)
```

---

### Case Study 3: Provider không được khởi tạo

#### ❌ Vấn đề:

```dart
void main() {
  runApp(MyApp());  // ← Thiếu Provider!
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterProvider>().count;  // ← Lỗi: Provider not found!
  }
}
```

#### ✅ Giải pháp:

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),  // ← Khởi tạo Provider
      child: MyApp(),
    ),
  );
}
```

---

### Case Study 4: Thay đổi state trực tiếp từ UI

#### ❌ Vấn đề:

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounterProvider>();
    
    return ElevatedButton(
      onPressed: () {
        provider.count++;  // ← SAI: Thay đổi trực tiếp!
        // Quên notifyListeners() → UI không cập nhật
      },
    );
  }
}
```

#### ✅ Giải pháp:

```dart
ElevatedButton(
  onPressed: () {
    context.read<CounterProvider>().increase();  // ← ĐÚNG: Dùng method
  },
)
```

---

### Case Study 5: Dùng watch() nhiều lần không cần thiết

#### ❌ Vấn đề:

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterProvider>().count;  // watch() lần 1
    final provider = context.watch<CounterProvider>();     // watch() lần 2 (trùng!)
    
    return Column(
      children: [
        Text("Count: $count"),
        Text("Double: ${provider.count * 2}"),  // Có thể dùng count ở trên
      ],
    );
  }
}
```

#### ✅ Giải pháp:

```dart
@override
Widget build(BuildContext context) {
  final provider = context.watch<CounterProvider>();  // watch() 1 lần
  
  return Column(
    children: [
      Text("Count: ${provider.count}"),
      Text("Double: ${provider.count * 2}"),  // Dùng lại provider
    ],
  );
}
```

---

# 10. **Các ví dụ thực tế đa dạng**

## 10.1. **Ví dụ: Quản lý giỏ hàng**

### CartProvider

```dart
class CartProvider extends ChangeNotifier {
  List<String> items = [];

  void addItem(String item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(String item) {
    items.remove(item);
    notifyListeners();
  }

  int get count => items.length;
}
```

### UI hiển thị giỏ hàng

```dart
final cart = context.watch<CartProvider>();

Text("Số lượng: ${cart.count}");
```

### Nút thêm vào giỏ

```dart
onPressed: () => context.read<CartProvider>().addItem("Sản phẩm A")
```

---

### 🧠 Giảng giải chi tiết: CartProvider hoạt động như thế nào?

**Flow minh họa:**

```
[INITIAL STATE]
CartProvider: items = []
UI: "Số lượng: 0"

[USER ACTION]
User nhấn "Thêm vào giỏ"
    ↓
[PROVIDER]
context.read<CartProvider>().addItem("Sản phẩm A")
    ↓
items.add("Sản phẩm A") → items = ["Sản phẩm A"]
notifyListeners()
    ↓
[UI UPDATE]
Widget đang watch() được thông báo
build() được gọi lại
context.watch<CartProvider>().count → 1
    ↓
[RESULT]
UI: "Số lượng: 1" ✅
```

**Ví dụ minh họa đầy đủ:**

```dart
// models/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  
  Product({required this.id, required this.name, required this.price});
}

// providers/cart_provider.dart
class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];
  
  // Getter
  List<Product> get items => List.unmodifiable(_items);
  int get count => _items.length;
  double get totalPrice {
    return _items.fold(0, (sum, product) => sum + product.price);
  }
  
  // Methods
  void addItem(Product product) {
    _items.add(product);
    notifyListeners();  // ← Báo UI: "Giỏ hàng đã thay đổi!"
  }
  
  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();  // ← Báo UI: "Giỏ hàng đã thay đổi!"
  }
  
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// screens/product_list_screen.dart
class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(id: "1", name: "Laptop", price: 1000),
    Product(id: "2", name: "Phone", price: 500),
  ];
  
  @override
  Widget build(BuildContext context) {
    // ✅ watch() để hiển thị số lượng trong giỏ
    final cartCount = context.watch<CartProvider>().count;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Sản phẩm"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to cart screen
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$cartCount",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text("${product.price.toStringAsFixed(0)} đ"),
            trailing: ElevatedButton(
              onPressed: () {
                // ✅ read() để thêm vào giỏ
                context.read<CartProvider>().addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Đã thêm ${product.name} vào giỏ")),
                );
              },
              child: Text("Thêm vào giỏ"),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 10.2. **Ví dụ: User Authentication với Provider**

```dart
// providers/user_provider.dart
class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();  // Hiển thị loading
    
    try {
      // Giả lập API call
      await Future.delayed(Duration(seconds: 2));
      
      if (email == "admin@example.com" && password == "123456") {
        _user = User(email: email, name: "Admin");
        _error = null;
      } else {
        _error = "Email hoặc mật khẩu không đúng";
      }
    } catch (e) {
      _error = "Lỗi: $e";
    } finally {
      _isLoading = false;
      notifyListeners();  // Ẩn loading, hiển thị kết quả
    }
  }
  
  void logout() {
    _user = null;
    _error = null;
    notifyListeners();
  }
}

// screens/login_screen.dart
class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    // ✅ watch() để hiển thị loading/error
    final userProvider = context.watch<UserProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text("Đăng nhập")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Mật khẩu"),
            ),
            if (userProvider.error != null)
              Text(
                userProvider.error!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            userProvider.isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    // ✅ read() để gọi login
                    context.read<UserProvider>().login(
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: Text("Đăng nhập"),
                ),
          ],
        ),
      ),
    );
  }
}
```

---

## 10.3. **Ví dụ: Theme Management với Provider**

```dart
// providers/theme_provider.dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  ThemeData get theme => _isDarkMode ? ThemeData.dark() : ThemeData.light();
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}

// main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ watch() để lấy theme
    final themeProvider = context.watch<ThemeProvider>();
    
    return MaterialApp(
      theme: themeProvider.theme,  // ← Theme thay đổi theo Provider
      home: HomeScreen(),
    );
  }
}

// screens/settings_screen.dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text("Cài đặt")),
      body: SwitchListTile(
        title: Text("Chế độ tối"),
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          // ✅ read() để toggle theme
          context.read<ThemeProvider>().setDarkMode(value);
        },
      ),
    );
  }
}
```

---

## 10.4. **Ví dụ: Todo App với Provider**

```dart
// models/todo.dart
class Todo {
  final String id;
  String title;
  bool isCompleted;
  
  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

// providers/todo_provider.dart
class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [];
  
  List<Todo> get todos => List.unmodifiable(_todos);
  List<Todo> get completedTodos => _todos.where((t) => t.isCompleted).toList();
  List<Todo> get activeTodos => _todos.where((t) => !t.isCompleted).toList();
  int get totalCount => _todos.length;
  int get completedCount => completedTodos.length;
  
  void addTodo(String title) {
    _todos.add(Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    ));
    notifyListeners();
  }
  
  void toggleTodo(String id) {
    final todo = _todos.firstWhere((t) => t.id == id);
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
  }
  
  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }
  
  void updateTodo(String id, String newTitle) {
    final todo = _todos.firstWhere((t) => t.id == id);
    todo.title = newTitle;
    notifyListeners();
  }
}

// screens/todo_screen.dart
class TodoScreen extends StatelessWidget {
  final _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text("Todo List")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Nhập công việc..."),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      context.read<TodoProvider>().addTodo(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                  child: Text("Thêm"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) {
                      context.read<TodoProvider>().toggleTodo(todo.id);
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<TodoProvider>().deleteTodo(todo.id);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "Tổng: ${todoProvider.totalCount} | "
              "Hoàn thành: ${todoProvider.completedCount}",
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 10.5. **Ví dụ: Product Management với Provider**

```dart
// providers/product_provider.dart
class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];
  String _searchQuery = "";
  String? _selectedCategory;
  
  List<Product> get products {
    var filtered = _products;
    
    // Filter by search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // Filter by category
    if (_selectedCategory != null) {
      filtered = filtered.where((p) {
        return p.category == _selectedCategory;
      }).toList();
    }
    
    return filtered;
  }
  
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }
  
  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }
  
  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();  // Rebuild để hiển thị kết quả tìm kiếm
  }
  
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
```

---

# 11. **Best Practices & Performance**

## 11.1. **Tổ chức Provider trong dự án lớn**

**Cấu trúc thư mục:**

```
lib/
├── main.dart
├── providers/
│   ├── counter_provider.dart
│   ├── user_provider.dart
│   ├── cart_provider.dart
│   └── theme_provider.dart
├── models/
│   ├── user.dart
│   └── product.dart
└── screens/
    ├── home_screen.dart
    └── cart_screen.dart
```

**Quy tắc đặt tên:**

- Provider: `*_provider.dart` (ví dụ: `user_provider.dart`)
- Class: `*Provider` (ví dụ: `UserProvider`)

## 11.2. **Performance Tips**

### 1. Dùng Consumer thay vì watch() khi có thể

```dart
// ✅ ĐÚNG: Consumer chỉ rebuild phần cần
Consumer<CounterProvider>(
  builder: (context, provider, child) {
    return Text("Count: ${provider.count}");
  },
)
```

### 2. Tránh watch() nhiều lần không cần thiết

```dart
// ❌ SAI: watch() nhiều lần
final count = context.watch<CounterProvider>().count;
final provider = context.watch<CounterProvider>();  // Trùng!

// ✅ ĐÚNG: watch() 1 lần
final provider = context.watch<CounterProvider>();
final count = provider.count;
```

### 3. Dùng read() trong onPressed

```dart
// ✅ ĐÚNG: read() trong onPressed
ElevatedButton(
  onPressed: () {
    context.read<CounterProvider>().increase();
  },
)
```

## 11.3. **Best Practices**

### 1. Mỗi Provider quản lý 1 domain

```dart
// ✅ ĐÚNG: Provider nhỏ, tập trung
class UserProvider extends ChangeNotifier {
  // Chỉ quản lý User
}

class CartProvider extends ChangeNotifier {
  // Chỉ quản lý Cart
}
```

### 2. Luôn dùng getter cho state

```dart
class CounterProvider extends ChangeNotifier {
  int _count = 0;  // Private
  
  int get count => _count;  // Public getter
  
  void increase() {
    _count++;
    notifyListeners();
  }
}
```

### 3. Xử lý async trong Provider

```dart
class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  User? _user;
  
  bool get isLoading => _isLoading;
  User? get user => _user;
  
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await apiService.getUser();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

# 12. **Bài tập thực hành**

1. **Tạo CounterApp với tăng/giảm-reset bằng Provider.**  
   → Xem ví dụ 6

2. **Tạo TodoApp mini với Provider (danh sách công việc).**  
   → Xem ví dụ 10.4

3. **Tạo CartApp có thêm/xóa sản phẩm + tính tổng giá.**  
   → Xem ví dụ 10.1

4. **Tách dự án thành 3 provider: User, Theme, Cart.**  
   → Xem ví dụ MultiProvider phần 7

5. **Tạo màn hình login → lưu trạng thái user vào Provider.**  
   → Xem ví dụ 10.2

6. **Tạo Product Management App:**
   - ProductProvider quản lý danh sách sản phẩm
   - Có thể thêm/sửa/xóa sản phẩm
   - Tìm kiếm sản phẩm
   - Lọc theo danh mục

7. **Tạo Settings Screen với Provider:**
   - ThemeProvider: Dark/Light mode
   - LanguageProvider: Ngôn ngữ
   - NotificationProvider: Bật/tắt thông báo

8. **Tạo Shopping App hoàn chỉnh:**
   - ProductProvider: Quản lý sản phẩm
   - CartProvider: Giỏ hàng
   - UserProvider: Thông tin user
   - Tích hợp tất cả với MultiProvider

---

# 13. Mini Test cuối chương

**Câu 1:** ChangeNotifier dùng để làm gì?  
→ Quản lý state và thông báo listeners khi state thay đổi qua notifyListeners().

**Câu 2:** context.watch() dùng để?  
→ Lắng nghe state và rebuild UI khi Provider thay đổi.

**Câu 3:** context.read() dùng để?  
→ Gọi action/method, không đăng ký listener, không rebuild.

**Câu 4:** Consumer giúp gì?  
→ Chỉ rebuild widget bên trong, tối ưu performance.

**Câu 5:** notifyListeners() dùng khi nào?  
→ Khi state thay đổi và muốn cập nhật UI (gọi trong method của Provider).

**Câu 6:** Tại sao không gọi notifyListeners() trong build()?  
→ Gây vòng lặp vô hạn: build() → notifyListeners() → rebuild → build() → ...

**Câu 7:** Khi nào dùng watch() vs read()?  
→ watch() để hiển thị state trong UI, read() để gọi method trong onPressed.

**Câu 8:** MultiProvider dùng để làm gì?  
→ Đăng ký nhiều Provider cùng lúc cho ứng dụng lớn.

**Câu 9:** Tại sao nên chia nhỏ Provider thay vì 1 Provider lớn?  
→ Dễ maintain, dễ test, tránh rebuild không cần thiết.

**Câu 10:** Provider vs setState() khác nhau như thế nào?  
→ setState() quản lý state trong widget, Provider quản lý state ở ngoài widget, nhiều widget có thể truy cập.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **Provider** = state management đơn giản + hiệu quả nhất (Google khuyến nghị).  
- **ChangeNotifier** giữ state + logic, notifyListeners() để báo UI rebuild.  
- **watch()** để lắng nghe và hiển thị state (rebuild UI).  
- **read()** để gọi action/method (không rebuild).  
- **Consumer** tối ưu performance (chỉ rebuild phần bên trong).  
- **MultiProvider** dùng cho ứng dụng lớn (nhiều Provider).  
- **State đặt ở Provider**, không đặt ở UI.  
- **Không gọi notifyListeners()** trong build() (gây vòng lặp vô hạn).  
- **Chia nhỏ Provider** theo domain (User, Cart, Theme...).  
- **Luôn dispose** Provider nếu cần (Provider tự dispose khi app đóng).

---

# 🎉 Kết thúc chương 09  
Tiếp theo là “đỉnh cao” trong Flutter cơ bản:

👉 **Chương 10 – Networking & API (http, Future, JSON, FutureBuilder)**

