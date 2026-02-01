# 🟦 CHƯƠNG 17
# **XÂY DỰNG BACKEND LARAVEL + MYSQL CHO FLUTTER APP**

Trong các chương trước, chúng ta đã học cách kết nối Flutter với:
1.  **Mock API** (dữ liệu giả, không lưu trữ lâu dài).
2.  **Firebase** (NoSQL, realtime, đám mây).

Chương này sẽ hướng dẫn bạn xây dựng **Tự xây dựng Backend (Self-hosted Backend)** sử dụng công nghệ phổ biến nhất hiện nay: **Laravel (PHP Framework)** và **MySQL Database**.

---

# 🎯 MỤC TIÊU HỌC TẬP

- Tự tạo được API Server chuẩn RESTful bằng Laravel.
- Thiết kế cơ sở dữ liệu MySQL cho App Todo.
- Hiểu cách kết nối Flutter với Localhost (máy ảo Android/iOS).
- Xử lý các vấn đề đặc thù khi tự host API (CORS, IP, Emulator).

---

# 1. **Chuẩn bị môi trường (Backend)**

Để chạy được Laravel, máy bạn cần cài:
- **PHP** (qua XAMPP, Laragon hoặc Docker).
- **Composer** (bộ quản lý thư viện PHP).
- **MySQL** (đi kèm XAMPP/Laragon).

## Bước 1: Khởi tạo dự án Laravel
Mở Terminal/CMD tại thư mục muốn chứa Backend:

```bash
composer create-project laravel/laravel todo-backend
cd todo-backend
```

## Bước 2: Cấu hình Database
1.  Mở phpMyAdmin (hoặc tool quản lý DB), tạo database tên là `todo_app`.
2.  Mở file `.env` trong dự án Laravel, sửa thông tin kết nối:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=todo_app
DB_USERNAME=root
DB_PASSWORD=      # (Để trống nếu dùng XAMPP mặc định)
```

---

# 2. **Xây dựng Database & API**

## Bước 3: Tạo Migration & Model
Ta cần bảng `todos` với các cột tương ứng với App Flutter: `title` (string) và `completed` (boolean).

Chạy lệnh:
```bash
php artisan make:model Todo -m
```
*(Lệnh này tạo Model `Todo.php` và file Migration cùng lúc)*

Mở file Migration vừa tạo trong `database/migrations/xxxx_create_todos_table.php`, sửa hàm `up`:

```php
public function up()
{
    Schema::create('todos', function (Blueprint $table) {
        $table->id();
        $table->string('title');
        $table->boolean('completed')->default(false);
        $table->timestamps(); // Tạo created_at, updated_at
    });
}
```

Chạy lệnh để tạo bảng vào MySQL:
```bash
php artisan migrate
```

## Bước 4: Tạo Controller
Tạo Controller để xử lý logic:

```bash
php artisan make:controller TodoController --api
```
*(Cờ `--api` giúp tạo sẵn các hàm index, store, show, update, destroy)*

Mở `app/Http/Controllers/TodoController.php` và code:

```php
<?php

namespace App\Http\Controllers;

use App\Models\Todo;
use Illuminate\Http\Request;

class TodoController extends Controller
{
    // GET /api/todos
    public function index()
    {
        // Trả về danh sách mới nhất trước
        return Todo::orderBy('created_at', 'desc')->get();
    }

    // POST /api/todos
    public function store(Request $request)
    {
        // Validate dữ liệu
        $request->validate([
            'title' => 'required|string|max:255',
        ]);

        // Tạo mới
        $todo = Todo::create([
            'title' => $request->input('title'),
            'completed' => false,
        ]);

        return response()->json($todo, 201);
    }

    // PATCH/PUT /api/todos/{id}
    public function update(Request $request, string $id)
    {
        $todo = Todo::findOrFail($id);
        
        $todo->update($request->only(['title', 'completed']));

        return response()->json($todo);
    }

    // DELETE /api/todos/{id}
    public function destroy(string $id)
    {
        $todo = Todo::findOrFail($id);
        $todo->delete();

        return response()->json(['message' => 'Deleted successfully']);
    }
}
```

> **Lưu ý**: Đừng quên khai báo `$fillable` trong Model `app/Models/Todo.php`:
> ```php
> protected $fillable = ['title', 'completed'];
> ```

## Bước 5: Khai báo Routes
Mở `routes/api.php`:

```php
use App\Http\Controllers\TodoController;
use Illuminate\Support\Facades\Route;

