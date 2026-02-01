# 🟦 THỰC HÀNH CHƯƠNG 10: HTTP API ĐƠN GIẢN TRONG FLUTTER

> **📌 DÀNH CHO NGƯỜI MỚI BẮT ĐẦU**
> 
> Bài thực hành này hướng dẫn cách gọi API đơn giản với package `http`, xử lý JSON và hiển thị dữ liệu.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Cài đặt và sử dụng package `http`
- ✅ Gọi API GET để lấy dữ liệu
- ✅ Parse JSON thành Dart object
- ✅ Hiển thị dữ liệu với `FutureBuilder`
- ✅ Xử lý lỗi cơ bản

---

## 📋 CHECKLIST CHUẨN BỊ

- [ ] Flutter SDK đã cài đặt
- [ ] Kiến thức về `async/await` và `Future`
- [ ] Hiểu về JSON và Model class

---

## BƯỚC 1: KHỞI TẠO DỰ ÁN & CÀI ĐẶT PACKAGE

1. **Tạo dự án mới:**
```bash
flutter create http_api_demo
cd http_api_demo
```

2. **Thêm package `http` vào `pubspec.yaml`:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  cupertino_icons: ^1.0.2
```

3. **Chạy `flutter pub get`:**
```bash
flutter pub get
```

---

## BƯỚC 2: TẠO MODEL CLASS

Tạo file `lib/models/user.dart`:
```dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
```

**Giải thích:**
- `fromJson`: Chuyển JSON Map thành User object
- `toJson`: Chuyển User object thành JSON Map

---

## BƯỚC 3: TẠO API SERVICE

Tạo file `lib/services/api_service.dart`:
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  // URL của API công khai (JSONPlaceholder - API test miễn phí)
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // GET: Lấy danh sách users
  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
      );

      if (response.statusCode == 200) {
        // Parse JSON string thành List<dynamic>
        final List<dynamic> data = jsonDecode(response.body);
        
        // Chuyển List<dynamic> thành List<User>
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET: Lấy 1 user theo ID
  static Future<User> getUser(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$id'),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
```

**Giải thích:**
- `http.get()`: Gửi request GET đến API
- `jsonDecode()`: Chuyển JSON string thành Map/List
- `User.fromJson()`: Chuyển Map thành User object

---

## BƯỚC 4: TẠO UI VỚI FUTUREBUILDER

Sửa file `lib/main.dart`:
```dart
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserListScreen(),
    );
  }
}

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Users'),
      ),
      body: FutureBuilder<List<User>>(
        future: ApiService.getUsers(),
        builder: (context, snapshot) {
          // Đang tải
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Có lỗi
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Lỗi: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Rebuild để thử lại
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // Có dữ liệu
          if (snapshot.hasData) {
            final users = snapshot.data!;

            if (users.isEmpty) {
              return const Center(
                child: Text('Không có dữ liệu'),
              );
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${user.id}'),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to user detail (có thể thêm sau)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User: ${user.name}')),
                      );
                    },
                  ),
                );
              },
            );
          }

          // Không có dữ liệu
          return const Center(
            child: Text('Không có dữ liệu'),
          );
        },
      ),
    );
  }
}
```

**Giải thích:**
- `FutureBuilder`: Widget tự động rebuild khi Future thay đổi trạng thái
- `snapshot.connectionState`: Trạng thái của Future (waiting, done)
- `snapshot.hasError`: Kiểm tra có lỗi không
- `snapshot.hasData`: Kiểm tra có dữ liệu không

---

## BƯỚC 5: CHẠY VÀ KIỂM TRA

1. **Chạy ứng dụng:**
```bash
flutter run
```

2. **Kết quả mong đợi:**
- Ứng dụng hiển thị loading indicator
- Sau đó hiển thị danh sách 10 users từ API
- Mỗi user có ID, tên, email

---

## BÀI TẬP MỞ RỘNG

1. **Thêm Pull-to-Refresh:**
   - Bọc `ListView.builder` bằng `RefreshIndicator`
   - Khi kéo xuống, gọi lại `ApiService.getUsers()`

2. **Thêm màn hình User Detail:**
   - Tạo `UserDetailScreen` hiển thị thông tin chi tiết
   - Navigate từ `UserListScreen` sang `UserDetailScreen`
   - Truyền `User` object qua constructor

3. **Xử lý lỗi tốt hơn:**
   - Kiểm tra kết nối mạng
   - Hiển thị thông báo lỗi rõ ràng hơn
   - Thêm retry button

4. **Thêm POST request:**
   - Tạo form để thêm user mới
   - Gửi POST request với `http.post()`
   - Cập nhật danh sách sau khi thêm thành công

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành bài tập, bạn nên:
- [ ] Cài đặt được package `http`
- [ ] Tạo được Model class với `fromJson`
- [ ] Gọi được API GET
- [ ] Hiển thị được dữ liệu với `FutureBuilder`
- [ ] Xử lý được lỗi cơ bản

---

## 🎉 KẾT THÚC

Chúc mừng! Bạn đã hoàn thành bài thực hành HTTP API đơn giản.

👉 **Tiếp theo:** [Bài 10b - Dự án Tổng hợp: Bloc + Provider + .NET Web API](10b_thuc_hanh_du_an_tong_hop_bloc_provider_api.md) (dự án thực tế phức tạp hơn)
