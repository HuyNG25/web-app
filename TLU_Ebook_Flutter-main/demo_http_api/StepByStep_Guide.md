# 📘 Hướng Dẫn Thực Hành Chi Tiết: Xây Dựng Todo REST API App

Tài liệu này sẽ hướng dẫn bạn từng bước từ con số 0 để xây dựng ứng dụng Todo kết nối với Mock API. Tài liệu được thiết kế để bạn vừa làm vừa hiểu (Learning by Doing).

---

## 🏗️ Phần 1: Khởi tạo Project

### Bước 1: Tạo dự án Flutter mới
Mở Terminal (hoặc Command Prompt) tại thư mục muốn chứa dự án và chạy:

```bash
flutter create demo_http_api
cd demo_http_api
```
*   **Ý nghĩa**: Lệnh `flutter create` sẽ sinh ra khung dự án chuẩn. `cd` để vào thư mục dự án vừa tạo.

### Bước 2: Cài đặt thư viện `http`
Thư viện `http` của Google là công cụ chuẩn để thực hiện các yêu cầu mạng.

```bash
flutter pub add http
```
*   **Ý nghĩa**: Lệnh này tự động thêm dòng `http: ^x.x.x` vào file cấu hình `pubspec.yaml` và tải thư viện về.

### Bước 3: Tạo cấu trúc thư mục
Để code gọn gàng, ta chia dự án thành 3 tầng (Layer). Hãy tạo các folder sau trong thư mục `lib/`:

```bash
lib/
├── models/    # Chứa khuôn mẫu dữ liệu
├── services/  # Chứa logic gọi API
└── screens/   # Chứa màn hình giao diện
```

---

## 💻 Phần 2: Triển khai Code (Data Layer)

### Bước 4: Tạo Model (`lib/models/todo.dart`)
**Mục tiêu**: Định nghĩa xem dữ liệu "Todo" gồm những thông tin gì. Mock API trả về JSON gồm: `id`, `title`, `completed`, `userId`.

**Code:**
```dart
class Todo {
  final int id;            // ID duy nhất của công việc
  final String title;      // Tên công việc
  bool completed;          // Trạng thái (Hoàn thành hay chưa)

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  // Factory Constructor: Biến JSON (từ Server) -> Hóa thành Object (trong App)
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }

  // Method toJson: Biến Object (trong App) -> Hóa thành JSON (để gửi lên Server)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}
```

---

## 🌐 Phần 3: Triển khai Code (Service Layer)

### Bước 5: Tạo Service (`lib/services/todo_service.dart`)
**Mục tiêu**: Viết các hàm chuyên biệt để giao tiếp với Server. UI không nên biết về URL hay HTTP, nó chỉ cần gọi "Service ơi, lấy dữ liệu cho tôi".

**Code:**
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart'; // Import model vừa tạo

class TodoService {
  // Đường dẫn API gốc. Ta dùng jsonplaceholder (Mock API miễn phí)
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';
  
  // Header báo cho server biết ta gửi dữ liệu định dạng JSON
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // 1. Lấy danh sách (GET Request)
  static Future<List<Todo>> fetchTodos() async {
    // Gọi GET lên URL. Thêm ?_limit=10 để lấy 10 cái đầu tiên thôi
    final response = await http.get(Uri.parse('$baseUrl?_limit=10'));

    if (response.statusCode == 200) { // 200 OK: Thành công
      final List<dynamic> body = jsonDecode(response.body); // Giải mã chuỗi JSON thành List
      return body.map((json) => Todo.fromJson(json)).toList(); // Chuyển từng item JSON thành Todo Object
    } else {
      throw Exception('Lỗi tải dữ liệu');
    }
  }

  // 2. Thêm mới (POST Request)
  static Future<Todo> addTodo(String title) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: jsonEncode({ // Đóng gói dữ liệu gửi đi
        'title': title,
        'completed': false, // Mặc định chưa làm xong
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) { // 201 Created: Tạo mới thành công
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Lỗi thêm mới');
    }
  }

