# 🟦 CHƯƠNG 18
# **BÀI TẬP LỚN: ỨNG DỤNG ĐA NGUỒN DỮ LIỆU (MULTI-SOURCE APP)**
*(Áp dụng Repository Pattern để chuyển đổi giữa Mock API, Firebase và Laravel)*

---

# 1. Giới thiệu bài toán

Trong thực tế, một ứng dụng có thể cần thay đổi Backend mà không muốn viết lại toàn bộ code logic hay giao diện. Hoặc đơn giản là bạn muốn có chế độ "Offline" (lưu local) và "Online" (lưu server).

**Yêu cầu:** Xây dựng ứng dụng **Todo App** có khả năng chuyển đổi nguồn dữ liệu (Data Source) ngay trong cài đặt (Settings) mà không cần build lại app.

**3 Nguồn dữ liệu cần hỗ trợ:**
1.  **Mock API**: `jsonplaceholder.typicode.com` (Dùng để test nhanh).
2.  **Firebase Firestore**: Dữ liệu thời gian thực (Realtime).
3.  **Laravel API**: Server tự host (Self-hosted).

---

# 2. Kiến thức trọng tâm: Repository Pattern

Để làm được việc "thay lõi" mà "vỏ" (UI) không đổi, ta cần áp dụng **Repository Pattern**.

**Tư duy:** UI không được gọi trực tiếp `http.get` hay `Firestore.instance`. UI chỉ được gọi thông qua một "Hợp đồng" (Interface/Abstract Class).

```mermaid
graph TD
    UI[Màn hình Todo] --> |Gọi hàm| Interface[TodoRepository (Abstract)]
    Interface --> |Impl 1| Mock[MockApiRepository]
    Interface --> |Impl 2| Fire[FirebaseRepository]
    Interface --> |Impl 3| Lara[LaravelRepository]
```

---

# 3. Yêu cầu chi tiết từng bước

## Bước 1: Định nghĩa "Hợp đồng" (Abstract Class)
Tạo file `lib/repositories/todo_repository.dart`.
Tất cả các kho dữ liệu bắt buộc phải tuân thủ cấu trúc này:

```dart
import '../models/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> addTodo(String title);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}
```

## Bước 2: Triển khai các "Nhà thầu" (Concrete Classes)

### 2.1. MockApiRepository
Copy logic từ chương 10, nhưng sửa lại để `implements TodoRepository`.

```dart
class MockApiRepository implements TodoRepository {
  @override
  Future<List<Todo>> getTodos() async {
    // Code gọi jsonplaceholder...
  }
  // ...
}
```

### 2.2. FirebaseRepository
Copy logic từ chương 12 (Service), sửa lại để `implements TodoRepository`.
*Lưu ý: Vì Firebase dùng Stream, nhưng Interface lại trả về Future (để đồng nhất với HTTP), bạn có thể dùng `get()` thay vì `snapshots()` cho bài tập này.*

### 2.3. LaravelRepository
Copy logic từ chương 17, sửa lại để `implements TodoRepository`.

## Bước 3: Quản lý Dependency (Dependency Injection)
Sử dụng **Provider** (hoặc Riverpod/GetIt) để cấp phát Repository cho toàn bộ App.

Trong `main.dart`:
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        // Mặc định chạy Mock API
        ProxyProvider0<TodoRepository>(
          update: (_, __) => MockApiRepository(), 
        ),
      ],
      child: MyApp(),
    ),
  );
}
```

## Bước 4: Xây dựng màn hình Settings
Tạo màn hình cho phép người dùng chọn nguồn dữ liệu.

*   Sử dụng `DropdownButton` với 3 lựa chọn: "Mock API", "Firebase", "Laravel".
*   Khi người dùng chọn xong -> Cập nhật lại Provider -> App tự động reload dữ liệu từ nguồn mới.

---

# 4. Gợi ý cấu trúc thư mục (Clean Architecture cơ bản)

```
lib/
├── models/
│   └── todo.dart
├── repositories/
│   ├── todo_repository.dart       <-- Cốt lõi (Abstract)
│   ├── mock_api_repository.dart   <-- Impl 1
│   ├── firebase_repository.dart   <-- Impl 2
│   └── laravel_repository.dart    <-- Impl 3
├── viewmodels/ (hoặc providers/)
│   └── todo_viewmodel.dart        <-- Logic quản lý State & gọi Repository
└── views/
    ├── todo_screen.dart           <-- UI hiển thị danh sách
    └── settings_screen.dart       <-- UI chọn nguồn dữ liệu
```

---

# 5. Thử thách nâng cao (Bonus)

1.  **Đồng bộ hóa (Sync)**:
    *   Khi đang dùng Mock API (hoặc Local DB), người dùng bấm nút "Sync to Firebase".
    *   App sẽ đọc hết dữ liệu từ Mock/Local -> Gửi lên Firebase.

2.  **Fallback (Tự động chuyển nguồn)**:
    *   Khi mất mạng (No Internet) -> Tự động chuyển sang dùng **SQLite** (Local).
    *   Khi có mạng lại -> Tự động chuyển sang **Laravel API**.

3.  **Authentication**:
    *   Laravel: Login lấy Token (JWT).
    *   Firebase: Login bằng Google/Email.
    *   Yêu cầu: Khi chuyển nguồn, phải bắt đăng nhập lại tương ứng với nguồn đó.

---

# 📝 Đánh giá kết quả

Hoàn thành bài tập này nghĩa là bạn đã:
- [x] Hiểu sâu sắc về **OOP** (Interface/Polymorphism).
- [x] Nắm vững các mô hình kết nối mạng phổ biến nhất.
- [x] Có tư duy kiến trúc phần mềm (**Architecture**), không còn viết code lộn xộn (Spaghetti code).
- [x] Sẵn sàng để đi làm tại các công ty lớn (nơi thường dùng Mock để Dev và Real API để Prod).
