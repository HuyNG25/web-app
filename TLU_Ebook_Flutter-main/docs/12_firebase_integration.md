# 🟦 CHƯƠNG 12  
# **WIDGETS NÂNG CAO TRONG FLUTTER**  
*(ListTile – Card – Dialog – Drawer – BottomNavigationBar – SnackBar – AppBar nâng cao)*

Đến chương này, bạn đã có đủ nền tảng để xây một ứng dụng hoàn chỉnh.  
Giờ là lúc học những widget nâng cao nhưng cực kỳ *thực dụng*, dùng trong 90% ứng dụng Flutter hiện nay.

Chương này giúp bạn nâng cấp UI rõ rệt.

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn sẽ:

- Sử dụng ListTile, Card để tạo danh sách đẹp.  
- Hiển thị Dialog, AlertDialog, BottomSheet.  
- Dùng SnackBar để show thông báo.  
- Tạo Drawer (menu bên cạnh).  
- Tạo BottomNavigationBar như ứng dụng chuyên nghiệp.  
- Thao tác với AppBar nâng cao.

---

# 1. **ListTile – widget "đa năng" cho danh sách**

Dùng rất nhiều trong:

- danh sách sản phẩm  
- danh sách người dùng  
- danh sách cài đặt  
- menu chọn  

### Ví dụ:

```dart
ListTile(
  leading: const Icon(Icons.person),
  title: const Text("Nguyễn Văn A"),
  subtitle: const Text("Sinh viên CNTT"),
  trailing: const Icon(Icons.arrow_forward_ios),
  onTap: () {
    print("Clicked!");
  },
);
```

---

### 🧠 Giảng giải chi tiết: ListTile là gì?

**ListTile là gì?**

- Widget chuyên dụng để tạo **hàng trong danh sách**
- Có sẵn layout: leading (trái), title (giữa), trailing (phải)
- Tự động xử lý tap, ripple effect
- Rất phổ biến trong Material Design

**Cấu trúc ListTile:**

```
ListTile
├── leading (Widget) - Icon/ảnh bên trái
├── title (Widget) - Text chính
├── subtitle (Widget) - Text phụ (tùy chọn)
├── trailing (Widget) - Icon/nút bên phải
└── onTap (Function) - Xử lý khi nhấn
```

**Ví dụ minh họa từng bước:**

```dart
// ✅ ĐÚNG: ListTile đầy đủ
ListTile(
  // Leading: Icon/ảnh bên trái
  leading: CircleAvatar(
    child: Icon(Icons.person),
  ),
  
  // Title: Text chính
  title: Text("Nguyễn Văn A"),
  
  // Subtitle: Text phụ (tùy chọn)
  subtitle: Text("Sinh viên CNTT - Đại học ABC"),
  
  // Trailing: Icon/nút bên phải
  trailing: Icon(Icons.arrow_forward_ios, size: 16),
  
  // onTap: Xử lý khi nhấn
  onTap: () {
    print("Đã nhấn vào Nguyễn Văn A");
    // Navigate to detail screen
  },
)
```

**Các thuộc tính quan trọng:**

```dart
ListTile(
  // Bắt buộc
  title: Text("Title"),
  
  // Tùy chọn
  leading: Icon(Icons.star),           // Widget bên trái
  subtitle: Text("Subtitle"),          // Text phụ
  trailing: Icon(Icons.more_vert),     // Widget bên phải
  isThreeLine: false,                  // 3 dòng (title + 2 subtitle)
  dense: false,                        // Compact mode
  enabled: true,                       // Có thể nhấn không
  selected: false,                     // Trạng thái selected
  onTap: () {},                        // Xử lý tap
  onLongPress: () {},                  // Xử lý long press
)
```

**Ví dụ minh họa: ListTile với các biến thể**

```dart
// 1. ListTile đơn giản
ListTile(
  title: Text("Cài đặt"),
  leading: Icon(Icons.settings),
  onTap: () {},
)

// 2. ListTile với subtitle
ListTile(
  title: Text("Sản phẩm A"),
  subtitle: Text("Giá: 1.200.000đ"),
  leading: Image.network("https://..."),
  trailing: Icon(Icons.shopping_cart),
  onTap: () {},
)

// 3. ListTile 3 dòng
ListTile(
  title: Text("Bài viết dài"),
  subtitle: Text("Dòng 1\nDòng 2"),
  isThreeLine: true,
  leading: Icon(Icons.article),
)

// 4. ListTile với Switch
ListTile(
  title: Text("Bật thông báo"),
  trailing: Switch(
    value: isEnabled,
    onChanged: (value) {
      setState(() => isEnabled = value);
    },
  ),
)

// 5. ListTile với Checkbox
ListTile(
  title: Text("Hoàn thành"),
  leading: Checkbox(
    value: isCompleted,
    onChanged: (value) {
      setState(() => isCompleted = value ?? false);
    },
  ),
)
```

---

# 2. **Card – đóng gói giao diện thành khối đẹp mắt**