  // 3. Cập nhật trạng thái (PATCH Request)
  static Future<Todo> updateTodoStatus(int id, bool status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'), // Gửi lệnh sửa vào đúng ID
      headers: _headers,
      body: jsonEncode({'completed': status}), // Chỉ gửi trường cần sửa
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Lỗi cập nhật');
    }
  }

  // 4. Xóa (DELETE Request)
  static Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) { // Nếu KHÔNG phải 200 -> Lỗi
      throw Exception('Lỗi xóa');
    }
  }
}
```

---

## 📱 Phần 4: Triển khai Code (UI Layer)

### Bước 6: Tạo Màn hình chính (`lib/screens/todo_screen.dart`)
**Mục tiêu**: Hiển thị danh sách và phản hồi thao tác người dùng. Đây là phần dài nhất.

**a. Khai báo State & initState:**
```dart
class TodoScreen extends StatefulWidget { ... }

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> _todos = []; // Biến lưu danh sách công việc hiển thị trên màn hình
  bool _isLoading = true; // Biến kiểm soát vòng quay loading

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Tự động tải dữ liệu khi màn hình vừa mở
  }
```

**b. Viết hàm `_loadTodos`:**
```dart
  Future<void> _loadTodos() async {
    try {
      final todos = await TodoService.fetchTodos(); // Gọi Service
      if (mounted) { // Kiểm tra màn hình còn đó không trước khi setState
        setState(() {
          _todos = todos; // Cập nhật danh sách
          _isLoading = false; // Tắt loading
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      // Xử lý lỗi (ví dụ hiện thông báo)
    }
  }
```

**c. Viết hàm `_processAddTodo` (Thêm công việc):**
```dart
  Future<void> _processAddTodo(String title) async {
    try {
      final newTodo = await TodoService.addTodo(title); // Gọi API thêm
      if (mounted) {
        setState(() {
          _todos.insert(0, newTodo); // Thêm item mới vào đầu danh sách hiển thị
        });
      }
    } catch (e) { ... }
  }
```

**d. Viết hàm `_processDeleteTodo` (Xóa - áp dụng Optimistic UI):**
```dart
  Future<void> _processDeleteTodo(int id) async {
    // 1. Tối ưu trải nghiệm: Xóa trên giao diện NGAY LẬP TỨC
    final index = _todos.indexWhere((e) => e.id == id);
    final backupItem = _todos[index]; // Lưu lại phòng khi lỗi
    setState(() => _todos.removeAt(index));

    // 2. Sau đó mới gọi API
    try {
      await TodoService.deleteTodo(id);
    } catch (e) {
      // 3. Nếu API lỗi -> Khôi phục lại item cũ (Undo)
      if (mounted) {
        setState(() => _todos.insert(index, backupItem));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi xóa!')));
      }
    }
  }
```

**e. Hàm `build` (Vẽ giao diện):**
*   Sử dụng `FutureBuilder` hoặc biến flag `_isLoading` để hiện `CircularProgressIndicator` khi đang tải.
*   Sử dụng `ListView.builder` để hiện danh sách dài.
*   Sử dụng `Dismissible` bọc lấy `ListTile` để tạo hiệu ứng "Vuốt để xóa".
*   Sử dụng `FloatingActionButton` để mở Dialog thêm mới.

*(Xem code đầy đủ trong file `lib/screens/todo_screen.dart` của dự án)*

---

## 🚀 Phần 5: Chạy ứng dụng

### Bước 7: Cập nhật `main.dart`
Khai báo `home: const TodoScreen()` để app khởi động vào màn hình này.

### Bước 8: Run
Gõ lệnh để chạy trên máy ảo hoặc thiết bị thật:
```bash
flutter run
```

---

## ✅ Tổng kết kiến thức
Qua bài thực hành này, bạn đã làm được:
1.  **Mô hình hóa dữ liệu**: Hiểu cách dùng `fromJson`/`toJson`.
2.  **Tách tầng Service**: Code UI sạch sẽ, logic API nằm riêng biệt.
3.  **HTTP Request**: Hiểu 4 phương thức cơ bản GET, POST, PATCH, DELETE.
4.  **Optimistic UI**: Kỹ thuật làm app tạo cảm giác "nhanh như điện" bằng cách cập nhật giao diện trước khi chờ Server phản hồi.

Chúc bạn code vui vẻ!
