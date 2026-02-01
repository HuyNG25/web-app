# 🟦 CHƯƠNG 06  
# **NAVIGATION TRONG FLUTTER**  
*(Điều hướng giữa các màn hình – push, pop, named routes – truyền dữ liệu)*

Một ứng dụng thực tế luôn có nhiều màn hình.  
Bạn không thể nhét tất cả UI vào 1 page được.

Chương này sẽ dạy bạn:

- chuyển màn hình  
- quay lại  
- truyền dữ liệu giữa các màn hình  
- dùng Named Routes  
- quản lý Navigation cho dự án lớn  

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn có thể:

- Điều hướng giữa các màn hình bằng push/pop.  
- Truyền dữ liệu sang màn hình khác.  
- Nhận dữ liệu trả về từ màn hình.  
- Dùng Named Routes để quản lý nhiều màn hình.  
- Biết các lỗi thường gặp khi navigate.

---

# 1. **Cấu trúc dự án nhiều màn hình**

```
lib/
  main.dart
  screens/
    home_screen.dart
    detail_screen.dart
```

Mỗi màn hình là một Widget.

---

# 2. **Navigator.push – chuyển sang màn hình mới**

Ví dụ HomeScreen → DetailScreen:

### 🟩 HomeScreen

```dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DetailScreen()),
    );
  },
  child: const Text("Đi tới màn chi tiết"),
);
```

### 🟩 DetailScreen

```dart
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết")),
      body: const Center(child: Text("Detail Page")),
    );
  }
}
```

---

### 🧠 Lý thuyết chi tiết về Navigation Stack

**Navigation Stack là gì?**

Flutter sử dụng **Stack (ngăn xếp)** để quản lý các màn hình:

```
Stack (LIFO - Last In First Out)
    ↓
[DetailScreen]  ← Top (màn hình hiện tại)
[HomeScreen]
[SplashScreen] ← Bottom (màn hình đầu tiên)
```

**Cơ chế hoạt động:**

1. **Navigator.push()** → Đẩy màn hình mới lên **đỉnh stack**
2. **Navigator.pop()** → Xóa màn hình ở **đỉnh stack**, quay về màn hình trước
3. **Navigator.pushReplacement()** → Thay thế màn hình hiện tại
4. **Navigator.pushAndRemoveUntil()** → Push mới và xóa các màn hình cũ

**Ví dụ minh họa:**

```
Bước 1: App khởi động
Stack: [SplashScreen]

Bước 2: push LoginScreen
Stack: [SplashScreen, LoginScreen]

Bước 3: push HomeScreen
Stack: [SplashScreen, LoginScreen, HomeScreen]

Bước 4: push DetailScreen
Stack: [SplashScreen, LoginScreen, HomeScreen, DetailScreen]

Bước 5: pop() từ DetailScreen
Stack: [SplashScreen, LoginScreen, HomeScreen] ← Quay về HomeScreen
```

**Lưu ý quan trọng:**

- Mỗi lần `push` → màn hình mới được **thêm vào stack**
- Mỗi lần `pop` → màn hình ở đỉnh bị **xóa khỏi stack**
- Stack càng sâu → càng tốn bộ nhớ
- Có thể kiểm tra stack: `Navigator.canPop(context)`

---

# 3. **Navigator.pop – quay về màn hình trước**

Trong DetailScreen:

```dart
Navigator.pop(context);
```

### Các cách pop:

```dart
// 1. Pop đơn giản
Navigator.pop(context);

// 2. Pop với dữ liệu trả về
Navigator.pop(context, "Dữ liệu trả về");

// 3. Pop nhiều màn hình (về màn hình cụ thể)
Navigator.popUntil(context, (route) => route.isFirst);

// 4. Kiểm tra có thể pop không
if (Navigator.canPop(context)) {
  Navigator.pop(context);
}
```

---

### 🎒 Ví dụ đời sống  
`Navigator.push` giống như **bạn đi vào phòng mới**.  
`Navigator.pop` giống như **bạn bước ra lại phòng cũ**.

Stack push–pop = chồng phòng.

**Tưởng tượng:**
- Bạn đang ở phòng khách (HomeScreen)
- Bước vào phòng ngủ (DetailScreen) → push
- Bước ra lại phòng khách → pop
- Nếu có nhiều phòng, bạn phải bước ra từng phòng một