Ví dụ:

```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: const [
        Text("Sản phẩm X", style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        Text("Giá: 1.200.000đ"),
      ],
    ),
  ),
);
```

---

### 🧠 Giảng giải chi tiết: Card là gì?

**Card là gì?**

- Widget tạo **khối nội dung** có shadow (đổ bóng)
- Tạo cảm giác **nổi lên** so với background
- Phù hợp để nhóm thông tin liên quan
- Rất phổ biến trong Material Design

**Cấu trúc Card:**

```
Card
├── elevation (double) - Độ đổ bóng
├── shape (ShapeBorder) - Hình dạng (bo góc)
├── color (Color) - Màu nền
└── child (Widget) - Nội dung bên trong
```

**Ví dụ minh họa từng bước:**

```dart
// ✅ ĐÚNG: Card đầy đủ
Card(
  // Elevation: Độ đổ bóng (0-24)
  elevation: 4,  // Càng cao càng nổi
  
  // Shape: Hình dạng
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),  // Bo góc 12px
  ),
  
  // Color: Màu nền (tùy chọn)
  color: Colors.white,
  
  // Child: Nội dung
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text("Sản phẩm X"),
        Text("Giá: 1.200.000đ"),
      ],
    ),
  ),
)
```

**Các thuộc tính quan trọng:**

```dart
Card(
  elevation: 4,                    // Độ đổ bóng (0-24)
  margin: EdgeInsets.all(8),       // Khoảng cách bên ngoài
  shape: RoundedRectangleBorder(   // Hình dạng
    borderRadius: BorderRadius.circular(12),
  ),
  color: Colors.white,             // Màu nền
  shadowColor: Colors.black,      // Màu đổ bóng
  child: Widget(),                 // Nội dung
)
```

**Ví dụ minh họa: Card với các biến thể**

```dart
// 1. Card đơn giản
Card(
  child: ListTile(
    title: Text("Tiêu đề"),
    subtitle: Text("Nội dung"),
  ),
)

// 2. Card với elevation cao
Card(
  elevation: 8,  // Đổ bóng mạnh
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text("Nội dung"),
  ),
)

// 3. Card với border
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: Colors.grey, width: 1),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text("Card có viền"),
  ),
)

// 4. Card với màu nền
Card(
  color: Colors.blue[50],
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text("Card màu xanh nhạt"),
  ),
)

// 5. Card với ảnh
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    children: [
      Image.network("https://...", height: 200, fit: BoxFit.cover),
      Padding(
        padding: EdgeInsets.all(16),
        child: Text("Sản phẩm X"),
      ),
    ],
  ),
)
```

---

### 🎒 Ví dụ đời sống  
Card giống như "tấm thẻ thông tin" — gọn gàng, rõ ràng, dễ nhìn.

---

# 3. **Divider – đường kẻ ngăn cách**

```dart
Divider(color: Colors.grey[300]);
```

---

# 4. **ListView kết hợp ListTile – danh sách chuyên nghiệp**

```dart
ListView.builder(
  itemCount: users.length,
  itemBuilder: (context, index) {
    final user = users[index];
    return ListTile(
      leading: CircleAvatar(child: Text(user[0])),
      title: Text(user),
      subtitle: const Text("Click để xem chi tiết"),
    );
  },
);
```

---

# 5. **Dialog – hiển thị yêu cầu / cảnh báo**

## AlertDialog

```dart
showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text("Xác nhận"),
      content: const Text("Bạn có chắc chắn muốn xoá?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Huỷ"),
        ),
        ElevatedButton(
          onPressed: () {
            print("Đã xoá!");
            Navigator.pop(context);
          },
          child: const Text("Xoá"),
        ),
      ],
    );
  },
);
```

---

### 🧠 Giảng giải chi tiết: Dialog là gì?

**Dialog là gì?**

- Widget hiển thị **popup** trên màn hình hiện tại
- Chặn tương tác với màn hình phía sau
- Dùng để xác nhận, cảnh báo, chọn lựa
- Phải đóng bằng `Navigator.pop()`

**Cơ chế hoạt động:**

```
showDialog() được gọi
    ↓
Dialog xuất hiện (overlay trên màn hình)
    ↓
User tương tác với Dialog
    ↓
Navigator.pop() được gọi
    ↓
Dialog đóng
```

**Ví dụ minh họa từng bước:**

```dart
// BƯỚC 1: Gọi showDialog
showDialog(
  context: context,
  builder: (context) {
    // BƯỚC 2: Trả về AlertDialog
    return AlertDialog(
      // Title: Tiêu đề
      title: Text("Xác nhận"),
      
      // Content: Nội dung
      content: Text("Bạn có chắc chắn muốn xoá?"),
      
      // Actions: Các nút
      actions: [
        // Nút "Hủy"
        TextButton(
          onPressed: () {
            Navigator.pop(context);  // ← QUAN TRỌNG: Đóng dialog
          },
          child: Text("Huỷ"),
        ),
        
        // Nút "Xóa"
        ElevatedButton(
          onPressed: () {
            // Xử lý xóa
            deleteItem();
            Navigator.pop(context);  // ← QUAN TRỌNG: Đóng dialog
          },
          child: Text("Xoá"),
        ),
      ],
    );
  },
);
```

