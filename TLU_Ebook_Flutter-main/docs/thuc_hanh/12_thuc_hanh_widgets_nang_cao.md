# 🟦 THỰC HÀNH CHƯƠNG 12: WIDGETS NÂNG CAO TRONG FLUTTER

> **📌 DÀNH CHO NGƯỜI MỚI BẮT ĐẦU**
> 
> Bài thực hành này sẽ giúp bạn làm quen và sử dụng các widget nâng cao nhưng cực kỳ phổ biến trong các ứng dụng Flutter thực tế, giúp giao diện của bạn trở nên chuyên nghiệp và tương tác hơn.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Sử dụng thành thạo `ListTile` và `Card` để tạo danh sách và khối nội dung đẹp mắt
- ✅ Hiển thị các loại `Dialog` (AlertDialog, SimpleDialog) và `BottomSheet`
- ✅ Dùng `SnackBar` để hiển thị thông báo ngắn gọn
- ✅ Xây dựng `Drawer` (menu bên cạnh) và `BottomNavigationBar` (menu dưới)
- ✅ Tùy chỉnh `AppBar` với các `actions` và `title` động
- ✅ Tránh các lỗi phổ biến khi làm việc với các widget này

---

## 📋 CHECKLIST CHUẨN BỊ

- [ ] Môi trường Flutter đã cài đặt (Chương 01)
- [ ] VS Code đã cài đặt các extension Flutter/Dart
- [ ] Một dự án Flutter mới (ví dụ: `my_advanced_widgets_app`)

---

## BƯỚC 1: KHỞI TẠO DỰ ÁN & CHUẨN BỊ CODE

1.  Mở Terminal/CMD và tạo một dự án Flutter mới:
    ```bash
    flutter create my_advanced_widgets_app
    cd my_advanced_widgets_app
    code . # Mở VS Code
    ```
