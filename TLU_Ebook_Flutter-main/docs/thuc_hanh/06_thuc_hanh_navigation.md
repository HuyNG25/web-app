# 🟦 THỰC HÀNH CHI TIẾT: NAVIGATION (BÀI 06)

Tài liệu này giúp bạn làm chủ kỹ năng "điều hướng" (chuyển màn hình) trong Flutter.
Chúng ta sẽ đi từ **"bấm là chuyển"** đến **"chuyển có chủ đích, có dữ liệu"**.

> **⚠️ BẮT BUỘC:** Hãy gõ từng dòng code để hiểu cơ chế hoạt động. Đừng copy-paste!

---

## 🎯 MỤC TIÊU SẢN PHẨM
1.  **Level 1 (Dễ): Basic Switcher** - *Hiểu cơ chế Push/Pop (Ngăn xếp đĩa).*
2.  **Level 2 (Trung bình): Store Catalogue** - *Gửi dữ liệu đi (Constructor).*
3.  **Level 3 (Khó): User Settings** - *Nhận dữ liệu về (Await).*
4.  **Level 4 (Rất khó): App Drawer & Named Routes** - *Quản lý Navigation chuyên nghiệp.*

---

## 🛠️ CHUẨN BỊ
1.  Tạo dự án mới (hoặc dùng dự án nháp):
    ```bash
    flutter create thuc_hanh_nav
    cd thuc_hanh_nav
    ```
2.  Setup `main.dart` với khung sườn trống:

```dart
import 'package:flutter/material.dart';

// Import các file bài tập (bỏ comment dần khi làm)
// import 'bai1_basic.dart';
// import 'bai2_store.dart';
// import 'bai3_settings.dart';
// import 'bai4_drawer.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(child: Text("HÃY KHAI BÁO MÀN HÌNH Ở ĐÂY")),
    ),
  ));
}
```

---

## 🟢 LEVEL 1: BASIC SWITCHER (PUSH/POP)
**Mục tiêu:** Hiểu cơ chế Navigation Stack (Ngăn xếp).
**Tư duy:** Hãy tưởng tượng chồng đĩa.
- `Push`: Đặt thêm 1 cái đĩa lên trên (Màn mới đè lên màn cũ).
- `Pop`: Lấy cái đĩa trên cùng ra (Quay về màn cũ).

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai1_basic.dart`.

**Bước 2:** Nhập code.

```dart
import 'package:flutter/material.dart';

// --- MÀN HÌNH 1 ---
class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Màn hình 1 (Gốc)")),
      backgroundColor: Colors.blue[50], // Màu xanh nhạt
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, 
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text("Sang Màn hình 2 👉", style: TextStyle(fontSize: 18)),
          onPressed: () {
            // Lệnh chuyển màn hình: PUSH
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Screen2()),
            );
          },
        ),
      ),
    );
  }
}