**Các loại Dialog:**

```dart
// 1. AlertDialog - Xác nhận/cảnh báo
AlertDialog(
  title: Text("Xác nhận"),
  content: Text("Bạn có chắc?"),
  actions: [...],
)

// 2. SimpleDialog - Chọn lựa
SimpleDialog(
  title: Text("Chọn màu"),
  children: [
    SimpleDialogOption(
      child: Text("Đỏ"),
      onPressed: () => Navigator.pop(context, "red"),
    ),
  ],
)

// 3. Custom Dialog - Tự thiết kế
Dialog(
  child: Container(
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Custom Dialog"),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Đóng"),
        ),
      ],
    ),
  ),
)
```

**Lưu ý quan trọng:**

- **LUÔN gọi Navigator.pop()** để đóng dialog
- **Không quên context** khi gọi Navigator.pop()
- **Có thể trả về giá trị** từ dialog: `Navigator.pop(context, "result")`

---

## SimpleDialog

```dart
showDialog(
  context: context,
  builder: (context) => SimpleDialog(
    title: const Text("Chọn màu"),
    children: [
      SimpleDialogOption(
        child: const Text("Đỏ"),
        onPressed: () => Navigator.pop(context, "red"),
      ),
    ],
  ),
);
```

---

### 🧠 Giảng giải chi tiết: SimpleDialog

**SimpleDialog là gì?**

- Dialog đơn giản để **chọn lựa** từ danh sách
- Mỗi lựa chọn là một `SimpleDialogOption`
- Có thể trả về giá trị khi đóng

**Ví dụ minh họa:**

```dart
// Hiển thị SimpleDialog
Future<String?> showColorDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text("Chọn màu"),
      children: [
        SimpleDialogOption(
          child: Text("Đỏ"),
          onPressed: () {
            Navigator.pop(context, "red");  // ← Trả về "red"
          },
        ),
        SimpleDialogOption(
          child: Text("Xanh"),
          onPressed: () {
            Navigator.pop(context, "blue");  // ← Trả về "blue"
          },
        ),
        SimpleDialogOption(
          child: Text("Vàng"),
          onPressed: () {
            Navigator.pop(context, "yellow");  // ← Trả về "yellow"
          },
        ),
      ],
    ),
  );
}

// Sử dụng:
final color = await showColorDialog(context);
if (color != null) {
  print("Đã chọn màu: $color");
}
```

---

# 6. **BottomSheet – menu kéo từ dưới lên**

### ModalBottomSheet:

```dart
showModalBottomSheet(
  context: context,
  builder: (context) {
    return SizedBox(
      height: 200,
      child: Center(child: Text("Nội dung của BottomSheet")),
    );
  },
);
```

---

### 🧠 Giảng giải chi tiết: BottomSheet là gì?

**BottomSheet là gì?**

- Menu **kéo từ dưới lên** màn hình
- Hiển thị các tùy chọn nhanh
- Rất phổ biến trong mobile apps
- Có 2 loại: Modal và Persistent

**Cơ chế hoạt động:**

```
showModalBottomSheet() được gọi
    ↓
BottomSheet xuất hiện từ dưới lên
    ↓
User tương tác hoặc swipe down
    ↓
Navigator.pop() được gọi
    ↓
BottomSheet đóng
```

**Ví dụ minh họa từng bước:**

```dart
// ✅ ĐÚNG: ModalBottomSheet đầy đủ
showModalBottomSheet(
  context: context,
  // Shape: Hình dạng (bo góc trên)
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Handle bar (thanh kéo)
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          Text("Chọn hành động", style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Chỉnh sửa"),
            onTap: () {
              Navigator.pop(context);
              // Xử lý chỉnh sửa
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text("Xóa"),
            onTap: () {
              Navigator.pop(context);
              // Xử lý xóa
            },
          ),
        ],
      ),
    );
  },
);
```

**Các thuộc tính quan trọng:**

```dart
showModalBottomSheet(
  context: context,
  isDismissible: true,              // Có thể đóng bằng tap bên ngoài
  enableDrag: true,                 // Có thể kéo để đóng
  shape: RoundedRectangleBorder(   // Hình dạng
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  backgroundColor: Colors.white,   // Màu nền
  builder: (context) => Widget(),  // Nội dung
)
```

**Ví dụ minh họa: BottomSheet với các biến thể**

```dart
// 1. BottomSheet đơn giản
showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    height: 200,
    child: Center(child: Text("Nội dung")),
  ),
)

// 2. BottomSheet với ListView
showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    child: ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
          onTap: () {
            Navigator.pop(context);
            // Xử lý
          },
        );
      },
    ),
  ),
)

// 3. BottomSheet full screen
showModalBottomSheet(
  context: context,
  isScrollControlled: true,  // ← Cho phép full screen
  builder: (context) => Container(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Column(
      children: [
        // Handle bar
        Container(...),
        // Nội dung
        Expanded(child: ...),
      ],
    ),
  ),
)
```