---

# 4. **Truyền dữ liệu sang màn hình khác**

Ví dụ: từ HomeScreen → DetailScreen truyền "sản phẩm".

### 🟩 HomeScreen

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(productName: "Laptop X"),
  ),
);
```

### 🟩 DetailScreen

```dart
class DetailScreen extends StatelessWidget {
  final String productName;

  const DetailScreen({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: Center(child: Text("Chi tiết: $productName")),
    );
  }
}
```

---

# 5. **Nhận dữ liệu trả về – giống “result” trong Android**

Ví dụ: màn chọn màu trả về kết quả:

### 🟩 Từ HomeScreen

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ColorPickerScreen()),
);

print("Màu đã chọn: $result");
```

### 🟩 Từ ColorPickerScreen

```dart
Navigator.pop(context, "red");
```

---

# 6. **Named Routes – Quản lý navigation cho dự án lớn**

### Đăng ký route trong MaterialApp

```dart
MaterialApp(
  routes: {
    '/': (context) => const HomeScreen(),
    '/detail': (context) => const DetailScreen(),
  },
);
```

### Điều hướng

```dart
Navigator.pushNamed(context, '/detail');
```

### Điều hướng kèm dữ liệu

Không thể truyền trực tiếp → dùng arguments:

```dart
Navigator.pushNamed(
  context,
  '/detail',
  arguments: "Laptop X",
);
```

### Nhận dữ liệu trong màn hình

```dart
@override
Widget build(BuildContext context) {
  final productName = ModalRoute.of(context)!.settings.arguments as String;
  return Text("Sản phẩm: $productName");
}
```

---

# 7. **onGenerateRoute – dành cho ứng dụng lớn và linh hoạt**

```dart
MaterialApp(
  onGenerateRoute: (settings) {
    if (settings.name == '/detail') {
      final data = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => DetailScreen(productName: data),
      );
    }
    return MaterialPageRoute(builder: (context) => const HomeScreen());
  },
);
```

---

# 8. **BottomNavigationBar & Navigation nâng cao**  

### 8.1. **BottomNavigationBar cơ bản**

```dart
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
```

### 8.2. **Navigation với TabBar**

```dart
class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tab Navigation"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: "Home"),
              Tab(icon: Icon(Icons.favorite), text: "Favorite"),
              Tab(icon: Icon(Icons.settings), text: "Settings"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            FavoriteScreen(),
            SettingsScreen(),
          ],
        ),
      ),
    );
  }
}
```

### 8.3. **Các phương thức Navigation khác**

#### Navigator.pushReplacement - Thay thế màn hình hiện tại

```dart
// Thay thế màn hình hiện tại (không thể quay lại)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);

// Ví dụ: LoginScreen → HomeScreen (không muốn quay lại Login)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);
```

#### Navigator.pushAndRemoveUntil - Push và xóa các màn hình cũ

```dart
// Push HomeScreen và xóa tất cả màn hình trước đó
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
  (route) => false, // Xóa tất cả route trước đó
);

// Ví dụ: Login → Home, xóa Splash và Login khỏi stack
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
  (route) => route.isFirst, // Giữ lại màn hình đầu tiên
);
```

#### Navigator.popUntil - Pop nhiều màn hình

```dart
// Pop về màn hình đầu tiên
Navigator.popUntil(context, (route) => route.isFirst);

// Pop về màn hình có tên cụ thể
Navigator.popUntil(context, ModalRoute.withName('/home'));
```

---

### 🧠 Khi nào dùng phương thức nào?

| Phương thức | Khi nào dùng | Ví dụ |
|------------|--------------|-------|
| `push` | Thêm màn hình mới, có thể quay lại | Home → Detail |
| `pop` | Quay lại màn hình trước | Detail → Home |
| `pushReplacement` | Thay thế màn hình, không quay lại | Login → Home |
| `pushAndRemoveUntil` | Push mới và xóa stack cũ | Login → Home (xóa Splash, Login) |
| `popUntil` | Pop nhiều màn hình cùng lúc | Detail → Home (bỏ qua các màn hình trung gian) |

---

# 9. **Case Study: Các lỗi Navigation hay gặp và cách xử lý**

