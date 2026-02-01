# 📘 Hướng Dẫn Thực Hành Chi Tiết: Xây Dựng Todo App với Firebase

Tài liệu này hướng dẫn xây dựng ứng dụng Todo sử dụng **Cloud Firestore** làm cơ sở dữ liệu thời gian thực (Realtime Database).

> **Lưu ý quan trọng**: Khác với Mock API (chỉ cần code là chạy), Firebase yêu cầu bạn phải **Đăng ký dự án trên Google Console** và **Cấu hình (Configuration)** thì code mới chạy được.

---

## 🏗️ Phần 1: Khởi tạo & Cấu hình (Quan trọng nhất)

### Bước 1: Tạo dự án Flutter
```bash
flutter create demo_firebase
cd demo_firebase
```

### Bước 2: Cài đặt thư viện
Ta cần 2 thư viện chính:
1.  `firebase_core`: Lõi kết nối Firebase.
2.  `cloud_firestore`: Thư viện làm việc với Firestore Database.

```bash
flutter pub add firebase_core cloud_firestore
```

### Bước 3: Cấu hình Firebase (Bắt buộc phải làm thủ công)
Đây là bước bạn cần làm để App "nói chuyện" được với Server Google.

1.  **Cài Firebase CLI** (nếu chưa cài):
    ```bash
    npm install -g firebase-tools
    dart pub global activate flutterfire_cli
    ```
2.  **Đăng nhập Google**:
    ```bash
    firebase login
    ```
3.  **Tự động cấu hình**:
    Chạy lệnh này trong thư mục dự án:
    ```bash
    flutterfire configure
    ```
    *   Nó sẽ hỏi bạn chọn Project Firebase nào (hoặc tạo mới).
    *   Chọn platform (Android, iOS...).
    *   **Kết quả**: Nó tự tạo file `lib/firebase_options.dart`.

4.  **Sửa file `lib/main.dart`**:
    Import file vừa được sinh ra và khởi tạo trong hàm main.
    ```dart
    import 'firebase_options.dart'; // File do flutterfire sinh ra
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ```

---

---

## ☁️ Phần 1.5: Thiết lập Firestore Database trên Web Console

Đây là bước **BẮT BUỘC**, nếu không làm thì App sẽ bị lỗi "Permission Denied" hoặc "Not Found" khi chạy.