---

# 7. **SnackBar – thông báo nhanh**

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text("Đã lưu thành công!"),
    duration: Duration(seconds: 2),
  ),
);
```

---

### 🧠 Giảng giải chi tiết: SnackBar là gì?

**SnackBar là gì?**

- Thông báo **ngắn gọn** xuất hiện ở dưới màn hình
- Tự động ẩn sau vài giây
- Không chặn tương tác với app
- Rất phổ biến để hiển thị kết quả action

**Cơ chế hoạt động:**

```
ScaffoldMessenger.showSnackBar() được gọi
    ↓
SnackBar xuất hiện ở dưới màn hình
    ↓
Hiển thị trong duration (mặc định 4 giây)
    ↓
Tự động ẩn hoặc user swipe để đóng
```

**Ví dụ minh họa từng bước:**

```dart
// ✅ ĐÚNG: SnackBar đầy đủ
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    // Content: Nội dung
    content: Text("Đã lưu thành công!"),
    
    // Duration: Thời gian hiển thị
    duration: Duration(seconds: 2),
    
    // Background color: Màu nền
    backgroundColor: Colors.green,
    
    // Action: Nút hành động (tùy chọn)
    action: SnackBarAction(
      label: "Hoàn tác",
      textColor: Colors.white,
      onPressed: () {
        // Xử lý hoàn tác
      },
    ),
  ),
);
```

**Các thuộc tính quan trọng:**

```dart
SnackBar(
  content: Widget(),              // Nội dung (bắt buộc)
  duration: Duration(seconds: 4), // Thời gian hiển thị
  backgroundColor: Colors.black,  // Màu nền
  action: SnackBarAction(...),    // Nút hành động
  behavior: SnackBarBehavior.floating, // Floating mode
  shape: RoundedRectangleBorder(...), // Hình dạng
)
```

**Ví dụ minh họa: SnackBar với các biến thể**

```dart
// 1. SnackBar đơn giản
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("Đã lưu thành công!"),
  ),
)

// 2. SnackBar với action
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("Đã xóa item"),
    action: SnackBarAction(
      label: "Hoàn tác",
      onPressed: () {
        // Hoàn tác
      },
    ),
  ),
)

// 3. SnackBar với màu
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("Lỗi!"),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
  ),
)

// 4. SnackBar floating
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("Đã lưu"),
    behavior: SnackBarBehavior.floating,  // Nổi lên
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
)
```

---

# 8. **Drawer – menu kéo từ cạnh trái**

Rất phổ biến trong nhiều ứng dụng.

### Scaffold:

```dart
Scaffold(
  appBar: AppBar(title: const Text("Home")),
  drawer: Drawer(
    child: ListView(
      children: const [
        DrawerHeader(
          child: Text("Menu"),
        ),
        ListTile(title: Text("Trang chủ")),
        ListTile(title: Text("Cài đặt")),
      ],
    ),
  ),
);
```

---

### 🧠 Giảng giải chi tiết: Drawer là gì?

**Drawer là gì?**

- Menu **kéo từ cạnh trái** (hoặc phải) màn hình
- Chứa navigation, settings, profile
- Rất phổ biến trong Material Design apps
- Mở bằng cách swipe hoặc nhấn icon menu

**Cơ chế hoạt động:**

```
User swipe từ cạnh trái hoặc nhấn menu icon
    ↓
Drawer xuất hiện (kéo từ trái)
    ↓
User chọn item trong Drawer
    ↓
Navigate hoặc xử lý action
    ↓
