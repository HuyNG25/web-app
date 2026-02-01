# 🟦 THỰC HÀNH CHƯƠNG 17: XÂY DỰNG BACKEND LARAVEL + MYSQL CHO FLUTTER APP

> **📌 DÀNH CHO NGƯỜI ĐÃ CÓ KINH NGHIỆM**
> 
> Bài thực hành này hướng dẫn cách xây dựng backend Laravel + MySQL và kết nối với Flutter app.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Tạo API Server bằng Laravel
- ✅ Thiết kế database MySQL
- ✅ Kết nối Flutter với Laravel API
- ✅ Xử lý CORS và các vấn đề kết nối

---

## 📋 CHECKLIST CHUẨN BỊ

Trước khi bắt đầu, đảm bảo bạn có:
- [ ] PHP đã cài đặt (qua XAMPP, Laragon, hoặc Docker)
- [ ] Composer đã cài đặt
- [ ] MySQL đã cài đặt
- [ ] Flutter app đã sẵn sàng

---

## BÀI TẬP 1: CÀI ĐẶT LARAVEL

### Mục đích
Cài đặt và cấu hình Laravel project.

### Yêu cầu

1. **Cài đặt Laravel:**
```bash
composer create-project laravel/laravel todo-backend
cd todo-backend
```

2. **Cấu hình database:**
Mở `.env` và sửa:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=todo_app
DB_USERNAME=root
DB_PASSWORD=
```

3. **Tạo database:**
- Mở phpMyAdmin hoặc MySQL client
- Tạo database tên `todo_app`

4. **Chạy Laravel:**
```bash
php artisan serve
```

Server chạy tại: `http://127.0.0.1:8000`

### Kết quả mong đợi
- Laravel project đã cài đặt
- Database đã cấu hình
- Server chạy thành công

---

## BÀI TẬP 2: TẠO MIGRATION VÀ MODEL

### Mục đích
Tạo bảng `todos` trong database.

### Yêu cầu

1. **Tạo Model và Migration:**
```bash
php artisan make:model Todo -m
```

2. **Sửa Migration:**
Mở `database/migrations/xxxx_create_todos_table.php`:
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('todos', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->boolean('completed')->default(false);
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('todos');
    }
};
```

3. **Chạy Migration:**
```bash
php artisan migrate
```

4. **Cấu hình Model:**
Mở `app/Models/Todo.php`:
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Todo extends Model
{
    use HasFactory;
    
    protected $fillable = ['title', 'completed'];
}
```

### Kết quả mong đợi
- Bảng `todos` đã được tạo
- Model đã cấu hình

---

## BÀI TẬP 3: TẠO API CONTROLLER

### Mục đích
Tạo RESTful API endpoints.

### Yêu cầu

1. **Tạo Controller:**
```bash
php artisan make:controller TodoController --api
```

2. **Code Controller:**
Mở `app/Http/Controllers/TodoController.php`:
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
        return Todo::orderBy('created_at', 'desc')->get();
    }

    // POST /api/todos
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
        ]);

        $todo = Todo::create([
            'title' => $request->input('title'),
            'completed' => false,
        ]);

        return response()->json($todo, 201);
    }

    // GET /api/todos/{id}
    public function show(string $id)
    {
        return Todo::findOrFail($id);
    }

    // PUT/PATCH /api/todos/{id}
    public function update(Request $request, string $id)
    {
        $todo = Todo::findOrFail($id);
        
        $request->validate([
            'title' => 'sometimes|string|max:255',
            'completed' => 'sometimes|boolean',
        ]);
        
        $todo->update($request->only(['title', 'completed']));

        return response()->json($todo);
    }

    // DELETE /api/todos/{id}
    public function destroy(string $id)
    {
        $todo = Todo::findOrFail($id);
        $todo->delete();

        return response()->json(['message' => 'Deleted successfully'], 200);
    }
}
```

3. **Khai báo Routes:**
Mở `routes/api.php`:
```php
<?php

use App\Http\Controllers\TodoController;
use Illuminate\Support\Facades\Route;

Route::apiResource('todos', TodoController::class);
```

4. **Cấu hình CORS:**
Mở `config/cors.php`:
```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],
'allowed_methods' => ['*'],
'allowed_origins' => ['*'], // Hoặc chỉ định IP cụ thể
'allowed_headers' => ['*'],
```

### Kết quả mong đợi
- API endpoints đã sẵn sàng
- CORS đã cấu hình

---

## BÀI TẬP 4: TEST API VỚI POSTMAN

### Mục đích
Kiểm tra API hoạt động đúng.

### Yêu cầu

1. **Test GET /api/todos:**
- Method: GET
- URL: `http://127.0.0.1:8000/api/todos`
- Expected: `[]` (danh sách rỗng)

2. **Test POST /api/todos:**
- Method: POST
- URL: `http://127.0.0.1:8000/api/todos`
- Headers: `Content-Type: application/json`
- Body:
```json
{
  "title": "Học Flutter"
}
```
- Expected: Todo object với id, title, completed