## 🔴 Case Study 1: Login → Home → Detail, nhưng Back lại quay ra Login

### ❌ Vấn đề:

```
Navigation Flow:
SplashScreen → LoginScreen → HomeScreen (với BottomNav) → DetailScreen

Khi ở DetailScreen, nhấn Back:
❌ Quay về LoginScreen (SAI!)
✅ Mong muốn: Quay về HomeScreen
```

### 🔍 Nguyên nhân:

**Lỗi thường gặp:** Dùng `push` thay vì `pushReplacement` khi chuyển từ Login → Home

```dart
// ❌ SAI: LoginScreen push HomeScreen
class LoginScreen extends StatelessWidget {
  void _handleLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    // Stack: [Splash, Login, Home]
    // Khi pop từ Detail → Home → Login (SAI!)
  }
}
```

### ✅ Giải pháp:

**Giải pháp 1: Dùng pushReplacement khi Login → Home**

```dart
// ✅ ĐÚNG: Thay thế LoginScreen bằng HomeScreen
class LoginScreen extends StatelessWidget {
  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    // Stack: [Splash, Home] ← Login đã bị thay thế
    // Khi pop từ Detail → Home (ĐÚNG!)
  }
}
```

**Giải pháp 2: Dùng pushAndRemoveUntil để xóa toàn bộ stack cũ**

```dart
// ✅ ĐÚNG: Push Home và xóa tất cả màn hình trước đó
class LoginScreen extends StatelessWidget {
  void _handleLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false, // Xóa tất cả route trước đó
    );
    // Stack: [Home] ← Chỉ còn Home
    // Khi pop từ Detail → Home (ĐÚNG!)
  }
}
```

**Giải pháp 3: Giữ lại SplashScreen (nếu cần)**

```dart
// ✅ ĐÚNG: Xóa Login nhưng giữ Splash
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
  (route) => route.isFirst, // Giữ lại màn hình đầu tiên (Splash)
);
// Stack: [Splash, Home]
```

---

## 🔴 Case Study 2: BottomNavigationBar với Navigation Stack

### ❌ Vấn đề:

Khi có BottomNavigationBar, mỗi tab có thể có navigation stack riêng. Nếu không xử lý đúng, sẽ gặp lỗi:

```dart
// ❌ SAI: Mỗi lần chuyển tab lại push mới
class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Nếu tab có navigation stack riêng, cần quản lý đúng
  }
}
```

### ✅ Giải pháp:

**Dùng IndexedStack để giữ state của mỗi tab:**

```dart
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Mỗi tab có Navigator riêng
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Navigator(
            key: _navigatorKeys[0],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
            },
          ),
          Navigator(
            key: _navigatorKeys[1],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              );
            },
          ),
          Navigator(
            key: _navigatorKeys[2],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Nếu tab có thể pop, pop trước
          if (_navigatorKeys[index].currentState!.canPop()) {
            _navigatorKeys[index].currentState!.pop();
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
```

---

## 🔴 Case Study 3: Quên kiểm tra canPop trước khi pop

### ❌ Vấn đề:

```dart
// ❌ SAI: Pop khi không có màn hình nào để pop
ElevatedButton(
  onPressed: () {
    Navigator.pop(context); // Crash nếu đây là màn hình đầu tiên!
  },
)
```

### ✅ Giải pháp:

```dart
// ✅ ĐÚNG: Kiểm tra trước khi pop
ElevatedButton(
  onPressed: () {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Xử lý khi không thể pop (ví dụ: đóng app)
      Navigator.of(context).pop();
    }
  },
)

// Hoặc dùng WillPopScope (cho AppBar back button)
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Xử lý logic trước khi pop
        return true; // Cho phép pop
      },
      child: Scaffold(...),
    );
  }
}
```

---

## 🔴 Case Study 4: Push màn hình vào chính nó → Loop vô tận

### ❌ Vấn đề:

```dart
// ❌ SAI: Push chính màn hình hiện tại
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ); // Push chính nó → Stack ngày càng sâu!
        },
      ),
    );
  }
}
```

### ✅ Giải pháp:

```dart
// ✅ ĐÚNG: Chỉ push màn hình khác
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DetailScreen()),
);
```

---

## 🔴 Case Study 5: Quên truyền arguments khi dùng Named Routes

### ❌ Vấn đề:

```dart
// ❌ SAI: Quên truyền arguments
Navigator.pushNamed(context, '/detail');

// DetailScreen
final data = ModalRoute.of(context)!.settings.arguments as String;
// Lỗi: arguments = null
```

### ✅ Giải pháp:

```dart
// ✅ ĐÚNG: Luôn truyền arguments
Navigator.pushNamed(
  context,
  '/detail',
  arguments: "Dữ liệu cần truyền",
);

// DetailScreen - Kiểm tra null
@override
Widget build(BuildContext context) {
  final arguments = ModalRoute.of(context)?.settings.arguments;
  if (arguments == null) {
    return Scaffold(
      body: Center(child: Text("Không có dữ liệu")),
    );
  }
  final data = arguments as String;
  return Scaffold(...);
}
```

---

## 🔴 Case Study 6: Context không hợp lệ khi navigate

### ❌ Vấn đề:

```dart
// ❌ SAI: Dùng context sau khi widget đã dispose
Future<void> _loadData() async {
  await Future.delayed(Duration(seconds: 2));
  Navigator.push(context, ...); // Context có thể không còn hợp lệ!
}
```

### ✅ Giải pháp:

```dart
// ✅ ĐÚNG: Kiểm tra mounted trước khi navigate
Future<void> _loadData() async {
  await Future.delayed(Duration(seconds: 2));
  if (mounted && context.mounted) {
    Navigator.push(context, ...);
  }
}

// Hoặc dùng NavigatorKey
final navigatorKey = GlobalKey<NavigatorState>();

MaterialApp(
  navigatorKey: navigatorKey,
  ...
)

// Dùng ở bất kỳ đâu
navigatorKey.currentState?.push(...);
```

---

## 🔴 Case Study 7: Navigation trong async function

### ❌ Vấn đề:

```dart
// ❌ SAI: Navigate sau async mà không kiểm tra
void _handleLogin() async {
  await loginAPI();
  Navigator.push(context, ...); // Context có thể không còn hợp lệ
}
```

### ✅ Giải pháp:

```dart
// ✅ ĐÚNG: Kiểm tra mounted và context
void _handleLogin() async {
  await loginAPI();
  if (!mounted) return; // Widget đã bị dispose
  if (!context.mounted) return; // Context không còn hợp lệ
  
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}
```

---

# 10. **Sai vs Đúng (Sinh viên hay mắc nhất)**

## ❌ Sai: push màn hình vào chính nó → bị loop

```dart
Navigator.push(context,
  MaterialPageRoute(builder: (_) => HomeScreen()));
```

## ✔ Đúng:
Chỉ push sang màn hình mới.

---

## ❌ Sai: quên truyền dữ liệu

```
Navigator.pushNamed(context, '/detail');
```

DetailScreen:

```
final data = ModalRoute.of(context)!.settings.arguments as String; // lỗi
```

## ✔ Đúng:

```
Navigator.pushNamed(context, '/detail', arguments: "abc");
```

---

## ❌ Sai: Dùng push thay vì pushReplacement khi Login → Home

```dart
// ❌ SAI: Push Login → Home, vẫn có thể quay lại Login
Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
```

## ✔ Đúng: Dùng pushReplacement

```dart
// ✅ ĐÚNG: Thay thế Login, không thể quay lại
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => HomeScreen()),
);
```

---

## ❌ Sai: Pop khi không có màn hình nào để pop

```dart
// ❌ SAI: Crash nếu đây là màn hình đầu tiên
Navigator.pop(context);
```

## ✔ Đúng: Kiểm tra canPop trước

```dart
// ✅ ĐÚNG: Kiểm tra trước khi pop
if (Navigator.canPop(context)) {
  Navigator.pop(context);
}
```

---

## ❌ Sai: Navigate sau async mà không kiểm tra context

```dart
// ❌ SAI: Context có thể không còn hợp lệ
Future<void> loadData() async {
  await Future.delayed(Duration(seconds: 2));
  Navigator.push(context, ...);
}
```

## ✔ Đúng: Kiểm tra mounted và context

```dart
// ✅ ĐÚNG: Kiểm tra trước khi navigate
Future<void> loadData() async {
  await Future.delayed(Duration(seconds: 2));
  if (mounted && context.mounted) {
    Navigator.push(context, ...);
  }
}
```