Drawer tự động đóng
```

**Ví dụ minh họa từng bước:**

```dart
Scaffold(
  appBar: AppBar(
    title: Text("Home"),
    // Icon menu tự động xuất hiện khi có drawer
  ),
  drawer: Drawer(
    child: ListView(
      children: [
        // DrawerHeader: Phần đầu (avatar, tên)
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              SizedBox(height: 10),
              Text("Nguyễn Văn A", style: TextStyle(color: Colors.white)),
              Text("user@example.com", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        
        // Menu items
        ListTile(
          leading: Icon(Icons.home),
          title: Text("Trang chủ"),
          onTap: () {
            Navigator.pop(context);  // Đóng drawer
            // Navigate to home
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Cài đặt"),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Đăng xuất"),
          onTap: () {
            Navigator.pop(context);
            // Xử lý đăng xuất
          },
        ),
        
        // Divider
        Divider(),
        
        // About
        ListTile(
          leading: Icon(Icons.info),
          title: Text("Về ứng dụng"),
          onTap: () {
            Navigator.pop(context);
            // Show about dialog
          },
        ),
      ],
    ),
  ),
);
```

**Lưu ý quan trọng:**

- **LUÔN gọi Navigator.pop()** sau khi chọn item để đóng drawer
- **DrawerHeader** thường chứa thông tin user
- **Divider** để phân cách các nhóm menu

---

# 9. **BottomNavigationBar – tạo ứng dụng có nhiều tab**

Dùng cho:

- tab Home  
- tab Profile  
- tab Settings  
- tab Notification  

### Ví dụ:

```dart
class BottomNavApp extends StatefulWidget {
  const BottomNavApp({super.key});

  @override
  State<BottomNavApp> createState() => _BottomNavAppState();
}

class _BottomNavAppState extends State<BottomNavApp> {
  int index = 0;

  final screens = [
    const Center(child: Text("Home")),
    const Center(child: Text("Profile")),
    const Center(child: Text("Setting")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
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

### 🧠 Giảng giải chi tiết: BottomNavigationBar là gì?

**BottomNavigationBar là gì?**

- Thanh navigation **ở dưới màn hình**
- Chuyển đổi giữa các tab/màn hình chính
- Rất phổ biến trong mobile apps
- Tối đa 5 items (Material Design guideline)

**Cơ chế hoạt động:**

```
User nhấn vào tab
    ↓
onTap được gọi với index mới
    ↓
setState() để cập nhật currentIndex
    ↓
Body hiển thị màn hình tương ứng
```

**Ví dụ minh họa từng bước:**

```dart
class BottomNavApp extends StatefulWidget {
  @override
  State<BottomNavApp> createState() => _BottomNavAppState();
}

class _BottomNavAppState extends State<BottomNavApp> {
  // State: Index tab hiện tại
  int _currentIndex = 0;
  
  // Danh sách màn hình tương ứng với mỗi tab
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body: Hiển thị màn hình tương ứng với tab được chọn
      body: _screens[_currentIndex],
      
      // BottomNavigationBar: Thanh navigation dưới
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: Tab đang được chọn
        currentIndex: _currentIndex,
        
        // onTap: Xử lý khi nhấn tab
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // ← QUAN TRỌNG: Phải setState!
          });
        },
        
        // items: Danh sách các tab
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Tìm kiếm",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Cá nhân",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Cài đặt",
          ),
        ],
      ),
    );
  }
}
```

**Các thuộc tính quan trọng:**

```dart
BottomNavigationBar(
  currentIndex: 0,                    // Tab đang chọn
  onTap: (index) {},                  // Xử lý khi nhấn
  items: [...],                       // Danh sách tab
  type: BottomNavigationBarType.fixed, // Type: fixed hoặc shifting
  selectedItemColor: Colors.blue,     // Màu tab được chọn
  unselectedItemColor: Colors.grey,   // Màu tab không được chọn
  showSelectedLabels: true,           // Hiển thị label tab được chọn
  showUnselectedLabels: true,         // Hiển thị label tab không được chọn
)
```

**Ví dụ minh họa: BottomNavigationBar với các biến thể**

```dart
// 1. BottomNavigationBar đơn giản (3-4 items)
BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ],
)

// 2. BottomNavigationBar với badge (số thông báo)
BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: [
    BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(Icons.notifications),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text("3", style: TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
      label: "Thông báo",
    ),
  ],
)

// 3. BottomNavigationBar với type shifting (5 items)
BottomNavigationBar(
  type: BottomNavigationBarType.shifting,  // ← Type shifting
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
      backgroundColor: Colors.blue,
    ),
    // ... 4 items khác
  ],
)
```

---

# 10. **AppBar nâng cao – thêm actions, search, avatar**

```dart
AppBar(
  title: const Text("Sản phẩm"),
  actions: [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
    ),
    IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: () {},
    )
  ],
);
```

---

### 🧠 Giảng giải chi tiết: AppBar nâng cao

**AppBar là gì?**

- Thanh **phía trên màn hình** chứa title, actions
- Rất linh hoạt, có thể tùy chỉnh nhiều
- Tự động xử lý back button, drawer icon

**Cấu trúc AppBar:**

```
AppBar
├── leading (Widget) - Icon bên trái (back/drawer)
├── title (Widget) - Tiêu đề
├── actions (List<Widget>) - Các nút bên phải
└── flexibleSpace (Widget) - Không gian linh hoạt
```

**Ví dụ minh họa từng bước:**

```dart
AppBar(
  // Leading: Icon bên trái (tự động: back button hoặc drawer icon)
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () {
      Scaffold.of(context).openDrawer();
    },
  ),
  
  // Title: Tiêu đề
  title: Text("Sản phẩm"),
  
  // Actions: Các nút bên phải
  actions: [
    // Icon search
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        // Mở search
      },
    ),
    
    // Icon giỏ hàng với badge
    Stack(
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            // Mở giỏ hàng
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text("3", style: TextStyle(fontSize: 10)),
          ),
        ),
      ],
    ),
    
    // Avatar
    CircleAvatar(
      child: Icon(Icons.person),
    ),
  ],
)
```

**Các thuộc tính quan trọng:**

```dart
AppBar(
  title: Widget(),                    // Tiêu đề
  leading: Widget(),                  // Icon bên trái
  actions: [Widget()],                // Các nút bên phải
  backgroundColor: Colors.blue,       // Màu nền
  elevation: 4,                       // Độ đổ bóng
  centerTitle: false,                 // Căn giữa title
  flexibleSpace: Widget(),            // Không gian linh hoạt
  bottom: PreferredSize(...),         // Widget dưới AppBar
)
```

**Ví dụ minh họa: AppBar với các biến thể**

```dart
// 1. AppBar với search
AppBar(
  title: TextField(
    decoration: InputDecoration(
      hintText: "Tìm kiếm...",
      border: InputBorder.none,
    ),
  ),
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)

// 2. AppBar với TabBar
AppBar(
  title: Text("Home"),
  bottom: TabBar(
    tabs: [
      Tab(text: "Tab 1"),
      Tab(text: "Tab 2"),
    ],
  ),
)

// 3. AppBar với gradient
AppBar(
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.purple],
      ),
    ),
  ),
  title: Text("Gradient AppBar"),
)
```

---

# 11. **Sai vs Đúng (lỗi sinh viên hay mắc)**

## ❌ Sai: đặt ListView trong Column không Expanded → overflow  

---

### 🔍 Giảng giải chi tiết: Tại sao ListView trong Column cần Expanded?

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: ListView trong Column không Expanded
Column(
  children: [
    Text("Header"),
    ListView.builder(  // ← Lỗi! ListView không có giới hạn chiều cao
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(
        title: Text("Item $index"),
      ),
    ),
  ],
)

// Vấn đề:
// - ListView cần có giới hạn chiều cao
// - Column không giới hạn chiều cao của ListView
// → RenderFlex overflow error!
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Dùng Expanded
Column(
  children: [
    Text("Header"),
    Expanded(  // ← Expanded giới hạn chiều cao
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(
          title: Text("Item $index"),
        ),
      ),
    ),
  ],
)

// Hoặc dùng SizedBox với height cố định
Column(
  children: [
    Text("Header"),
    SizedBox(
      height: 400,  // ← Chiều cao cố định
      child: ListView.builder(...),
    ),
  ],
)
```

---

## ✔ Đúng:

```dart
Expanded(
  child: ListView(...)
)
```

---

## ❌ Sai: show Snackbar bằng Scaffold.of(context) trong bản Flutter mới  

---

### 🔍 Giảng giải chi tiết: Tại sao không dùng Scaffold.of(context)?

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Dùng Scaffold.of(context) (đã deprecated)
Scaffold.of(context).showSnackBar(
  SnackBar(content: Text("Hello")),
)

// Vấn đề:
// - Scaffold.of(context) đã bị deprecated
// - Có thể gây lỗi nếu không tìm thấy Scaffold
// - Không hoạt động tốt với Navigator
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Dùng ScaffoldMessenger
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text("Hello")),
)

// Lợi ích:
// - Hoạt động tốt với Navigator
// - Tự động tìm Scaffold gần nhất
// - Không bị lỗi khi không có Scaffold
```

---

## ✔ Đúng:

```dart
ScaffoldMessenger.of(context).showSnackBar(...)
```

---

## ❌ Sai: quên Navigator.pop() khi bấm nút trong Dialog  

---

### 🔍 Giảng giải chi tiết: Tại sao cần Navigator.pop()?

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Quên Navigator.pop()
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text("Xác nhận"),
    actions: [
      ElevatedButton(
        onPressed: () {
          deleteItem();  // ← Xóa item
          // Quên Navigator.pop()!
          // Dialog không đóng!
        },
        child: Text("Xóa"),
      ),
    ],
  ),
)

// Vấn đề:
// - Dialog không tự động đóng
// - User phải swipe để đóng
// - UX kém
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Có Navigator.pop()
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text("Xác nhận"),
    actions: [
      ElevatedButton(
        onPressed: () {
          deleteItem();
          Navigator.pop(context);  // ← QUAN TRỌNG: Đóng dialog
        },
        child: Text("Xóa"),
      ),
    ],
  ),
)
```

---

## ✔ Đúng: luôn đóng dialog trước khi xử lý tiếp

---

## ❌ Sai: BottomNavigationBar không thay đổi tab  
→ quên setState

---

### 🔍 Giảng giải chi tiết: Tại sao cần setState?

**Ví dụ minh họa lỗi:**

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex = index;  // ← Quên setState!
          // Tab không đổi!
        },
        items: [...],
      ),
    );
  }
}

// Vấn đề:
// - State thay đổi nhưng không gọi setState
// - UI không rebuild
// - Tab không đổi
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Có setState
onTap: (index) {
  setState(() {
    _currentIndex = index;  // ← Có setState!
  });
}
```