1.  **Truy cập Firebase Console**:
    *   Vào [console.firebase.google.com](https://console.firebase.google.com).
    *   Click vào dự án mà bạn vừa chọn (hoặc tạo) ở bước `flutterfire configure`.

2.  **Tạo Database**:
    *   Ở menu bên trái, mục **Build**, chọn **Firestore Database**.
    *   Click nút **Create database**.

3.  **Chọn chế độ bảo mật (Security Rules)**:
    *   Chọn **Start in test mode** (Chế độ thử nghiệm).
    *   *Giải thích*: Chế độ này cho phép đọc/ghi dữ liệu trong 30 ngày mà không cần đăng nhập. (Chỉ dùng khi dev, khi release sẽ chặn lại sau).
    *   Click **Next**.

4.  **Chọn vị trí Server (Location)**:
    *   Chọn server gần Việt Nam nhất (ví dụ `asia-southeast1` - Singapore) để App chạy nhanh.
    *   Click **Enable**.

5.  **Tạo Collection (Bảng dữ liệu)**:
    *   Sau khi tạo xong, bạn sẽ thấy giao diện Database trắng trơn.
    *   Click **Start collection**.
    *   **Collection ID**: Nhập chính xác chữ `todos` (viết thường, số nhiều).
        *   *Tại sao?*: Vì trong code Service ta đã viết `collection('todos')`. Nếu sai tên này code sẽ không tìm thấy dữ liệu.
    *   **Add first document**:
        *   Firebase bắt buộc tạo 1 bản ghi mẫu. Bạn có thể bấm **Auto-ID**.
        *   Th field (trường): `title` -> Value: `Test Firebase`.
        *   Thêm field: `completed` -> Type: `boolean` -> Value: `false`.
    *   Click **Save**.

👉 **Kết quả**: Bạn đã có bảng `todos` với 1 dòng dữ liệu mẫu. Giờ chạy App lên sẽ thấy dòng này hiện ra!

---

## 💻 Phần 2: Triển khai Code (Data Layer)

### Bước 4: Tạo Model (`lib/models/todo.dart`)
Khác với API dùng `int id`, Firestore dùng `String id` (chuỗi ngẫu nhiên do Firebase sinh ra).

**Code:**
```dart
class Todo {
  final String id;        // ID chuỗi (vd: "xZy9...")
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, required this.completed});

  // Convert Firestore Document -> Object
  factory Todo.fromFirestore(Map<String, dynamic> data, String id) {
    return Todo(
      id: id,
      title: data['title'] ?? '',
      completed: data['completed'] ?? false,
    );
  }

  // Convert Object -> Map (để lưu lên DB)
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}
```

---

## 🌐 Phần 3: Triển khai Code (Service Layer)

### Bước 5: Tạo Service (`lib/services/firestore_service.dart`)
Sử dụng `Stream` (Luồng dữ liệu) thay vì `Future`.  
*   **Future**: Gọi 1 lần trả về 1 lần (như REST API).
*   **Stream**: Gọi 1 lần, nhưng kết nối mở liên tục. Hễ DB thay đổi (ai đó thêm/sửa/xóa), App tự động nhận được data mới mà không cần refresh.

**Code:**
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class FirestoreService {
  final CollectionReference _todoCollection =
      FirebaseFirestore.instance.collection('todos'); // Tên bảng là 'todos'

  // 1. Lấy danh sách (Stream - Realtime)
  Stream<List<Todo>> getTodos() {
    return _todoCollection.snapshots().map((snapshot) {
      // snapshot chứa tất cả docs tại thời điểm đó
      return snapshot.docs.map((doc) {
        // Chuyển từng doc thành Todo Object
        return Todo.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // 2. Thêm mới
  Future<void> addTodo(String title) async {
    await _todoCollection.add({
      'title': title,
      'completed': false, // Mặc định chưa xong
    });
  }

  // 3. Cập nhật
  Future<void> updateTodoStatus(String id, bool status) async {
    await _todoCollection.doc(id).update({'completed': status});
  }

  // 4. Xóa
  Future<void> deleteTodo(String id) async {
    await _todoCollection.doc(id).delete();
  }
}
```

---

## 📱 Phần 4: Triển khai Code (UI Layer)

### Bước 6: Tạo Màn hình chính (`lib/screens/todo_screen.dart`)
Thay vì `FutureBuilder`, ta dùng **`StreamBuilder`**. Đây là widget "linh hồn" khi làm việc với Firebase. Nó tự động vẽ lại UI mỗi khi DB thay đổi.

**Code chính:**
```dart
StreamBuilder<List<Todo>>(
  stream: FirestoreService().getTodos(), // Lắng nghe luồng dữ liệu
  builder: (context, snapshot) {
    // 1. Kiểm tra lỗi
    if (snapshot.hasError) return Text('Lỗi: ${snapshot.error}');

    // 2. Đang chờ kết nối ban đầu
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    // 3. Có dữ liệu
    final todos = snapshot.data ?? [];
    
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          title: Text(todo.title),
          leading: Checkbox(
            value: todo.completed,
            onChanged: (val) {
              // Cập nhật lên Cloud -> Stream tự đẩy dữ liệu mới về -> UI tự update
              FirestoreService().updateTodoStatus(todo.id, val!);
            },
          ),
          // ...
        );
      },
    );
  },
)
```

**Chú ý:** Ta không cần `setState` thủ công khi thêm/sửa/xóa nữa!
*   Khi bạn gọi `addTodo`, dữ liệu lên Cloud.
*   Cloud báo về Stream: "Có item mới này".
*   `StreamBuilder` nhận được -> Tự `setState` bên trong -> UI hiển thị item mới.
*   (Magic of Firebase ✨)

---

## ✅ Tổng kết sự khác biệt

| Đặc điểm | REST API (Dự án trước) | Firebase Firestore (Dự án này) |
| :--- | :--- | :--- |
| **Dữ liệu** | Phải Pull (Gọi `get` mới có) | Realtime Push (Tự đẩy về khi có thay đổi) |
| **Widget** | `FutureBuilder` | `StreamBuilder` |
| **Cập nhật UI** | Phải dùng `setState` thủ công | Tự động cập nhật |
| **ID** | Thường là Số (`int`) | Chuỗi ngẫu nhiên (`String`) |
| **Cấu hình** | Không cần | Rất phức tạp (google-services.json...) |

---

## ⚠️ Lưu ý khi chạy lần đầu
Vì tôi đã tạo sẵn code nhưng **chưa thể chạy `flutterfire configure`** (do cần đăng nhập Google của bạn), bạn cần làm bước Cấu hình (Bước 3) thì app mới chạy được nhé!