---

# 11. **Ví dụ thực tế đa dạng**

## 11.1. **Ví dụ: App với Splash → Login → Home → Detail**

```dart
// main.dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
      },
    );
  }
}

// SplashScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// LoginScreen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleLogin(BuildContext context) {
    // ✅ QUAN TRỌNG: Dùng pushReplacement để không quay lại Login
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleLogin(context),
          child: const Text("Đăng nhập"),
        ),
      ),
    );
  }
}

// HomeScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trang chủ")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: "Sản phẩm ABC",
            );
          },
          child: const Text("Xem chi tiết"),
        ),
      ),
    );
  }
}

// DetailScreen
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productName = ModalRoute.of(context)?.settings.arguments as String?;
    
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sản phẩm: ${productName ?? 'Không có dữ liệu'}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, "Đã xem chi tiết");
              },
              child: const Text("Quay lại"),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 11.2. **Ví dụ: Color Picker trả về kết quả**

```dart
// HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color? _selectedColor;

  Future<void> _pickColor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ColorPickerScreen()),
    );
    
    if (result != null && mounted) {
      setState(() {
        _selectedColor = result as Color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn màu")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              color: _selectedColor ?? Colors.grey,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickColor,
              child: const Text("Chọn màu"),
            ),
          ],
        ),
      ),
    );
  }
}