---

## 🔴 Case Study: Các lỗi khác thường gặp

### Case Study 1: ListView trong SingleChildScrollView

#### ❌ Vấn đề:

```dart
SingleChildScrollView(
  child: Column(
    children: [
      Text("Header"),
      ListView.builder(  // ← Lỗi! ListView trong ScrollView
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(...),
      ),
    ],
  ),
)
```

#### ✅ Giải pháp:

```dart
// Dùng ListView với header
ListView(
  children: [
    Text("Header"),
    ...items.map((item) => ListTile(...)),
  ],
)

// Hoặc dùng CustomScrollView với SliverList
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(child: Text("Header")),
    SliverList(
      delegate: SliverChildBuilderDelegate(...),
    ),
  ],
)
```

---

### Case Study 2: Dialog không đóng khi nhấn bên ngoài

#### ❌ Vấn đề:

```dart
showDialog(
  context: context,
  barrierDismissible: false,  // ← Không cho đóng bằng tap bên ngoài
  builder: (context) => AlertDialog(...),
)
```

#### ✅ Giải pháp:

```dart
showDialog(
  context: context,
  barrierDismissible: true,  // ← Cho phép đóng bằng tap bên ngoài
  builder: (context) => AlertDialog(...),
)
```

---

### Case Study 3: BottomSheet quá cao che màn hình

