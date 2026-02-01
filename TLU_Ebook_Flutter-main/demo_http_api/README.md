# 📱 Todo REST API Demo App

Đây là dự án thực hành mẫu minh họa cho chương **10_http_api** trong bộ tài liệu Flutter Mobile.
Dự án này xây dựng một ứng dụng Quản lý công việc (Todo App) hoàn chỉnh với đầy đủ các thao tác CRUD (Create, Read, Update, Delete) tương tác với Mock API.

## 📂 Cấu trúc dự án

Dự án được tổ chức theo kiến trúc phân tầng (Layered Architecture) đơn giản, giúp tách biệt logic và giao diện:

```
lib/
├── models/
│   └── todo.dart        # [Data Layer] Định nghĩa cấu trúc dữ liệu
├── services/
│   └── todo_service.dart # [Service Layer] Phụ trách giao tiếp API (HTTP)
├── screens/
│   └── todo_screen.dart  # [UI Layer] Giao diện và logic hiển thị
└── main.dart             # Entry point của ứng dụng
```

## 🛠️ Hướng dẫn chạy dự án

1.  **Cài đặt dependencies**:
    Mở terminal tại thư mục gốc của dự án (`demo_http_api`) và chạy:
    ```bash
    flutter pub get
    ```

2.  **Khởi chạy ứng dụng**:
    ```bash
    flutter run
    ```

---

## 🔍 Phân tích mã nguồn chi tiết

### 1. `lib/models/todo.dart` (Data Model)
Đây là bản thiết kế của đối tượng Todo.
*   **Vai trò**: Giúp chuyển đổi dữ liệu từ JSON (do Server trả về) thành Dart Object để dễ sử dụng trong code, và ngược lại.
*   **Điểm nhấn**:
    *   `fromJson`: Factory constructor giúp parse dữ liệu an toàn.
    *   `toJson`: Phương thức giúp đóng gói dữ liệu để gửi lên server.

### 2. `lib/services/todo_service.dart` (API Service)
Đây là "người vận chuyển", chịu trách nhiệm gửi và nhận dữ liệu.
*   **Base URL**: `https://jsonplaceholder.typicode.com/todos`
*   **Các hàm chính**:
    *   `fetchTodos()`: Dùng `http.get`. Lấy danh sách 10 công việc mẫu.
    *   `addTodo()`: Dùng `http.post`. Gửi title lên để tạo mới.
    *   `updateTodoStatus()`: Dùng `http.patch`. Cập nhật trạng thái hoàn thành.
    *   `deleteTodo()`: Dùng `http.delete`. Xóa công việc.
*   **Xử lý lỗi**: Sử dụng `try-catch` hoặc kiểm tra `statusCode` để `throw Exception` nếu có lỗi, giúp UI biết để hiển thị thông báo.

### 3. `lib/screens/todo_screen.dart` (User Interface)
Màn hình chính của ứng dụng.
*   **State Management**: Sử dụng `setState` cơ bản để cập nhật UI.
*   **Kỹ thuật Optimistic UI (Cập nhật lạc quan)**:
    *   Tại hàm `_processToggle` và `_processDeleteTodo`, UI được cập nhật **trước** khi gọi API.
    *   Nếu API lỗi, UI sẽ tự động hoàn tác (revert) về trạng thái cũ.
    *   -> Giúp app có cảm giác phản hồi tức thì, không độ trễ.
*   **Feedback người dùng**: Sử dụng `SnackBar` để thông báo thành công hoặc thất bại.
*   **RefreshIndicator**: Cho phép người dùng kéo xuống để tải lại danh sách.

---

## 🧪 Kịch bản kiểm thử (Test Cases)

Bạn có thể tự kiểm thử các chức năng sau khi chạy app:

1.  **Chức năng Xem (Read)**:
    *   Mở app, chờ loading quay.
    *   Thấy danh sách các công việc hiện ra -> ✅ OK.

2.  **Chức năng Thêm (Create)**:
    *   Bấm nút (+), nhập tên công việc, bấm "Thêm".
    *   Thấy công việc mới hiện lên đầu danh sách, có thông báo "Đã thêm..." -> ✅ OK.

3.  **Chức năng Sửa (Update)**:
    *   Click vào checkbox của một công việc.
    *   Thấy checkbox đổi trạng thái, chữ gạch ngang -> ✅ OK.

4.  **Chức năng Xóa (Delete)**:
    *   Vuốt một công việc sang trái.
    *   Thấy item biến mất, có thông báo "Đã xóa..." -> ✅ OK.

---

## 📚 Tài liệu tham khảo
*   Chi tiết lý thuyết xem tại: `docs/10_http_api.md`
*   Package HTTP: [pub.dev/packages/http](https://pub.dev/packages/http)