// --- MÀN HÌNH 2 ---
class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Màn hình 2"),
        backgroundColor: Colors.orange, // Đổi màu AppBar để dễ nhận biết
      ),
      backgroundColor: Colors.orange[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Đây là màn hình 2", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
              child: const Text("👈 Quay lại (Pop)"),
              onPressed: () {
                // Lệnh quay về: POP
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `MaterialPageRoute`: Là hiệu ứng chuyển cảnh chuẩn của Android (trượt từ dưới lên hoặc từ trái sang).
> - `Navigator.push(context, route)`: Đẩy route mới vào Stack quản lý của context hiện tại.
> - `Navigator.pop(context)`: Hủy màn hình hiện tại, lộ ra màn hình bên dưới.

---

## 🟡 LEVEL 2: STORE CATALOGUE (TRUYỀN DỮ LIỆU)
**Mục tiêu:** Màn hình A gửi dữ liệu sang Màn hình B.
**Tư duy:** Giống như gửi thư, bạn cần ghi địa chỉ và bỏ nội dung vào phong bì. Ở đây, "phong bì" chính là **Constructor** của màn hình B.

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai2_store.dart`.

**Bước 2:** Tạo màn hình `ProductDetailScreen` (Người nhận).
Phải định nghĩa nó *trước* thì màn hình gửi mới gọi được.

```dart
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  // 1. Khai báo các biến sẽ nhận
  final String tenSanPham;
  final int gia;
  final String moTa;

  // 2. Constructor buộc phải có tham số (required)
  const ProductDetailScreen({
    super.key, 
    required this.tenSanPham, 
    required this.gia,
    this.moTa = "Sản phẩm chính hãng chất lượng cao.", // Giá trị mặc định
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tenSanPham)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container( // Giả lập ảnh sản phẩm
              height: 200, width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.shopping_bag, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            Text(tenSanPham, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("$gia VND", style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.w600)),
            const Divider(height: 30),
            Text("Mô tả: $moTa", style: const TextStyle(fontSize: 16)),
            
            const Spacer(), // Đẩy nút xuống đáy
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15), backgroundColor: Colors.blue),
                child: const Text("Quay lại", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

**Bước 3:** Tạo màn hình `StoreScreen` (Người gửi).

```dart
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data giả
    final products = ["iPhone 15", "Samsung S24", "Xiaomi 14"];
    final prices = [20000000, 18000000, 12000000];

    return Scaffold(
      appBar: AppBar(title: const Text("Cửa hàng điện thoại")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.phone_android)),
              title: Text(products[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${prices[index]} VND"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // --- CHUYỂN MÀN HÌNH KÈM DỮ LIỆU ---
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Gọi Constructor và truyền tham số vào
                    builder: (context) => ProductDetailScreen(
                      tenSanPham: products[index],
                      gia: prices[index],
                      // moTa: có thể bỏ qua vì đã có mặc định
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `required this.variable`: Bắt buộc người gọi phải truyền giá trị này.
> - `ListView.builder`: Tạo danh sách cuộn hiệu năng cao.
> - `Navigator.push... builder: ... ProductDetailScreen(...)`: Chính là lúc chúng ta nhét dữ liệu vào "phong bì" gửi đi.

---

## 🟠 LEVEL 3: USER SETTINGS (NHẬN DỮ LIỆU VỀ)
**Mục tiêu:** Màn hình A mở Màn hình B. Màn hình B làm gì đó xong trả kết quả về cho A.
**Tư duy:** `Navigator.push` là một hàm **Bat dong bo** (Future). Nó giống như bạn sai nhân viên đi mua cà phê, bạn phải ngồi đợi (`await`) nhân viên đó quay về với ly cà phê (`result`).

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai3_settings.dart`.

**Bước 2:** Màn hình nhập liệu `InputNameScreen` (Nơi xử lý và trả về).

```dart
import 'package:flutter/material.dart';

class InputNameScreen extends StatefulWidget {
  final String currentName; 
  const InputNameScreen({super.key, required this.currentName});

  @override
  State<InputNameScreen> createState() => _InputNameScreenState();
}

class _InputNameScreenState extends State<InputNameScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với giá trị cũ nhận được
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nhập tên mới")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Tên hiển thị",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              autofocus: true, // Tự động bật bàn phím
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Lưu thay đổi"),
              onPressed: () {
                // --- TRẢ DỮ LIỆU VỀ ---
                // Navigator.pop(context, [KẾT QUẢ])
                Navigator.pop(context, _controller.text);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

**Bước 3:** Màn hình chính `UserProfileScreen` (Nơi đợi kết quả).

```dart
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String myName = "Chưa có tên";

  // Hàm này phải là async vì phải đợi (await)
  void _editName() async {
    // 1. Chờ đợi (await) kết quả từ màn hình Input
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputNameScreen(currentName: myName),
      ),
    );

    // 2. Sau khi màn Input đóng lại, code mới chạy tiếp xuống đây
    print("Kết quả trả về: $result");

    // 3. Kiểm tra xem người dùng có bấm Save (có data) hay bấm Back (null)
    if (result != null) {
      setState(() {
        myName = result; // Cập nhật UI
      });
      // Hiện thông báo nhỏ (SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã cập nhật tên thành công!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin cá nhân")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            Text("Xin chào,", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            Text(myName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _editName, // Gọi hàm async ở trên
              child: const Text("Chỉnh sửa tên"),
            )
          ],
        ),
      ),
    );
  }
}
```

> **🧠 Giải thích code:**
> - `async/await`: Kỹ thuật bất đồng bộ. Nếu không có `await`, biến `result` sẽ chưa kịp có giá trị thì dòng `print` đã chạy rồi.
> - `ScaffoldMessenger`: Cách chuẩn để hiện thông báo nhảy lên từ đáy màn hình (SnackBar).

---

## 🔴 LEVEL 4: NAMED ROUTES & DRAWER
**Mục tiêu:** Quản lý Navigation tập trung, giống như file `web.php` trong Laravel hay `routes` trong Web.
**Tư duy:** Thay vì mỗi lần đi đâu cũng phải tạo `MaterialPageRoute`, ta chỉ cần gọi tên (VD: `'/settings'`).

### 📝 Hướng dẫn từng bước:

**Bước 1:** Tạo file `lib/bai4_drawer.dart`.

**Bước 2:** Code `MyDrawer` (Menu bên trái).

```dart
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Xóa padding mặc định để ảnh cover đẹp hơn
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Sinh Viên FITA"),
            accountEmail: Text("sv@vnua.edu.vn"),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Text("SV")),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Trang chủ"),
            onTap: () {
               // pushReplacementNamed: Đóng màn hình hiện tại và mở Home
               // Giúp tránh việc Stack bị chồng chất quà nhiều màn hình Home cũ
               Navigator.pushReplacementNamed(context, '/'); 
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Cài đặt"),
            onTap: () {
               // Chỉ push (đặt lên trên), để người dùng có thể bấm Back quay lại Home
               // Nhưng nhớ phải pop cái Drawer trước nếu không nó sẽ che mất
               Navigator.pop(context); // Đóng drawer
               Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
```

**Bước 3:** Định nghĩa các màn hình đơn giản.

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trang Chủ")),
      drawer: const MyDrawer(), // Gắn Drawer vào nút Menu góc trái
      body: const Center(child: Text("🏠 HOME SCREEN", style: TextStyle(fontSize: 24))),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cài Đặt")),
      body: const Center(child: Text("⚙️ SETTINGS SCREEN", style: TextStyle(fontSize: 24))),
    );
  }
}
```

**Bước 4:** Cấu hình `routes` trong `MaterialApp` (QUAN TRỌNG NHẤT).
Quay lại file `main.dart` hoặc tạo hàm main riêng:

```dart
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    
    // 1. Định nghĩa "Bản đồ" các đường dẫn
    initialRoute: '/', // Đường dẫn mặc định khi mở app
    routes: {
      '/': (context) => const HomeScreen(),
      '/settings': (context) => const SettingsScreen(),
    },
  ));
}
```

> **🧠 Giải thích code:**
> - `routes`: Là một Map (Từ điển). Khóa là tên đường dẫn (String), Giá trị là hàm trả về Widget.
> - `Drawer`: Widget menu trượt từ cạnh màn hình. Phải gán vào thuộc tính `drawer` của `Scaffold`.
> - `Navigator.pushReplacementNamed`: Rất quan trọng khi làm Menu. Bạn không muốn người dùng bấm mở Settings -> mở lại Home -> mở lại Settings -> Stack dày cộp 100 lớp. Hàm này giúp "tráo" màn hình hiện tại thành màn hình mới.

---

## 🏆 TỔNG KẾT
Bạn đã nắm được "xương sống" của luồng ứng dụng:
- Di chuyển (`push`/`pop`).
- Mang theo hành lý (`constructor params`).
- Chờ quà mang về (`await` + `result`).
- Bản đồ đường đi (`routes`).

Hãy áp dụng ngay vào bài tập lớn (Assignment) của bạn nhé! 🚀