#### ❌ Vấn đề:

```dart
showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    height: 1000,  // ← Quá cao!
    child: ...,
  ),
)
```

#### ✅ Giải pháp:

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,  // ← Cho phép scroll
  builder: (context) => Container(
    height: MediaQuery.of(context).size.height * 0.8,  // 80% màn hình
    child: ...,
  ),
)
```

---

# 12. **Các ví dụ thực tế đa dạng**

## 12.1. **Ví dụ: Danh sách sản phẩm với Card + ListTile**

```dart
class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(name: "Laptop", price: 15000000, image: "https://..."),
    Product(name: "Phone", price: 8000000, image: "https://..."),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sản phẩm")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Image.network(product.image, width: 60, height: 60),
              title: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${product.price.toStringAsFixed(0)} đ"),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Đã thêm ${product.name} vào giỏ")),
                  );
                },
              ),
              onTap: () {
                // Navigate to product detail
              },
            ),
          );
        },
      ),
    );
  }
}
```

---

## 12.2. **Ví dụ: Dialog xác nhận xóa với AlertDialog**

```dart
Future<bool?> showDeleteConfirmDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Xác nhận xóa"),
      content: Text("Bạn có chắc chắn muốn xóa item này?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),  // Hủy
          child: Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),  // Xóa
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("Xóa", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

// Sử dụng:
final result = await showDeleteConfirmDialog(context);
if (result == true) {
  // Xóa item
  deleteItem();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Đã xóa thành công")),
  );
}
```

---

## 12.3. **Ví dụ: BottomSheet chọn hành động**

```dart
void showActionBottomSheet(BuildContext context, Item item) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          
          // Actions
          ListTile(
            leading: Icon(Icons.edit, color: Colors.blue),
            title: Text("Chỉnh sửa"),
            onTap: () {
              Navigator.pop(context);
              // Navigate to edit screen
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: Colors.green),
            title: Text("Chia sẻ"),
            onTap: () {
              Navigator.pop(context);
              // Share item
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("Xóa"),
            onTap: () {
              Navigator.pop(context);
              // Show delete confirm dialog
              showDeleteConfirmDialog(context);
            },
          ),
        ],
      ),
    ),
  );
}
```

---

## 12.4. **Ví dụ: Drawer menu hoàn chỉnh**

```dart
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: Drawer(
        child: ListView(
          children: [
            // Header
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nguyễn Văn A",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "user@example.com",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            // Menu items
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Trang chủ"),
              onTap: () {
                Navigator.pop(context);
                // Already on home
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Hồ sơ"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Cài đặt"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
              },
            ),
            
            Divider(),
            
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Trợ giúp"),
              onTap: () {
                Navigator.pop(context);
                // Show help
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Về ứng dụng"),
              onTap: () {
                Navigator.pop(context);
                // Show about
              },
            ),
            
            Divider(),
            
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Đăng xuất", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                showLogoutConfirmDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text("Home Screen")),
    );
  }
}
```

---

## 12.5. **Ví dụ: BottomNavigationBar với nhiều tab**

```dart
class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Tìm kiếm",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "3",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            label: "Giỏ hàng",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Cá nhân",
          ),
        ],
      ),
    );
  }
}
```

---

## 12.6. **Ví dụ: AppBar với search và actions**

```dart
class ProductScreen extends StatefulWidget {
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Tìm kiếm...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            )
          : Text("Sản phẩm"),
        actions: [
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            )
          else
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to cart
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "3",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(...),
    );
  }
}
```

---

# 13. **Best Practices**

## 13.1. **Khi nào dùng widget nào?**

| Widget | Khi nào dùng | Ví dụ |
|--------|-------------|-------|
| **ListTile** | Danh sách items có icon, text | Menu, settings, user list |
| **Card** | Nhóm thông tin liên quan | Product card, info card |
| **Dialog** | Xác nhận, cảnh báo quan trọng | Delete confirm, error message |
| **BottomSheet** | Chọn hành động nhanh | Action menu, picker |
| **SnackBar** | Thông báo ngắn, không quan trọng | "Đã lưu", "Đã xóa" |
| **Drawer** | Navigation menu | Main menu, settings |
| **BottomNavigationBar** | Chuyển đổi tab chính | Home, Profile, Settings |

## 13.2. **Best Practices**

### 1. Luôn đóng Dialog/BottomSheet sau khi xử lý

```dart
// ✅ ĐÚNG
onPressed: () {
  deleteItem();
  Navigator.pop(context);  // Đóng dialog
}

