# 🟦 THỰC HÀNH CHƯƠNG 02: DART CHO FLUTTER DEVELOPER

> **📌 DÀNH CHO NGƯỜI MỚI BẮT ĐẦU**
> 
> Bài thực hành này giúp bạn nắm vững các khái niệm Dart cần thiết cho Flutter thông qua các ví dụ thực tế.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Hiểu và sử dụng được var, final, const
- ✅ Làm việc thành thạo với List và Map
- ✅ Tạo và sử dụng Model class với fromJson/toJson
- ✅ Xử lý async/await và Future
- ✅ Sử dụng FutureBuilder trong UI
- ✅ Tạo StatelessWidget và StatefulWidget

---

## 📋 CHECKLIST CHUẨN BỊ

Trước khi bắt đầu, đảm bảo bạn có:
- [ ] Flutter SDK đã cài đặt (xem bài 01)
- [ ] VS Code hoặc Android Studio đã cài đặt
- [ ] Emulator hoặc thiết bị thật đã sẵn sàng

---

## BÀI TẬP 1: VAR, FINAL, CONST

### Mục đích
Hiểu sự khác biệt giữa var, final, và const.

### Yêu cầu
Tạo file `lib/main.dart` với nội dung sau:

```dart
void main() {
  // 1. var - Có thể thay đổi
  var count = 0;
  count = 10; // ✅ OK
  print('Count: $count');
  
  // 2. final - Không thể thay đổi sau khi gán
  final name = "Flutter";
  // name = "Dart"; // ❌ Lỗi! Không thể thay đổi
  print('Name: $name');
  
  // 3. const - Hằng số compile-time
  const pi = 3.14;
  // pi = 3.15; // ❌ Lỗi!
  print('Pi: $pi');
  
  // 4. final vs const với runtime
  final userName = getUserName(); // ✅ OK - Lấy từ runtime
  // const userName2 = getUserName(); // ❌ Lỗi! const không thể dùng runtime
}

String getUserName() {
  return "John";
}
```

### Kết quả mong đợi
- Code chạy thành công
- Hiểu được khi nào dùng var, final, const

### Kiểm tra
Chạy: `flutter run` và xem console output.

---

## BÀI TẬP 2: LIST VÀ MAP

### Mục đích
Làm việc với List và Map - cấu trúc dữ liệu quan trọng nhất trong Flutter.

### Yêu cầu
Tạo file `lib/exercises/list_map.dart`:

```dart
void main() {
  // === LIST ===
  List<String> names = ["Huy", "Mai", "An"];
  
  // Thêm phần tử
  names.add("Lan");
  names.addAll(["Nam", "Hoa"]);
  print('Danh sách: $names');
  
  // Xóa phần tử
  names.remove("Huy");
  print('Sau khi xóa Huy: $names');
  
  // Tìm kiếm
  bool hasMai = names.contains("Mai");
  print('Có Mai không? $hasMai');
  
  // Transform
  List<String> upperNames = names.map((name) => name.toUpperCase()).toList();
  print('Chữ hoa: $upperNames');
  
  // Filter
  List<String> longNames = names.where((name) => name.length > 3).toList();
  print('Tên dài: $longNames');
  
  // === MAP ===
  Map<String, dynamic> user = {
    "name": "Dung",
    "age": 21,
    "email": "dung@example.com"
  };
  
  // Truy cập
  print('Tên: ${user["name"]}');
  print('Tuổi: ${user["age"]}');
  
  // Thêm/Sửa
  user["phone"] = "0123456789";
  user["age"] = 22;
  print('User sau khi sửa: $user');
  
  // Lặp qua
  user.forEach((key, value) {
    print('$key: $value');
  });
}
```

### Kết quả mong đợi
- Hiểu cách thao tác với List và Map
- Biết dùng các method: add, remove, map, where, forEach

---

## BÀI TẬP 3: MODEL CLASS VỚI JSON

### Mục đích
Tạo Model class để xử lý dữ liệu từ API.

### Yêu cầu
Tạo file `lib/models/user.dart`:

```dart
import 'dart:convert';

class User {
  final String id;
  final String name;
  final int age;
  final String? email; // Nullable

  User({
    required this.id,
    required this.name,
    required this.age,
    this.email,
  });

  // JSON → User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      email: json['email'] as String?,
    );
  }

  // User → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'email': email,
    };
  }
}

// Test
void main() {
  // Từ JSON
  String jsonStr = '{"id":"1","name":"Dung","age":21,"email":"dung@example.com"}';
  Map<String, dynamic> json = jsonDecode(jsonStr);
  User user = User.fromJson(json);
  
  print('User từ JSON: ${user.name}, ${user.age} tuổi');
  
  // Sang JSON
  Map<String, dynamic> json2 = user.toJson();
  String jsonStr2 = jsonEncode(json2);
  print('JSON từ User: $jsonStr2');
}
```

### Kết quả mong đợi
- Tạo được Model class với fromJson/toJson
- Chuyển đổi được giữa JSON và Dart object

---

## BÀI TẬP 4: ASYNC/AWAIT

### Mục đích
Hiểu cách xử lý bất đồng bộ với async/await.

### Yêu cầu
Tạo file `lib/exercises/async_demo.dart`:

```dart
import 'dart:async';

// Hàm async giả lập API call
Future<String> fetchData() async {
  print('Bắt đầu fetch...');
  await Future.delayed(Duration(seconds: 2)); // Giả lập delay
  print('Fetch xong!');
  return "Hello from API";
}

// Hàm async với error handling
Future<String> fetchDataWithError() async {
  try {
    await Future.delayed(Duration(seconds: 1));
    throw Exception('Lỗi kết nối!');
  } catch (e) {
    print('Lỗi: $e');
    rethrow;
  }
}

void main() async {
  print('=== BÀI TẬP ASYNC/AWAIT ===');
  
  // 1. Chờ Future hoàn thành
  print('1. Gọi fetchData...');
  String data = await fetchData();
  print('Kết quả: $data');
  
  // 2. Xử lý lỗi
  print('\n2. Gọi fetchDataWithError...');
  try {
    String result = await fetchDataWithError();
    print('Kết quả: $result');
  } catch (e) {
    print('Đã bắt lỗi: $e');
  }
  
  // 3. Chạy song song nhiều Future
  print('\n3. Chạy song song...');
  final results = await Future.wait([
    Future.delayed(Duration(seconds: 1), () => "Task 1"),
    Future.delayed(Duration(seconds: 1), () => "Task 2"),
    Future.delayed(Duration(seconds: 1), () => "Task 3"),
  ]);
  print('Kết quả: $results');
}
```

### Kết quả mong đợi
- Hiểu cách dùng async/await
- Biết xử lý lỗi với try-catch
- Biết chạy nhiều Future song song

---

## BÀI TẬP 5: STATELESSWIDGET VÀ STATEFULWIDGET

### Mục đích
Tạo UI với StatelessWidget và StatefulWidget.

### Yêu cầu
Tạo file `lib/exercises/widget_demo.dart`:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Exercises',
      home: WidgetDemoScreen(),
    );
  }
}

class WidgetDemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Widget Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // StatelessWidget - Không thay đổi
            GreetingWidget(name: "Flutter"),
            
            SizedBox(height: 20),
            
            // StatefulWidget - Có thể thay đổi
            CounterWidget(),
          ],
        ),
      ),
    );
  }
}

// StatelessWidget - UI không thay đổi
class GreetingWidget extends StatelessWidget {
  final String name;
  
  GreetingWidget({required this.name});
  
  @override
  Widget build(BuildContext context) {
    return Text(
      'Xin chào, $name!',
      style: TextStyle(fontSize: 24),
    );
  }
}

// StatefulWidget - UI có thể thay đổi
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;
  
  void _increment() {
    setState(() {
      count++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Count: $count',
          style: TextStyle(fontSize: 32),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _increment,
          child: Text('Tăng'),
        ),
      ],
    );
  }
}
```

### Kết quả mong đợi
- Tạo được StatelessWidget và StatefulWidget
- Hiểu khi nào dùng setState()

---

## BÀI TẬP 6: FUTUREBUILDER

### Mục đích
Sử dụng FutureBuilder để hiển thị dữ liệu từ API.

### Yêu cầu
Tạo file `lib/exercises/future_builder_demo.dart`:

```dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutureBuilder Demo',
      home: FutureBuilderScreen(),
    );
  }
}

class FutureBuilderScreen extends StatelessWidget {
  // Giả lập API call
  Future<String> fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    return "Dữ liệu từ API";
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FutureBuilder Demo')),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchData(),
          builder: (context, snapshot) {
            // 1. Đang chờ
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            
            // 2. Có lỗi
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Lỗi: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Retry
                    },
                    child: Text('Thử lại'),
                  ),
                ],
              );
            }
            
            // 3. Có dữ liệu
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    snapshot.data!,
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              );
            }
            
            // 4. Không có dữ liệu
            return Text('Không có dữ liệu');
          },
        ),
      ),
    );
  }
}
```

### Kết quả mong đợi
- Hiểu cách dùng FutureBuilder
- Xử lý được các trạng thái: loading, error, success

---

## BÀI TẬP 7: TỔNG HỢP - TODO APP ĐƠN GIẢN

### Mục đích
Áp dụng tất cả kiến thức đã học vào một ứng dụng thực tế.

### Yêu cầu
Tạo ứng dụng Todo đơn giản với:
- Model class Todo
- List để lưu danh sách
- StatefulWidget để quản lý state
- Thêm, xóa, đánh dấu hoàn thành

### Code mẫu
Tạo file `lib/todo_app.dart`:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: TodoScreen(),
    );
  }
}

// Model
class Todo {
  final String id;
  final String title;
  bool isCompleted;
  
  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

// Screen
class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];
  final TextEditingController _controller = TextEditingController();
  
  void _addTodo() {
    if (_controller.text.isEmpty) return;
    
    setState(() {
      todos.add(Todo(
        id: DateTime.now().toString(),
        title: _controller.text,
      ));
      _controller.clear();
    });
  }
  
  void _toggleTodo(String id) {
    setState(() {
      todos.firstWhere((todo) => todo.id == id).isCompleted = 
        !todos.firstWhere((todo) => todo.id == id).isCompleted;
    });
  }
  
  void _deleteTodo(String id) {
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      body: Column(
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
                    value: todo.isCompleted,
                    onChanged: (_) => _toggleTodo(todo.id),
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted 
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
- Ứng dụng Todo hoàn chỉnh
- Áp dụng được các kiến thức đã học

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành tất cả bài tập, bạn nên:
- [ ] Hiểu được var, final, const
- [ ] Làm việc thành thạo với List và Map
- [ ] Tạo được Model class với fromJson/toJson
- [ ] Xử lý được async/await
- [ ] Sử dụng được FutureBuilder
- [ ] Tạo được StatelessWidget và StatefulWidget
- [ ] Xây dựng được ứng dụng Todo đơn giản

---

## 🎉 KẾT THÚC

Chúc mừng! Bạn đã hoàn thành bài thực hành Dart cho Flutter Developer.

👉 **Tiếp theo:** Bài 03 - Cấu trúc dự án Flutter & Tổ chức file chuẩn