Route::apiResource('todos', TodoController::class);
```

Kiểm tra lại xem API đã chạy chưa bằng lệnh:
```bash
php artisan serve
```
Server sẽ chạy tại `http://127.0.0.1:8000`.
Bạn có thể dùng Postman test thử `GET http://127.0.0.1:8000/api/todos`.

---

# 3. **Kết nối Flutter với Laravel API**

Quay lại dự án Flutter (`demo_http_api`). Ta chỉ cần sửa file `todo_service.dart`.

## Vấn đề quan trọng: Localhost trên Emulator
*   Trên máy tính, Localhost là `127.0.0.1` hoặc `localhost`.
*   Nhưng trên **Android Emulator**, `localhost` là bản thân cái điện thoại ảo đó.
*   Để gọi vào máy tính (nơi chạy Laravel), bạn phải dùng IP đặc biệt: **`10.0.2.2`**.
*   Trên **iOS Simulator**, vẫn dùng `127.0.0.1` được.

## Sửa file `lib/services/todo_service.dart`

```dart
import 'dart:io'; // Để check Platform
import 'package:flutter/foundation.dart'; // Để check kIsWeb

class TodoService {
  // Tự động chọn URL dựa trên thiết bị đang chạy
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api/todos';
    
    // Nếu chạy trên Android Emulator
    if (Platform.isAndroid) return 'http://10.0.2.2:8000/api/todos';
    
    // Nếu chạy trên iOS Simulator
    return 'http://127.0.0.1:8000/api/todos';
  }
  
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json', // Bắt buộc với Laravel để nó trả về JSON khi lỗi
  };

  // 1. Fetch Todos
  static Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(baseUrl), headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi: ${response.statusCode}');
    }
  }
  
  // ... Các hàm addTodo, update, delete sửa tương tự (thay baseUrl thành getter baseUrl)
}
```

## Chỉnh Model (`lib/models/todo.dart`)
Laravel mặc định trả về trường `id` là số (`int`) và `completed` là `0` hoặc `1` (TinyInt) chứ không phải `true`/`false` như JSONPlaceholder.
Cần cập nhật lại `fromJson` để xử lý linh hoạt:

```dart
factory Todo.fromJson(Map<String, dynamic> json) {
  return Todo(
    id: json['id'] as int,
    title: json['title'] as String,
    // Laravel MySQL trả về 1/0, ta convert sang bool
    completed: json['completed'] == 1 || json['completed'] == true,
  );
}
```

---

# 4. **Chạy thử trên thiết bị thật (Physical Device)**

Nếu bạn cắm điện thoại thật vào để chạy, `10.0.2.2` hay `127.0.0.1` đều không hoạt động.
Có 2 cách:

### Cách 1: Dùng chung Wifi (IP LAN)
1.  Laptop và điện thoại bắt chung Wifi.
2.  Xem IP Laptop (Windows: gõ `ipconfig`, Mac: `ifconfig`). Ví dụ: `192.168.1.5`.
3.  Chạy Laravel với host cụ thể:
    ```bash
    php artisan serve --host 0.0.0.0 --port 8000
    ```
4.  Sửa `baseUrl` trong Flutter thành `http://192.168.1.5:8000/api/todos`.

### Cách 2: Dùng Ngrok (Internet) - Khuyên dùng
Ngrok giúp public cái localhost của bạn ra internet.

1.  Tải Ngrok.
2.  Chạy lệnh: `ngrok http 8000`.
3.  Ngrok cấp cho bạn link dạng `https://xxxx-xxxx.ngrok.io`.
4.  Dùng link này làm `baseUrl` trong Flutter. Cách này chạy được mọi nơi (3G/4G đều được).

---

# 📝 Tổng kết

Tự xây dựng Backend cho phép bạn kiểm soát hoàn toàn dữ liệu. Với sự kết hợp **Flutter + Laravel**, bạn có một cặp đôi hoàn hảo: Flutter lo Frontend đẹp mượt, Laravel lo Backend mạnh mẽ, bảo mật.

### Checklist cần nhớ:
- [ ] Chạy XAMPP/MySQL.
- [ ] Chạy `php artisan serve`.
- [ ] Đổi `baseUrl` phù hợp (Android: `10.0.2.2`).
- [ ] Thêm header `Accept: application/json` để Laravel không trả về HTML khi lỗi.
- [ ] Xử lý kiểu dữ liệu `bool` vs `tinyint` (0/1).