3. **Test PUT /api/todos/{id}:**
- Method: PUT
- URL: `http://127.0.0.1:8000/api/todos/1`
- Body:
```json
{
  "title": "Học Flutter - Updated",
  "completed": true
}
```

4. **Test DELETE /api/todos/{id}:**
- Method: DELETE
- URL: `http://127.0.0.1:8000/api/todos/1`

### Kết quả mong đợi
- Tất cả API endpoints hoạt động đúng
- CRUD operations thành công

---

## BÀI TẬP 5: KẾT NỐI FLUTTER VỚI LARAVEL API

### Mục đích
Kết nối Flutter app với Laravel API.

### Yêu cầu

1. **Tạo Model:**
Tạo `lib/models/todo.dart`:
```dart
class Todo {
  final int id;
  final String title;
  final bool completed;
  
  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });
  
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      // Laravel MySQL trả về 0/1, convert sang bool
      completed: json['completed'] == 1 || json['completed'] == true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
```

2. **Tạo API Service:**
Tạo `lib/services/todo_service.dart`:
```dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/todo.dart';

class TodoService {
  // Tự động chọn URL dựa trên platform
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api/todos';
    }
    
    // Android Emulator dùng 10.0.2.2
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/todos';
    }
    
    // iOS Simulator dùng localhost
    return 'http://127.0.0.1:8000/api/todos';
  }
  
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json', // Quan trọng với Laravel
  };
  
  // GET: Lấy danh sách
  static Future<List<Todo>> getTodos() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: _headers,
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  // POST: Tạo mới
  static Future<Todo> createTodo(String title) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: _headers,
        body: jsonEncode({'title': title}),
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 201) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  // PUT: Cập nhật
  static Future<Todo> updateTodo(Todo todo) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${todo.id}'),
        headers: _headers,
        body: jsonEncode({
          'title': todo.title,
          'completed': todo.completed,
        }),
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  // DELETE: Xóa
  static Future<void> deleteTodo(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
```

3. **Tạo UI:**
Tạo `lib/screens/todo_screen.dart`:
```dart
import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];
  bool isLoading = true;
  final TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadTodos();
  }
  
  Future<void> _loadTodos() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final fetchedTodos = await TodoService.getTodos();
      setState(() {
        todos = fetchedTodos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }
  
  Future<void> _addTodo() async {
    if (_controller.text.isEmpty) return;
    
    try {
      await TodoService.createTodo(_controller.text);
      _controller.clear();
      _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }
  
  Future<void> _toggleTodo(Todo todo) async {
    try {
      await TodoService.updateTodo(
        Todo(
          id: todo.id,
          title: todo.title,
          completed: !todo.completed,
        ),
      );
      _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }
  
  Future<void> _deleteTodo(int id) async {
    try {
      await TodoService.deleteTodo(id);
      _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Nhập công việc...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addTodo,
                        child: Text('Thêm'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.completed,
                          onChanged: (_) => _toggleTodo(todo),
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTodo(todo.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Kết quả mong đợi
- Flutter app kết nối được với Laravel API
- CRUD operations hoạt động

---

## BÀI TẬP 6: XỬ LÝ KẾT NỐI VỚI THIẾT BỊ THẬT

### Mục đích
Kết nối Flutter app trên thiết bị thật với Laravel API.

### Yêu cầu

**Cách 1: Dùng IP LAN**

1. **Xem IP máy tính:**
```bash
# Windows
ipconfig

# macOS/Linux
ifconfig
```

Ví dụ IP: `192.168.1.5`

2. **Chạy Laravel với host 0.0.0.0:**
```bash
php artisan serve --host 0.0.0.0 --port 8000
```

3. **Sửa baseUrl trong Flutter:**
```dart
static String get baseUrl {
  return 'http://192.168.1.5:8000/api/todos';
}
```

**Cách 2: Dùng Ngrok**

1. **Tải Ngrok:**
- Tải từ: https://ngrok.com/

2. **Chạy Ngrok:**
```bash
ngrok http 8000
```

3. **Lấy URL:**
Ngrok cấp URL dạng: `https://xxxx-xxxx.ngrok.io`

4. **Sửa baseUrl:**
```dart
static String get baseUrl {
  return 'https://xxxx-xxxx.ngrok.io/api/todos';
}
```

### Kết quả mong đợi
- Kết nối được từ thiết bị thật
- API hoạt động bình thường

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành tất cả bài tập, bạn nên:
- [ ] Cài đặt được Laravel
- [ ] Tạo được database và migration
- [ ] Tạo được API endpoints
- [ ] Test được API với Postman
- [ ] Kết nối được Flutter với Laravel API
- [ ] Xử lý được kết nối với thiết bị thật

---

## 🎉 KẾT THÚC

Chúc mừng! Bạn đã hoàn thành bài thực hành Laravel + MySQL API.

👉 **Bây giờ bạn đã có đầy đủ kiến thức để xây dựng ứng dụng Flutter hoàn chỉnh!**