// ❌ SAI
onPressed: () {
  deleteItem();
  // Quên Navigator.pop()
}
```

### 2. Dùng ScaffoldMessenger cho SnackBar

```dart
// ✅ ĐÚNG
ScaffoldMessenger.of(context).showSnackBar(...)

// ❌ SAI
Scaffold.of(context).showSnackBar(...)  // Deprecated
```

### 3. setState khi thay đổi BottomNavigationBar

```dart
// ✅ ĐÚNG
onTap: (index) {
  setState(() {
    _currentIndex = index;
  });
}

// ❌ SAI
onTap: (index) {
  _currentIndex = index;  // Quên setState
}
```

### 4. Dùng Expanded cho ListView trong Column

```dart
// ✅ ĐÚNG
Column(
  children: [
    Text("Header"),
    Expanded(child: ListView(...)),
  ],
)

// ❌ SAI
Column(
  children: [
    Text("Header"),
    ListView(...),  // Overflow!
  ],
)
```

### 5. Tối đa 5 items trong BottomNavigationBar

```dart
// ✅ ĐÚNG: 3-5 items
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(...),
    BottomNavigationBarItem(...),
    BottomNavigationBarItem(...),
  ],
)

// ❌ SAI: > 5 items (vi phạm Material Design)
```

---

# 14. **Bài tập thực hành**

1. Tạo danh sách người dùng bằng ListTile + ListView.  
2. Tạo Card sản phẩm đẹp (ảnh + tên + giá).  
3. Tạo Dialog xác nhận xóa item.  
4. Làm BottomSheet để chọn màu sắc hoặc theme.  
5. Tạo ứng dụng có 3 tab bằng BottomNavigationBar.  
6. Tạo Drawer menu giống ứng dụng Messenger.

---

# 15. Mini Test cuối chương

**Câu 1:** ListTile dùng để làm gì?  
→ tạo hàng danh sách có icon, text, subtitle.

**Câu 2:** BottomSheet xuất hiện từ đâu?  
→ kéo từ dưới màn hình lên.

**Câu 3:** SnackBar dùng khi nào?  
→ hiển thị thông báo ngắn.

**Câu 4:** Drawer nằm ở đâu?  
→ cạnh trái (hoặc phải) của màn hình.

**Câu 5:** BottomNavigationBar dùng để làm gì?  
→ tạo tab chuyển đổi màn hình.

**Câu 6:** Tại sao cần Navigator.pop() trong Dialog?  
→ Để đóng dialog sau khi xử lý action.

**Câu 7:** Tại sao ListView trong Column cần Expanded?  
→ ListView cần giới hạn chiều cao, Expanded cung cấp giới hạn đó.

**Câu 8:** ScaffoldMessenger vs Scaffold.of() khác nhau?  
→ ScaffoldMessenger là cách mới, Scaffold.of() đã deprecated.

**Câu 9:** Tại sao BottomNavigationBar cần setState?  
→ Để rebuild UI khi tab thay đổi.

**Câu 10:** Khi nào dùng Dialog vs BottomSheet?  
→ Dialog cho xác nhận quan trọng, BottomSheet cho chọn hành động nhanh.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **ListTile + Card** = giao diện danh sách đẹp và chuyên nghiệp.  
- **Dialog** = popup xác nhận / cảnh báo (AlertDialog, SimpleDialog).  
- **BottomSheet** = menu chọn nhanh từ dưới (showModalBottomSheet).  
- **SnackBar** = thông báo "nhẹ nhàng" (ScaffoldMessenger).  
- **Drawer** = menu cạnh bên (kéo từ trái/phải).  
- **BottomNavigationBar** = nhiều tab trong app (tối đa 5 items).  
- **AppBar** = thanh trên với title, actions, leading.  
- **Luôn Navigator.pop()** sau khi xử lý trong Dialog/BottomSheet.  
- **Luôn setState()** khi thay đổi BottomNavigationBar index.  
- **Dùng Expanded** cho ListView trong Column để tránh overflow.

---

# 🎉 Kết thúc chương 12  
Sẵn sàng để bước sang chương rất quan trọng cho app thực tế:

👉 **Chương 13 – Animation cơ bản (Tween, AnimatedContainer, AnimatedOpacity)**