2.  Mở file `lib/main.dart`. Xóa toàn bộ nội dung mặc định và thay bằng cấu trúc cơ bản sau để dễ thực hành:
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
          title: 'Advanced Widgets Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen(),
        );
      }
    }

    class HomeScreen extends StatefulWidget {
      const HomeScreen({super.key});

      @override
      State<HomeScreen> createState() => _HomeScreenState();
    }

    class _HomeScreenState extends State<HomeScreen> {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Widgets Nâng Cao'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                "Các ví dụ sẽ hiển thị ở đây:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Các bài tập sẽ được thêm vào đây
            ],
          ),
        );
      }
    }
    ```
3.  Chạy ứng dụng để đảm bảo mọi thứ hoạt động: `flutter run`.

---

## BƯỚC 2: THỰC HÀNH LISTTILE VÀ CARD

### 2.1. `ListTile` đơn giản
Thêm đoạn code sau vào dưới `const SizedBox(height: 10),` trong `_HomeScreenState` `body` `ListView`:

```dart
// --- Thực hành ListTile ---
Card(
  margin: const EdgeInsets.symmetric(vertical: 8),
  elevation: 2,
  child: ListTile(
    leading: const Icon(Icons.person, size: 40, color: Colors.blue),
    title: const Text('Nguyễn Văn A', style: TextStyle(fontWeight: FontWeight.bold)),
    subtitle: const Text('Sinh viên CNTT - Đại học ABC'),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã nhấn vào Nguyễn Văn A')),
      );
    },
  ),
),
const Divider(),
```

**Giải thích:**
-   `ListTile` là widget lý tưởng để tạo các hàng trong danh sách.
-   `leading`, `title`, `subtitle`, `trailing` là các vị trí cố định để đặt nội dung.
-   `onTap` xử lý sự kiện khi người dùng nhấn vào hàng.
-   `Card` được dùng để bọc `ListTile`, tạo hiệu ứng đổ bóng và bo góc đẹp mắt.

### 2.2. `ListTile` với `Switch` và `Checkbox`
Thêm đoạn code sau vào dưới `const Divider(),`:

```dart
// --- ListTile với Switch và Checkbox ---
SwitchListTile(
  title: const Text('Bật thông báo'),
  subtitle: const Text('Nhận thông báo từ ứng dụng'),
  value: true, // Giá trị thực tế sẽ từ state
  onChanged: (bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thông báo: $value')),
    );
    // Cập nhật state ở đây
  },
),
CheckboxListTile(
  title: const Text('Đã hoàn thành bài tập'),
  subtitle: const Text('Đánh dấu khi bạn hoàn thành'),
  value: false, // Giá trị thực tế sẽ từ state
  onChanged: (bool? value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hoàn thành: $value')),
    );
    // Cập nhật state ở đây
  },
),
const Divider(),
```

**Giải thích:**
-   `SwitchListTile` và `CheckboxListTile` là các biến thể của `ListTile` tích hợp sẵn `Switch` và `Checkbox`, rất tiện lợi cho màn hình cài đặt.

---

## BƯỚC 3: THỰC HÀNH DIALOG VÀ BOTTOMSHEET

### 3.1. `AlertDialog` (Xác nhận/Cảnh báo)
Thêm một `ElevatedButton` để kích hoạt `AlertDialog`:

```dart
// --- Thực hành AlertDialog ---
ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa mục này không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa thành công!')),
                );
                Navigator.of(context).pop(); // Đóng dialog
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  },
  child: const Text('Hiển thị AlertDialog'),
),
const SizedBox(height: 10),
```

**Giải thích:**
-   `showDialog` dùng để hiển thị một dialog.
-   `AlertDialog` có `title`, `content` và `actions` (các nút).
-   **Quan trọng:** Luôn gọi `Navigator.of(context).pop()` để đóng dialog sau khi xử lý xong.

### 3.2. `SimpleDialog` (Chọn lựa)
Thêm một `ElevatedButton` để kích hoạt `SimpleDialog`:

```dart
// --- Thực hành SimpleDialog ---
ElevatedButton(
  onPressed: () async {
    final String? selectedOption = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Chọn một tùy chọn'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Option 1');
              },
              child: const Text('Tùy chọn 1'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Option 2');
              },
              child: const Text('Tùy chọn 2'),
            ),
          ],
        );
      },
    );
    if (selectedOption != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn đã chọn: $selectedOption')),
      );
    }
  },
  child: const Text('Hiển thị SimpleDialog'),
),
const SizedBox(height: 10),
```

**Giải thích:**
-   `SimpleDialog` dùng để hiển thị danh sách các tùy chọn.
-   Dùng `await showDialog` để nhận giá trị trả về từ dialog.

### 3.3. `BottomSheet` (Menu từ dưới lên)
Thêm một `ElevatedButton` để kích hoạt `BottomSheet`:

```dart
// --- Thực hành BottomSheet ---
ElevatedButton(
  onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Chia sẻ'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã chọn: Chia sẻ')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Xóa'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã chọn: Xóa')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  },
  child: const Text('Hiển thị BottomSheet'),
),
const SizedBox(height: 10),
```

**Giải thích:**
-   `showModalBottomSheet` hiển thị menu từ dưới lên.
-   Rất phổ biến trong mobile app để hiển thị các tùy chọn nhanh.

---

## BƯỚC 4: THỰC HÀNH SNACKBAR

`SnackBar` là cách hiển thị thông báo ngắn gọn, không làm gián đoạn trải nghiệm người dùng.

Thêm một `ElevatedButton` để hiển thị `SnackBar`:

```dart
// --- Thực hành SnackBar ---
ElevatedButton(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đây là thông báo SnackBar'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Hủy',
          onPressed: () {
            // Xử lý khi nhấn nút Hủy
          },
        ),
      ),
    );
  },
  child: const Text('Hiển thị SnackBar'),
),
const SizedBox(height: 10),
```

**Giải thích:**
-   `SnackBar` hiển thị ở cuối màn hình.
-   Tự động ẩn sau `duration` hoặc khi người dùng vuốt.
-   Có thể thêm `action` để người dùng thực hiện hành động.

---

## BƯỚC 5: THỰC HÀNH DRAWER (MENU BÊN CẠNH)

`Drawer` là menu trượt từ bên trái, thường dùng cho navigation chính.

Thay thế `Scaffold` trong `HomeScreen` bằng:

```dart
Scaffold(
  appBar: AppBar(
    title: const Text('Widgets Nâng Cao'),
  ),
  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Trang chủ'),
          onTap: () {
            Navigator.pop(context); // Đóng drawer
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã chọn: Trang chủ')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Cài đặt'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã chọn: Cài đặt')),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Đăng xuất'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã chọn: Đăng xuất')),
            );
          },
        ),
      ],
    ),
  ),
  body: ListView(
    // ... (giữ nguyên body cũ)
  ),
),
```

**Giải thích:**
-   `Drawer` được đặt trong `Scaffold`.
-   Mở bằng cách vuốt từ bên trái hoặc nhấn icon menu trong `AppBar`.
-   `DrawerHeader` là phần header của drawer.

---

## BƯỚC 6: THỰC HÀNH BOTTOMNAVIGATIONBAR

`BottomNavigationBar` là menu ở dưới cùng, dùng để chuyển giữa các tab chính.

Thêm `bottomNavigationBar` vào `Scaffold`:

```dart
Scaffold(
  // ... (giữ nguyên appBar, drawer, body)
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: 0, // Index của tab đang được chọn
    onTap: (int index) {
      setState(() {
        // Cập nhật currentIndex và chuyển tab
        // currentIndex = index;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã chọn tab: $index')),
      );
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Trang chủ',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Tìm kiếm',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Cá nhân',
      ),
    ],
  ),
),
```

**Giải thích:**
-   `BottomNavigationBar` có tối đa 5 items.
-   Dùng `currentIndex` để quản lý tab đang được chọn.
-   `onTap` xử lý khi người dùng nhấn vào tab.

---

## BƯỚC 7: TÙY CHỈNH APPBAR

`AppBar` có thể tùy chỉnh với `actions`, `leading`, và `title` động.

Thay thế `AppBar` hiện tại bằng:

```dart
AppBar(
  title: const Text('Widgets Nâng Cao'),
  leading: IconButton(
    icon: const Icon(Icons.menu),
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã nhấn menu')),
      );
    },
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã nhấn tìm kiếm')),
        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.notifications),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã nhấn thông báo')),
        );
      },
    ),
    PopupMenuButton<String>(
      onSelected: (String value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã chọn: $value')),
        );
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'settings',
          child: Text('Cài đặt'),
        ),
        const PopupMenuItem<String>(
          value: 'about',
          child: Text('Giới thiệu'),
        ),
      ],
    ),
  ],
),
```

**Giải thích:**
-   `leading`: Widget ở bên trái (thường là menu hoặc back button).
-   `actions`: Danh sách các widget ở bên phải (thường là icon buttons).
-   `PopupMenuButton`: Menu popup khi nhấn vào icon.

---

## BÀI TẬP THỰC HÀNH

1.  **Tạo màn hình "Cài đặt":**
    -   Sử dụng `ListTile` và `SwitchListTile` để tạo các tùy chọn cài đặt (Dark Mode, Notifications, Language).
    -   Lưu trạng thái vào `SharedPreferences` (xem Chương 11).
2.  **Tạo màn hình "Danh sách sản phẩm":**
    -   Sử dụng `Card` và `ListTile` để hiển thị danh sách sản phẩm.
    -   Mỗi sản phẩm có `leading` (ảnh), `title` (tên), `subtitle` (giá), và `trailing` (nút thêm vào giỏ).
    -   Khi nhấn vào sản phẩm, hiển thị `BottomSheet` với thông tin chi tiết.
3.  **Tạo màn hình "Profile":**
    -   Sử dụng `Drawer` để điều hướng giữa các màn hình (Home, Profile, Settings).
    -   Sử dụng `BottomNavigationBar` để chuyển giữa các tab trong màn hình Profile (Thông tin, Đơn hàng, Yêu thích).
4.  **Tạo "Xác nhận xóa" với AlertDialog:**
    -   Khi người dùng nhấn nút xóa, hiển thị `AlertDialog` xác nhận.
    -   Nếu đồng ý, xóa item và hiển thị `SnackBar` thông báo thành công.
5.  **Tạo "Chọn ảnh" với SimpleDialog:**
    -   Hiển thị `SimpleDialog` với các tùy chọn: "Chụp ảnh", "Chọn từ thư viện", "Hủy".
    -   Xử lý từng tùy chọn và hiển thị kết quả bằng `SnackBar`.

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành tất cả bài tập, bạn nên:
- [ ] Sử dụng được `ListTile` và `Card` để tạo danh sách đẹp
- [ ] Hiển thị được `Dialog` và `BottomSheet`
- [ ] Dùng được `SnackBar` để thông báo
- [ ] Xây dựng được `Drawer` và `BottomNavigationBar`
- [ ] Tùy chỉnh được `AppBar` với actions

---

## 🎉 KẾT THÚC BÀI THỰC HÀNH CHƯƠNG 12

Bạn đã thực hành các widget nâng cao trong Flutter.
Đây là những widget bạn sẽ dùng rất nhiều trong các dự án thực tế!

👉 **Tiếp theo:** Bài 13 - Animation hoặc các bài nâng cao khác