// ColorPickerScreen
class ColorPickerScreen extends StatelessWidget {
  const ColorPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Chọn màu")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, colors[index]);
            },
            child: Container(
              color: colors[index],
              child: Center(
                child: Text(
                  "Màu ${index + 1}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 11.3. **Ví dụ: Product List → Detail với dữ liệu phức tạp**

```dart
// Product Model
class Product {
  final String id;
  final String name;
  final double price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });
}

// ProductListScreen
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  final List<Product> _products = const [
    Product(
      id: "1",
      name: "Laptop Dell",
      price: 15000000,
      description: "Laptop cao cấp",
    ),
    Product(
      id: "2",
      name: "iPhone 15",
      price: 25000000,
      description: "Điện thoại thông minh",
    ),
    Product(
      id: "3",
      name: "AirPods Pro",
      price: 5000000,
      description: "Tai nghe không dây",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách sản phẩm")),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text("${product.price.toStringAsFixed(0)} đ"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ProductDetailScreen
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${product.price.toStringAsFixed(0)} đ",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              "Mô tả:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(product.description),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, product);
                },
                child: const Text("Thêm vào giỏ hàng"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 11.4. **Ví dụ: BottomNavigationBar với Navigation Stack**

```dart
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTabScreen(),
    const ProfileTabScreen(),
    const SettingsTabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

// HomeTabScreen có thể navigate đến Detail
class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailScreen(),
              ),
            );
          },
          child: const Text("Xem chi tiết"),
        ),
      ),
    );
  }
}
```

---

# 12. **Best Practices & Performance**

## 12.1. **Khi nào dùng phương thức nào?**

| Tình huống | Phương thức | Ví dụ |
|-----------|------------|-------|
| Thêm màn hình, có thể quay lại | `push` | Home → Detail |
| Quay lại màn hình trước | `pop` | Detail → Home |
| Thay thế màn hình, không quay lại | `pushReplacement` | Login → Home |
| Push mới và xóa stack cũ | `pushAndRemoveUntil` | Login → Home (xóa Splash, Login) |
| Pop nhiều màn hình | `popUntil` | Detail → Home (bỏ qua các màn hình trung gian) |

## 12.2. **Best Practices**

### 1. Luôn kiểm tra mounted và context trước khi navigate

```dart
Future<void> _navigate() async {
  await Future.delayed(Duration(seconds: 2));
  if (mounted && context.mounted) {
    Navigator.push(context, ...);
  }
}
```

### 2. Dùng pushReplacement cho Login → Home

```dart
// ✅ ĐÚNG: Không cho phép quay lại Login
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);
```

### 3. Kiểm tra canPop trước khi pop

```dart
if (Navigator.canPop(context)) {
  Navigator.pop(context);
}
```

### 4. Dùng Named Routes cho dự án lớn

```dart
MaterialApp(
  routes: {
    '/': (context) => const HomeScreen(),
    '/detail': (context) => const DetailScreen(),
  },
)
```

### 5. Validate arguments khi nhận dữ liệu

```dart
final arguments = ModalRoute.of(context)?.settings.arguments;
if (arguments == null) {
  return Scaffold(body: Center(child: Text("Không có dữ liệu")));
}
final data = arguments as String;
```

---

# 13. **Bài tập thực hành**

1. **Tạo HomeScreen → nút "Đi tới Chi tiết" → DetailScreen.**  
   → Xem ví dụ 11.1

2. **Truyền 1 chuỗi (tên sinh viên) sang màn hình chi tiết.**  
   → Xem ví dụ phần 4

3. **Tạo ColorPickerScreen → trả kết quả về HomeScreen.**  
   → Xem ví dụ 11.2

4. **Cấu hình named routes cho 3 màn hình (Home, Detail, Profile).**  
   → Xem ví dụ 11.1

5. **Tạo ứng dụng mini: Danh sách sản phẩm → bấm vào 1 sản phẩm → sang DetailScreen.**  
   → Xem ví dụ 11.3

6. **Tạo app với flow: Splash → Login → Home. Đảm bảo không quay lại Login khi back từ Home.**

7. **Tạo BottomNavigationBar với 3 tab, mỗi tab có thể navigate đến màn hình con.**

8. **Tạo form đăng ký → sau khi đăng ký thành công, chuyển sang Home và xóa Login khỏi stack.**

9. **Tạo màn hình chọn màu → trả về màu đã chọn → HomeScreen đổi màu nền theo màu đã chọn.**

10. **Tạo app shopping: ProductList → ProductDetail → Cart. Đảm bảo navigation stack đúng.**

---

# 14. Mini Test cuối chương

**Câu 1:** Navigator.push dùng để làm gì?  
→ Chuyển sang màn hình mới, thêm vào navigation stack.

**Câu 2:** Làm sao để quay lại màn hình trước?  
→ `Navigator.pop(context)` hoặc `Navigator.pop(context, data)` để trả về dữ liệu.

**Câu 3:** Muốn truyền dữ liệu sang màn hình khác?  
→ Truyền qua constructor hoặc arguments (với named routes).

**Câu 4:** Named routes là gì?  
→ Cách định nghĩa đường dẫn cho màn hình để dễ quản lý và maintain.

**Câu 5:** onGenerateRoute dùng trong trường hợp nào?  
→ Ứng dụng lớn, cần kiểm soát navigation linh hoạt, xử lý arguments phức tạp.

**Câu 6:** Tại sao cần dùng pushReplacement khi Login → Home?  
→ Để không cho phép quay lại Login, tránh lỗi navigation stack.

**Câu 7:** Làm sao pop nhiều màn hình cùng lúc?  
→ Dùng `Navigator.popUntil(context, (route) => condition)`.

**Câu 8:** Làm sao kiểm tra có thể pop không?  
→ Dùng `Navigator.canPop(context)`.

**Câu 9:** Tại sao cần kiểm tra mounted trước khi navigate sau async?  
→ Để tránh lỗi khi widget đã bị dispose nhưng async operation vẫn chạy.

**Câu 10:** Navigation Stack là gì?  
→ Cấu trúc dữ liệu LIFO (Last In First Out) quản lý các màn hình trong Flutter.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **push** = đi tới màn mới, thêm vào stack.  
- **pop** = quay lại màn hình trước, xóa khỏi stack.  
- **pushReplacement** = thay thế màn hình hiện tại (Login → Home).  
- **pushAndRemoveUntil** = push mới và xóa các màn hình cũ.  
- **Truyền dữ liệu** bằng constructor hoặc arguments.  
- **await Navigator.push** → nhận dữ liệu trả về.  
- **Named routes** giúp quản lý nhiều màn hình dễ dàng.  
- **onGenerateRoute** = tuỳ chỉnh navigation nâng cao.  
- **Luôn kiểm tra mounted** trước khi navigate sau async.  
- **Dùng pushReplacement** cho Login → Home để tránh quay lại Login.

---

# 🎉 Kết thúc chương 06  
Tiếp theo, bạn sẽ học Form & Input — cốt lõi của mọi app thực tế:

👉 **Chương 07 – Form & Input (TextField, Validation, Keyboard)**

