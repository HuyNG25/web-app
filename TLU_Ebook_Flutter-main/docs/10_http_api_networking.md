# 🟦 CHƯƠNG 10  
# **NETWORKING & API TRONG FLUTTER**  
*(HTTP, JSON, Future, async–await, FutureBuilder, fetch API)*

Hầu hết app thật đều phải lấy dữ liệu từ Internet, ví dụ:

- danh sách sản phẩm  
- thông tin thời tiết  
- avatar user  
- dữ liệu từ server  

Chương này sẽ dạy bạn:

- gọi API bằng package `http`  
- xử lý JSON  
- dựng model  
- dùng FutureBuilder để hiển thị dữ liệu  
- tránh lỗi “snapshot null”, “Future not completed”  
- viết 1 mini app fetch dữ liệu hoàn chỉnh

---

# 🎯 MỤC TIÊU HỌC TẬP

Sau chương này bạn có thể:

- Gọi API GET / POST bằng http.  
- Biết dùng async–await đúng cách.  
- Parse JSON từ API thành model Dart.  
- Dùng FutureBuilder hiển thị dữ liệu.  
- Tạo service class tách logic khỏi UI.  
- Xử lý lỗi mạng cơ bản.

---

# 1. **Cài đặt package http**

Trong `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.2.0
```

Import:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
```

---

# 2. **Gọi API GET – ví dụ đơn giản**

Ví dụ API miễn phí:  
`https://jsonplaceholder.typicode.com/posts`

### Hàm fetch:

```dart
Future<List<dynamic>> fetchPosts() async {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Lỗi tải dữ liệu");
  }
}
```

---

### 🧠 Giảng giải chi tiết: Future, async, await là gì?

Trong ví dụ trên, bạn thấy 3 từ khóa quan trọng: `Future`, `async`, `await`. Đây là bộ 3 không thể thiếu khi làm việc với API (hoặc bất kỳ tác vụ nào tốn thời gian như đọc file, query DB).

#### 1. Future (Tương lai)
- Là một **chiếc hộp đóng gói kết quả sẽ có trong tương lai**.
- Khi bạn gọi hàm, nó chưa có dữ liệu ngay lập tức mà trả về một cái "phiếu hẹn" (`Future`).
- Ví dụ: `Future<List>` nghĩa là "Tôi hứa sẽ trả về một List, nhưng chưa phải bây giờ, hãy đợi chút".

#### 2. async (Bất đồng bộ)
- Đánh dấu một hàm là **bất đồng bộ** (có thực hiện việc chờ đợi).
- Bắt buộc phải thêm `async` vào sau tên hàm thì mới dùng được từ khóa `await` bên trong.
- Hàm `async` luôn luôn trả về một `Future`.

#### 3. await (Chờ đợi)
- Dùng để **tạm dừng** hàm `async` cho đến khi tác vụ xong.
- `await http.get(url)` nghĩa là: "Này Flutter, dừng ở dòng này, chờ server trả lời xong thì mới chạy dòng tiếp theo".
- Nếu không có `await`, code sẽ chạy tuột xuống dưới mà không đợi dữ liệu → lỗi `null` hoặc sai logic.

**Ví dụ đời thường:**
- Bạn gọi đồ ăn (Gửi Request).
- Nhân viên đưa bạn cái thẻ rung (**Future**).
- Bạn ngồi lướt web (**async** - không bị đơ người đứng chờ).
- Khi thẻ rung (**await** xong), bạn lấy đồ ăn (Kết quả).

---

### 🧠 Giảng giải chi tiết: HTTP GET Request

**HTTP GET là gì?**

- Method HTTP để **lấy dữ liệu** từ server
- Không gửi dữ liệu lên server (chỉ nhận)
- Response trả về dữ liệu dạng JSON

**Cơ chế hoạt động:**

```
Client (Flutter App)
    ↓
http.get(url) → Gửi request đến server
    ↓
Server xử lý request
    ↓
Server trả về Response
    ├── statusCode: 200 (thành công), 404 (not found), 500 (server error)
    └── body: JSON string
    ↓
Client nhận Response
    ↓
Parse JSON → Dart object
```

**Ví dụ minh họa từng bước:**

```dart
Future<List<dynamic>> fetchPosts() async {
  // BƯỚC 1: Parse URL
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  // ↑ Chuyển string → Uri object
  
  // BƯỚC 2: Gửi GET request (bất đồng bộ)
  final response = await http.get(url);
  // ↑ await: Chờ server trả về response
  // ↑ response là Response object chứa:
  //   - statusCode: 200, 404, 500...
  //   - body: JSON string
  //   - headers: Response headers
  
  // BƯỚC 3: Kiểm tra status code
  if (response.statusCode == 200) {
    // ✅ Thành công: Parse JSON
    final jsonData = jsonDecode(response.body);
    // ↑ jsonDecode: Chuyển JSON string → Dart Map/List
    return jsonData as List<dynamic>;
  } else {
    // ❌ Lỗi: Throw exception
    throw Exception("Lỗi tải dữ liệu: ${response.statusCode}");
  }
}
```

**Response object có gì?**

```dart
final response = await http.get(url);

// Các thuộc tính quan trọng:
response.statusCode    // int: 200, 404, 500...
response.body          // String: JSON string
response.headers       // Map<String, String>: Response headers
response.statusMessage // String: "OK", "Not Found"...
```

**HTTP Status Codes:**

| Code | Ý nghĩa | Khi nào xảy ra |
|------|---------|----------------|
| 200 | OK | Request thành công |
| 201 | Created | Tạo mới thành công (POST) |
| 400 | Bad Request | Request sai format |
| 401 | Unauthorized | Chưa đăng nhập |
| 404 | Not Found | Không tìm thấy resource |
| 500 | Server Error | Lỗi server |

**Ví dụ minh họa với error handling:**

```dart
Future<List<dynamic>> fetchPosts() async {
  try {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final response = await http.get(url);
    
    // Kiểm tra status code
    if (response.statusCode == 200) {
      // ✅ Thành công
      return jsonDecode(response.body) as List;
    } else {
      // ❌ Lỗi HTTP
      throw Exception("HTTP ${response.statusCode}: ${response.statusMessage}");
    }
  } on SocketException {
    // ❌ Lỗi mạng (không có internet)
    throw Exception("Không có kết nối mạng");
  } on TimeoutException {
    // ❌ Timeout (server không phản hồi)
    throw Exception("Timeout - Server không phản hồi");
  } catch (e) {
    // ❌ Lỗi khác
    throw Exception("Lỗi: $e");
  }
}
```

---

# 3. **Gọi API POST – gửi dữ liệu lên server**

```dart
Future<void> createPost() async {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");

  final response = await http.post(
    url,
    body: jsonEncode({
      "title": "Hello",
      "body": "Flutter",
      "userId": 1
    }),
    headers: {"Content-type": "application/json"},
  );

  print(response.body);
}
```

---

### 🧠 Giảng giải chi tiết: HTTP POST Request

**HTTP POST là gì?**

- Method HTTP để **gửi dữ liệu** lên server
- Dùng để tạo mới, cập nhật dữ liệu
- Gửi dữ liệu trong `body` của request

**So sánh GET vs POST:**

| Method | Mục đích | Gửi dữ liệu? | Ví dụ |
|--------|----------|--------------|-------|
| GET | Lấy dữ liệu | ❌ Không | Lấy danh sách sản phẩm |
| POST | Tạo mới | ✅ Có | Tạo bài viết mới |
| PUT | Cập nhật | ✅ Có | Sửa bài viết |
| DELETE | Xóa | ❌ Không | Xóa bài viết |

**Cơ chế hoạt động:**

```
Client (Flutter App)
    ↓
http.post(url, body: data) → Gửi request + data lên server
    ↓
Server nhận data và xử lý
    ↓
Server trả về Response
    ├── statusCode: 201 (created), 400 (bad request)...
    └── body: JSON string (thường là object vừa tạo)
    ↓
Client nhận Response
```

**Ví dụ minh họa từng bước:**

```dart
Future<Map<String, dynamic>> createPost(String title, String body) async {
  // BƯỚC 1: Parse URL
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  
  // BƯỚC 2: Chuẩn bị data
  final data = {
    "title": title,
    "body": body,
    "userId": 1,
  };
  
  // BƯỚC 3: Gửi POST request
  final response = await http.post(
    url,
    body: jsonEncode(data),  // ← Chuyển Map → JSON string
    headers: {
      "Content-Type": "application/json",  // ← Báo server: "Tôi gửi JSON"
    },
  );
  
  // BƯỚC 4: Kiểm tra kết quả
  if (response.statusCode == 201) {
    // ✅ Thành công: Parse response
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    // ❌ Lỗi
    throw Exception("Lỗi tạo bài viết: ${response.statusCode}");
  }
}
```

**Headers quan trọng:**

```dart
headers: {
  "Content-Type": "application/json",  // Loại dữ liệu gửi lên
  "Authorization": "Bearer token123",  // Token đăng nhập (nếu cần)
  "Accept": "application/json",        // Loại dữ liệu muốn nhận
}
```

**Ví dụ minh họa: POST với authentication**

```dart
Future<Map<String, dynamic>> createPostWithAuth({
  required String title,
  required String body,
  required String token,
}) async {
  final url = Uri.parse("https://api.example.com/posts");
  
  final response = await http.post(
    url,
    body: jsonEncode({
      "title": title,
      "body": body,
    }),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",  // ← Token đăng nhập
    },
  );
  
  if (response.statusCode == 201) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (response.statusCode == 401) {
    throw Exception("Chưa đăng nhập");
  } else {
    throw Exception("Lỗi: ${response.statusCode}");
  }
}
```

**Ví dụ minh họa: PUT và DELETE**

```dart
// PUT - Cập nhật
Future<Map<String, dynamic>> updatePost(int id, String title) async {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts/$id");
  
  final response = await http.put(
    url,
    body: jsonEncode({"title": title}),
    headers: {"Content-Type": "application/json"},
  );
  
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception("Lỗi cập nhật");
  }
}

// DELETE - Xóa
Future<void> deletePost(int id) async {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts/$id");
  
  final response = await http.delete(url);
  
  if (response.statusCode != 200) {
    throw Exception("Lỗi xóa");
  }
}
```

---

# 4. **JSON & model class (rất quan trọng)**

JSON là dạng dữ liệu phổ biến nhất.  
Ví dụ JSON post:

```json
{
  "userId": 1,
  "id": 1,
  "title": "Hello",
  "body": "Nội dung"
}
```

Tạo model:

```dart
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      userId: json["userId"],
      title: json["title"],
      body: json["body"],
    );
  }
}
```

### Convert JSON → List<Post>

```dart
List<Post> toPosts(List<dynamic> data) {
  return data.map((json) => Post.fromJson(json)).toList();
}
```

---

### 🧠 Giảng giải chi tiết: JSON và Model Class

**JSON là gì?**

- **JavaScript Object Notation** - Định dạng dữ liệu text
- Dùng để trao đổi dữ liệu giữa client và server
- Dễ đọc, dễ parse

**Cấu trúc JSON:**

```json
// Object (Map trong Dart)
{
  "id": 1,
  "name": "John",
  "age": 25
}

// Array (List trong Dart)
[
  {"id": 1, "name": "John"},
  {"id": 2, "name": "Jane"}
]

// Nested (Lồng nhau)
{
  "user": {
    "id": 1,
    "name": "John",
    "address": {
      "city": "Hanoi",
      "country": "Vietnam"
    }
  }
}
```

**Chuyển đổi JSON ↔ Dart:**

```dart
// JSON string → Dart Map/List
String jsonString = '{"id": 1, "name": "John"}';
Map<String, dynamic> data = jsonDecode(jsonString);
// data = {"id": 1, "name": "John"}

// Dart Map/List → JSON string
Map<String, dynamic> data = {"id": 1, "name": "John"};
String jsonString = jsonEncode(data);
// jsonString = '{"id":1,"name":"John"}'
```

**Tại sao cần Model Class?**

```dart
// ❌ KHÔNG DÙNG MODEL: Khó sử dụng, dễ lỗi
final data = jsonDecode(response.body) as Map<String, dynamic>;
print(data["title"]);  // ← Phải nhớ key là "title"
// Nếu key sai → runtime error!

// ✅ DÙNG MODEL: Type-safe, dễ sử dụng
final post = Post.fromJson(data);
print(post.title);  // ← Type-safe, IDE autocomplete
```

**Ví dụ minh họa: Model class đầy đủ**

```dart
// models/post.dart
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  final DateTime? createdAt;  // Nullable

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.createdAt,
  });

  // JSON → Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] as int,
      userId: json["userId"] as int,
      title: json["title"] as String,
      body: json["body"] as String,
      createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"] as String)
        : null,
    );
  }

  // Post → JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "body": body,
      "createdAt": createdAt?.toIso8601String(),
    };
  }
}
```

**Ví dụ minh họa: Nested JSON**

```dart
// JSON từ API:
{
  "id": 1,
  "user": {
    "id": 1,
    "name": "John"
  },
  "comments": [
    {"id": 1, "text": "Great!"},
    {"id": 2, "text": "Nice!"}
  ]
}

// Model:
class User {
  final int id;
  final String name;
  
  User({required this.id, required this.name});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int,
      name: json["name"] as String,
    );
  }
}

class Comment {
  final int id;
  final String text;
  
  Comment({required this.id, required this.text});
  
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"] as int,
      text: json["text"] as String,
    );
  }
}

class Post {
  final int id;
  final User user;
  final List<Comment> comments;
  
  Post({
    required this.id,
    required this.user,
    required this.comments,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] as int,
      user: User.fromJson(json["user"] as Map<String, dynamic>),
      comments: (json["comments"] as List)
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList(),
    );
  }
}
```

**Convert JSON → List<Post>:**

```dart
// Cách 1: Dùng map
List<Post> toPosts(List<dynamic> data) {
  return data
    .map((json) => Post.fromJson(json as Map<String, dynamic>))
    .toList();
}

// Cách 2: Dùng for loop
List<Post> toPosts(List<dynamic> data) {
  List<Post> posts = [];
  for (var json in data) {
    posts.add(Post.fromJson(json as Map<String, dynamic>));
  }
  return posts;
}
```

---

# 5. **FutureBuilder – cách hiển thị dữ liệu lên UI**

```dart
FutureBuilder(
  future: fetchPosts(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return const Text("Lỗi tải dữ liệu");
    }

    final posts = snapshot.data as List<dynamic>;

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(posts[index]["title"]),
          subtitle: Text(posts[index]["body"]),
        );
      },
    );
  },
);
```

---

### 🧠 Giảng giải chi tiết: FutureBuilder với API

**FutureBuilder là gì?**

- Widget tự động rebuild khi Future thay đổi
- Hiển thị UI khác nhau theo trạng thái: loading, success, error
- Rất hữu ích khi load dữ liệu từ API

**Cơ chế hoạt động:**

```
FutureBuilder được tạo
    ↓
future: fetchPosts() được gọi
    ↓
ConnectionState.waiting → Hiển thị loading
    ↓
API trả về dữ liệu
    ↓
ConnectionState.done → Kiểm tra hasError/hasData
    ↓
hasData → Hiển thị dữ liệu
hasError → Hiển thị lỗi
```

**Các trạng thái của snapshot:**

```dart
FutureBuilder<List<Post>>(
  future: fetchPosts(),
  builder: (context, snapshot) {
    // 1. Đang chờ (loading)
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    // 2. Có lỗi
    if (snapshot.hasError) {
      return Text("Lỗi: ${snapshot.error}");
    }
    
    // 3. Không có dữ liệu
    if (!snapshot.hasData) {
      return Text("Không có dữ liệu");
    }
    
    // 4. Có dữ liệu
    final posts = snapshot.data!;
    return ListView.builder(...);
  },
)
```

**ConnectionState:**

- `ConnectionState.none` - Chưa bắt đầu
- `ConnectionState.waiting` - Đang chờ
- `ConnectionState.active` - Đang xử lý
- `ConnectionState.done` - Hoàn thành

**Ví dụ minh họa từng bước:**

```dart
class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách bài viết")),
      body: FutureBuilder<List<Post>>(
        // BƯỚC 1: Future được gọi
        future: ApiService.getPosts(),
        // ↑ Future này sẽ chạy khi widget được build
        
        builder: (context, snapshot) {
          print("🔵 Builder được gọi - State: ${snapshot.connectionState}");
          
          // BƯỚC 2: Kiểm tra trạng thái
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("🟡 Đang loading...");
            return Center(child: CircularProgressIndicator());
          }
          
          // BƯỚC 3: Kiểm tra lỗi
          if (snapshot.hasError) {
            print("🔴 Có lỗi: ${snapshot.error}");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  Text("Lỗi: ${snapshot.error}"),
                  ElevatedButton(
                    onPressed: () {
                      // Retry - FutureBuilder sẽ tự động rebuild
                    },
                    child: Text("Thử lại"),
                  ),
                ],
              ),
            );
          }
          
          // BƯỚC 4: Kiểm tra dữ liệu
          if (!snapshot.hasData) {
            return Center(child: Text("Không có dữ liệu"));
          }
          
          // BƯỚC 5: Hiển thị dữ liệu
          final posts = snapshot.data!;
          print("🟢 Có ${posts.length} bài viết");
          
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(posts[index].title),
                subtitle: Text(posts[index].body),
              );
            },
          );
        },
      ),
    );
  }
}
```

**Lưu ý quan trọng:**

1. **Future chỉ chạy 1 lần** - Nếu muốn refresh, phải tạo Future mới
2. **Kiểm tra hasData trước khi dùng** - Tránh null error
3. **Xử lý tất cả trạng thái** - waiting, error, success

---

### 🧠 Mẹo nhớ trạng thái snapshot

| Trạng thái | Ý nghĩa | Dùng để… |
|-----------|--------|----------|
| waiting | đang tải | loading UI |
| hasError | lỗi | hiển thị lỗi |
| hasData | có dữ liệu | build UI |

**Flow minh họa:**

```
FutureBuilder được tạo
    ↓
snapshot.connectionState = waiting
    ↓ UI: Loading spinner
    ↓
API trả về
    ↓
snapshot.connectionState = done
    ├── snapshot.hasError = true → UI: Error message
    └── snapshot.hasData = true → UI: Data list
```

---

# 6. **Tách riêng API logic vào Folder services/**

```
lib/
  services/
    api_service.dart
```

```dart
class ApiService {
  static Future<List<Post>> getPosts() async {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final response = await http.get(url);
    if (response.statusCode != 200) throw Exception("Lỗi");

    final data = jsonDecode(response.body) as List;
    return data.map((e) => Post.fromJson(e)).toList();
  }
}
```

→ UI chỉ tập trung vào hiển thị, không chứa logic API.

---

### 🧠 Giảng giải chi tiết: Tại sao tách API logic?

**Vấn đề khi không tách:**

```dart
// ❌ SAI: API logic trong UI
class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        // ❌ Logic API nằm trong UI
        final url = Uri.parse("https://api.example.com/posts");
        final response = await http.get(url);
        final data = jsonDecode(response.body);
        return data.map((e) => Post.fromJson(e)).toList();
      }(),
      builder: (context, snapshot) {...},
    );
  }
}

// Vấn đề:
// - Code rối, khó maintain
// - Khó test
// - Khó tái sử dụng
```

**Giải pháp: Tách vào Service**

```dart
// ✅ ĐÚNG: API logic trong Service
// services/api_service.dart
class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";
  
  // GET posts
  static Future<List<Post>> getPosts() async {
    final url = Uri.parse("$baseUrl/posts");
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load posts: ${response.statusCode}");
    }
  }
  
  // GET single post
  static Future<Post> getPost(int id) async {
    final url = Uri.parse("$baseUrl/posts/$id");
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to load post");
    }
  }
  
  // POST create post
  static Future<Post> createPost(String title, String body) async {
    final url = Uri.parse("$baseUrl/posts");
    final response = await http.post(
      url,
      body: jsonEncode({
        "title": title,
        "body": body,
        "userId": 1,
      }),
      headers: {"Content-Type": "application/json"},
    );
    
    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to create post");
    }
  }
}

// screens/post_screen.dart
class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: ApiService.getPosts(),  // ← Chỉ gọi method, logic ở Service
      builder: (context, snapshot) {...},
    );
  }
}
```

**Lợi ích của Service class:**

1. ✅ **Tách biệt concerns** - UI chỉ hiển thị, Service xử lý API
2. ✅ **Dễ test** - Test Service riêng, không cần UI
3. ✅ **Tái sử dụng** - Nhiều màn hình dùng chung Service
4. ✅ **Dễ maintain** - Sửa API logic ở 1 nơi

**Ví dụ minh họa: Service class đầy đủ**

```dart
// services/api_service.dart
class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";
  static const Duration timeout = Duration(seconds: 10);
  
  // Helper method: Xử lý response
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "HTTP ${response.statusCode}: ${response.reasonPhrase}",
      );
    }
  }
  
  // GET posts
  static Future<List<Post>> getPosts() async {
    try {
      final url = Uri.parse("$baseUrl/posts");
      final response = await http.get(url).timeout(timeout);
      final data = _handleResponse(response) as List;
      return data.map((e) => Post.fromJson(e)).toList();
    } on TimeoutException {
      throw Exception("Request timeout");
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
  
  // GET single post
  static Future<Post> getPost(int id) async {
    final url = Uri.parse("$baseUrl/posts/$id");
    final response = await http.get(url).timeout(timeout);
    final data = _handleResponse(response) as Map<String, dynamic>;
    return Post.fromJson(data);
  }
  
  // POST create post
  static Future<Post> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    final url = Uri.parse("$baseUrl/posts");
    final response = await http.post(
      url,
      body: jsonEncode({
        "title": title,
        "body": body,
        "userId": userId,
      }),
      headers: {"Content-Type": "application/json"},
    ).timeout(timeout);
    
    final data = _handleResponse(response) as Map<String, dynamic>;
    return Post.fromJson(data);
  }
  
  // PUT update post
  static Future<Post> updatePost({
    required int id,
    required String title,
    required String body,
  }) async {
    final url = Uri.parse("$baseUrl/posts/$id");
    final response = await http.put(
      url,
      body: jsonEncode({
        "title": title,
        "body": body,
      }),
      headers: {"Content-Type": "application/json"},
    ).timeout(timeout);
    
    final data = _handleResponse(response) as Map<String, dynamic>;
    return Post.fromJson(data);
  }
  
  // DELETE post
  static Future<void> deletePost(int id) async {
    final url = Uri.parse("$baseUrl/posts/$id");
    final response = await http.delete(url).timeout(timeout);
    
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to delete post");
    }
  }
}
```

---

# 7. **Xử lý lỗi mạng cơ bản**

```dart
try {
  final posts = await ApiService.getPosts();
} catch (e) {
  print("Có lỗi: $e");
}
```

Hoặc trong UI:

```dart
if (snapshot.hasError) return Text("Lỗi rồi!");
```

---

### 🧠 Giảng giải chi tiết: Xử lý lỗi mạng

**Các loại lỗi thường gặp:**

1. **Network error** - Không có internet
2. **Timeout** - Server không phản hồi
3. **HTTP error** - 404, 500...
4. **JSON parse error** - Dữ liệu không đúng format

**Ví dụ minh họa: Xử lý từng loại lỗi**

```dart
Future<List<Post>> fetchPosts() async {
  try {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final response = await http.get(url).timeout(
      Duration(seconds: 10),  // Timeout sau 10 giây
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw HttpException("HTTP ${response.statusCode}");
    }
  } on SocketException {
    // ❌ Lỗi mạng (không có internet)
    throw NetworkException("Không có kết nối mạng");
  } on TimeoutException {
    // ❌ Timeout (server không phản hồi)
    throw NetworkException("Timeout - Server không phản hồi");
  } on FormatException {
    // ❌ Lỗi parse JSON
    throw NetworkException("Dữ liệu không đúng format");
  } on HttpException catch (e) {
    // ❌ Lỗi HTTP
    throw NetworkException("Lỗi HTTP: ${e.message}");
  } catch (e) {
    // ❌ Lỗi khác
    throw NetworkException("Lỗi không xác định: $e");
  }
}
```

**Custom Exception classes:**

```dart
// exceptions/network_exception.dart
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => message;
}

class HttpException implements Exception {
  final int statusCode;
  final String message;
  
  HttpException(this.statusCode, this.message);
  
  @override
  String toString() => "HTTP $statusCode: $message";
}
```

**Xử lý lỗi trong UI:**

```dart
FutureBuilder<List<Post>>(
  future: ApiService.getPosts(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (snapshot.hasError) {
      // ✅ Xử lý lỗi chi tiết
      final error = snapshot.error;
      
      String errorMessage = "Lỗi không xác định";
      IconData errorIcon = Icons.error;
      
      if (error is NetworkException) {
        errorMessage = error.message;
        errorIcon = Icons.wifi_off;
      } else if (error is HttpException) {
        errorMessage = "Lỗi HTTP: ${error.statusCode}";
        errorIcon = Icons.error_outline;
      }
      
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(errorIcon, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Retry - FutureBuilder sẽ rebuild
              },
              child: Text("Thử lại"),
            ),
          ],
        ),
      );
    }
    
    if (!snapshot.hasData) {
      return Center(child: Text("Không có dữ liệu"));
    }
    
    final posts = snapshot.data!;
    return ListView.builder(...);
  },
)
```

**Ví dụ minh họa: Retry mechanism**

```dart
class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Future<List<Post>>? _postsFuture;
  
  @override
  void initState() {
    super.initState();
    _loadPosts();
  }
  
  void _loadPosts() {
    setState(() {
      _postsFuture = ApiService.getPosts();  // Tạo Future mới
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách bài viết"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadPosts,  // Retry
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text("${snapshot.error}"),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPosts,  // Retry
                    child: Text("Thử lại"),
                  ),
                ],
              ),
            );
          }
          
          final posts = snapshot.data!;
          return ListView.builder(...);
        },
      ),
    );
  }
}
```

---

# 8. **Các ví dụ thực tế đa dạng**

## 8.1. **Ví dụ: Màn hình danh sách bài viết**

```dart
class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách bài viết")),
      body: FutureBuilder(
        future: ApiService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải dữ liệu"));
          }

          final posts = snapshot.data as List<Post>;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final p = posts[index];
              return ListTile(
                title: Text(p.title),
                subtitle: Text(p.body),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

### 🧠 Giảng giải từng bước: PostScreen hoạt động như thế nào?

**Bước 1: Widget được build**

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: FutureBuilder(
      future: ApiService.getPosts(),  // ← Future được tạo
      // ...
    ),
  );
}
```

**Bước 2: FutureBuilder bắt đầu**

```
FutureBuilder được tạo
    ↓
future: ApiService.getPosts() được gọi
    ↓
snapshot.connectionState = ConnectionState.waiting
    ↓
UI: Hiển thị CircularProgressIndicator
```

**Bước 3: API trả về dữ liệu**

```
API call hoàn thành
    ↓
snapshot.connectionState = ConnectionState.done
    ↓
snapshot.hasData = true
    ↓
snapshot.data = List<Post>
    ↓
UI: Hiển thị ListView với posts
```

**Bước 4: Nếu có lỗi**

```
API call thất bại
    ↓
snapshot.connectionState = ConnectionState.done
    ↓
snapshot.hasError = true
    ↓
snapshot.error = Exception("...")
    ↓
UI: Hiển thị error message
```

---

## 8.2. **Ví dụ: User List với Pull-to-Refresh**

```dart
class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  Future<List<User>>? _usersFuture;
  
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }
  
  void _loadUsers() {
    setState(() {
      _usersFuture = ApiService.getUsers();  // Tạo Future mới
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách người dùng")),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadUsers();  // Refresh
          await _usersFuture;  // Chờ load xong
        },
        child: FutureBuilder<List<User>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text("${snapshot.error}"),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadUsers,
                      child: Text("Thử lại"),
                    ),
                  ],
                ),
              );
            }
            
            final users = snapshot.data!;
            
            if (users.isEmpty) {
              return Center(child: Text("Không có người dùng nào"));
            }
            
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user.name[0]),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
```

---

## 8.3. **Ví dụ: Create Post với Form**

```dart
class CreatePostScreen extends StatefulWidget {
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
  
  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final post = await ApiService.createPost(
        title: _titleController.text,
        body: _bodyController.text,
        userId: 1,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã tạo bài viết: ${post.title}")),
        );
        Navigator.pop(context, post);  // Trả về post vừa tạo
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tạo bài viết")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Tiêu đề"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tiêu đề không được để trống";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: "Nội dung"),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nội dung không được để trống";
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitPost,
                    child: Text("Đăng bài"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 8.4. **Ví dụ: Image Gallery từ API**

```dart
// models/photo.dart
class Photo {
  final int id;
  final String url;
  final String title;
  
  Photo({required this.id, required this.url, required this.title});
  
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json["id"] as int,
      url: json["url"] as String,
      title: json["title"] as String,
    );
  }
}

// services/api_service.dart
class ApiService {
  static Future<List<Photo>> getPhotos() async {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/photos");
    final response = await http.get(url).timeout(Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data
        .map((e) => Photo.fromJson(e as Map<String, dynamic>))
        .toList();
    } else {
      throw Exception("Failed to load photos");
    }
  }
}

// screens/photo_gallery_screen.dart
class PhotoGalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Photo Gallery")),
      body: FutureBuilder<List<Photo>>(
        future: ApiService.getPhotos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text("${snapshot.error}"),
                ],
              ),
            );
          }
          
          final photos = snapshot.data!;
          
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        photo.url,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        photo.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## 8.5. **Ví dụ: Search với Debounce**

```dart
class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  Future<List<Product>>? _searchFuture;
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
  
  void _onSearchChanged() {
    // Debounce: Chờ 500ms sau khi user ngừng gõ
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _performSearch(_searchController.text);
    });
  }
  
  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchFuture = null;
      } else {
        _searchFuture = ApiService.searchProducts(query);
      }
    });
  }
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Tìm kiếm...",
            border: InputBorder.none,
          ),
        ),
      ),
      body: _searchFuture == null
        ? Center(child: Text("Nhập từ khóa để tìm kiếm"))
        : FutureBuilder<List<Product>>(
            future: _searchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Center(child: Text("Lỗi: ${snapshot.error}"));
              }
              
              final products = snapshot.data!;
              
              if (products.isEmpty) {
                return Center(child: Text("Không tìm thấy kết quả"));
              }
              
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(products[index].name),
                    subtitle: Text("${products[index].price} đ"),
                  );
                },
              );
            },
          ),
    );
  }
}
```

---

# 9. **Sai vs Đúng – lỗi sinh viên thường gặp**

## ❌ Sai: quên await → snapshot không bao giờ hoàn thành

```dart
future: fetchPosts(), // thiếu await trong hàm fetch
```

---

### 🔍 Giảng giải chi tiết: Tại sao quên await gây lỗi?

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Quên await
Future<List<Post>> fetchPosts() {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final response = http.get(url);  // ← Quên await!
  // response là Future<Response>, không phải Response!
  
  if (response.statusCode == 200) {  // ← Lỗi! response chưa có statusCode
    return jsonDecode(response.body);
  }
}

// FutureBuilder
FutureBuilder(
  future: fetchPosts(),  // ← Trả về Future nhưng không bao giờ complete
  builder: (context, snapshot) {
    // snapshot.connectionState = waiting mãi mãi!
  },
)
```

**Vấn đề:**
- `http.get()` trả về `Future<Response>`, không phải `Response`
- Không có `await` → response vẫn là Future, chưa có dữ liệu
- FutureBuilder chờ mãi mãi, không bao giờ có data

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Có await
Future<List<Post>> fetchPosts() async {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final response = await http.get(url);  // ← Có await!
  // response là Response object, có statusCode, body...
  
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
}
```

---

## ✔ Đúng:

Trong fetch:

```dart
final response = await http.get(url);
```

---

## ❌ Sai: decode sai kiểu JSON

```dart
final data = jsonDecode(response.body) as Map; // sai
```

---

### 🔍 Giảng giải chi tiết: Lỗi decode JSON

**Ví dụ minh họa:**

```dart
// API trả về List:
[
  {"id": 1, "title": "Post 1"},
  {"id": 2, "title": "Post 2"}
]

// ❌ SAI: Cast thành Map
final data = jsonDecode(response.body) as Map<String, dynamic>;
// ← Lỗi: data là List, không phải Map!

// ✅ ĐÚNG: Cast thành List
final data = jsonDecode(response.body) as List<dynamic>;
```

**Cách xác định kiểu JSON:**

```dart
// Kiểm tra JSON string trước khi decode
final jsonString = response.body;
print(jsonString);  // In ra xem cấu trúc

// Hoặc kiểm tra ký tự đầu
if (jsonString.startsWith("[")) {
  // Là Array → List
  final data = jsonDecode(jsonString) as List;
} else if (jsonString.startsWith("{")) {
  // Là Object → Map
  final data = jsonDecode(jsonString) as Map<String, dynamic>;
}
```

---

## ✔ Đúng:

```dart
final data = jsonDecode(response.body) as List;
```

---

## ❌ Sai: viết API logic trong build()

---

### 🔍 Giảng giải chi tiết: Tại sao không viết API logic trong build()?

**Ví dụ minh họa lỗi:**

```dart
class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ SAI: API logic trong build()
    final url = Uri.parse("https://api.example.com/posts");
    final response = await http.get(url);  // ← Lỗi! await không thể dùng trong build()
    final data = jsonDecode(response.body);
    
    return ListView(...);
  }
}
```

**Vấn đề:**
- `build()` không thể là async
- `build()` chạy nhiều lần → gọi API nhiều lần không cần thiết
- Code rối, khó maintain

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Tách vào Service + FutureBuilder
class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: ApiService.getPosts(),  // ← Logic ở Service
      builder: (context, snapshot) {
        // Chỉ hiển thị UI
        if (snapshot.hasData) {
          return ListView(...);
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

---

## ✔ Đúng: tách vào service + dùng FutureBuilder

---

## ❌ Sai: gọi phụ thuộc mạng trong initState nhưng không gắn setState

---

### 🔍 Giảng giải chi tiết: Lỗi gọi API trong initState

**Ví dụ minh họa lỗi:**

```dart
class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Post>? posts;
  
  @override
  void initState() {
    super.initState();
    // ❌ SAI: Gọi API nhưng không setState
    ApiService.getPosts().then((data) {
      posts = data;  // ← State thay đổi nhưng không setState!
      // UI không cập nhật!
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(...);  // ← posts vẫn null!
  }
}
```

**Vấn đề:**
- State thay đổi nhưng không gọi setState
- UI không rebuild
- Dữ liệu không hiển thị

**✅ Giải pháp 1: Dùng setState**

```dart
@override
void initState() {
  super.initState();
  ApiService.getPosts().then((data) {
    if (mounted) {  // ← QUAN TRỌNG: Kiểm tra mounted
      setState(() {
        posts = data;  // ← Có setState
      });
    }
  });
}
```

**✅ Giải pháp 2: Dùng FutureBuilder (TỐT HƠN)**

```dart
class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: ApiService.getPosts(),  // ← Tự động xử lý
      builder: (context, snapshot) {
        // FutureBuilder tự động rebuild khi có data
      },
    );
  }
}
```

---

## ✔ Đúng:

→ dùng FutureBuilder hoặc setState đúng cách

---

## 🔴 Case Study: Các lỗi khác thường gặp

### Case Study 1: FutureBuilder rebuild mỗi lần build()

#### ❌ Vấn đề:

```dart
class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getPosts(),  // ← Tạo Future mới mỗi lần build!
      builder: (context, snapshot) {...},
    );
  }
}
```

**Vấn đề:** Mỗi lần build() → tạo Future mới → gọi API lại

#### ✅ Giải pháp:

```dart
class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final Future<List<Post>> _postsFuture;
  
  @override
  void initState() {
    super.initState();
    _postsFuture = ApiService.getPosts();  // ← Tạo 1 lần trong initState
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _postsFuture,  // ← Dùng Future đã tạo
      builder: (context, snapshot) {...},
    );
  }
}
```

---

### Case Study 2: Quên kiểm tra null trước khi dùng snapshot.data

#### ❌ Vấn đề:

```dart
FutureBuilder(
  future: ApiService.getPosts(),
  builder: (context, snapshot) {
    final posts = snapshot.data;  // ← Có thể null!
    return ListView.builder(
      itemCount: posts.length,  // ← Crash nếu posts = null!
    );
  },
)
```

#### ✅ Giải pháp:

```dart
FutureBuilder(
  future: ApiService.getPosts(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    
    final posts = snapshot.data!;  // ← An toàn vì đã kiểm tra hasData
    return ListView.builder(
      itemCount: posts.length,
    );
  },
)
```

---

### Case Study 3: Không xử lý timeout

#### ❌ Vấn đề:

```dart
Future<List<Post>> fetchPosts() async {
  final response = await http.get(url);  // ← Không có timeout
  // Nếu mạng chậm → chờ mãi mãi
}
```

#### ✅ Giải pháp:

```dart
Future<List<Post>> fetchPosts() async {
  final response = await http.get(url).timeout(
    Duration(seconds: 10),  // ← Timeout sau 10 giây
    onTimeout: () {
      throw TimeoutException("Request timeout");
    },
  );
}
```

---

### Case Study 4: Parse JSON không an toàn

#### ❌ Vấn đề:

```dart
factory Post.fromJson(Map<String, dynamic> json) {
  return Post(
    id: json["id"],  // ← Có thể null hoặc sai kiểu!
    title: json["title"],  // ← Có thể null!
  );
}
```

#### ✅ Giải pháp:

```dart
factory Post.fromJson(Map<String, dynamic> json) {
  return Post(
    id: json["id"] as int,  // ← Cast rõ ràng
    userId: json["userId"] as int? ?? 0,  // ← Default value nếu null
    title: json["title"] as String? ?? "",  // ← Default value
    body: json["body"] as String? ?? "",
  );
}
```

---

### Case Study 5: Lỗi Network Refuse / XMLHttpRequest error trên Web (CORS)

#### ❌ Vấn đề:
Khi chạy trên **Chrome (Web)**, bạn gọi API nhưng gặp lỗi: `XMLHttpRequest error` hoặc `NetworkError` mặc dù API vẫn hoạt động tốt trên Postman/Android.

#### 🔍 Nguyên nhân:
Đây là **CORS Policy** (Cross-Origin Resource Sharing) - cơ chế bảo mật của trình duyệt. Trình duyệt chặn không cho web ở `localhost` gọi API từ domain khác (ví dụ: `jsonplaceholder.typicode.com`) nếu server API không cho phép.

#### ✅ Giải pháp (Dev only):
Chạy Chrome với cờ tắt bảo mật (chỉ dùng để dev):

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

**Lưu ý:** Khi deploy thật, Backend API phải cấu hình `Access-Control-Allow-Origin: *` hoặc domain của bạn.

---

# 10. **Best Practices & Performance**

## 10.1. **API Best Practices**

### 1. Luôn tách API logic vào Service

```dart
// ✅ ĐÚNG: Service class
class ApiService {
  static Future<List<Post>> getPosts() async {...}
}

// ❌ SAI: Logic trong UI
class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // API logic ở đây
  }
}
```

### 2. Xử lý tất cả lỗi

```dart
Future<List<Post>> getPosts() async {
  try {
    final response = await http.get(url).timeout(Duration(seconds: 10));
    // ...
  } on SocketException {
    throw NetworkException("No internet");
  } on TimeoutException {
    throw NetworkException("Timeout");
  } catch (e) {
    throw NetworkException("Error: $e");
  }
}
```

### 3. Dùng Model class thay vì Map

```dart
// ✅ ĐÚNG: Type-safe
final post = Post.fromJson(json);
print(post.title);

// ❌ SAI: Dễ lỗi
final data = jsonDecode(response.body) as Map;
print(data["title"]);  // Có thể null hoặc sai key
```

### 4. Timeout cho mọi request

```dart
final response = await http.get(url).timeout(
  Duration(seconds: 10),
  onTimeout: () {
    throw TimeoutException("Request timeout");
  },
);
```

## 10.2. **FutureBuilder Best Practices**

### 1. Tạo Future trong initState (StatefulWidget)

```dart
class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final Future<List<Post>> _postsFuture;
  
  @override
  void initState() {
    super.initState();
    _postsFuture = ApiService.getPosts();  // ← Tạo 1 lần
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _postsFuture,  // ← Dùng Future đã tạo
      builder: (context, snapshot) {...},
    );
  }
}
```

### 2. Kiểm tra tất cả trạng thái

```dart
FutureBuilder(
  future: _postsFuture,
  builder: (context, snapshot) {
    // 1. Waiting
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    // 2. Error
    if (snapshot.hasError) {
      return ErrorWidget(snapshot.error);
    }
    
    // 3. No data
    if (!snapshot.hasData) {
      return Text("No data");
    }
    
    // 4. Success
    final posts = snapshot.data!;
    return ListView.builder(...);
  },
)
```

### 3. Retry mechanism

```dart
void _retry() {
  setState(() {
    _postsFuture = ApiService.getPosts();  // Tạo Future mới
  });
}
```

---

# 11. **Bài tập thực hành**

1. **Gọi API thời tiết từ link public (OpenWeatherMap).**  
   → Tạo Weather model, ApiService, FutureBuilder

2. **Làm màn hình danh sách ảnh từ API `picsum.photos`.**  
   → Xem ví dụ 8.4

3. **Tạo model User và fetch danh sách User từ API.**  
   → Xem ví dụ 8.2

4. **Tạo Button "Làm mới" và fetch lại dữ liệu.**  
   → Xem ví dụ 8.2 với RefreshIndicator

5. **Tách API logic vào ApiService hoàn chỉnh.**  
   → Xem phần 6

6. **Tạo màn hình tạo bài viết với form validation.**  
   → Xem ví dụ 8.3

7. **Tạo search screen với debounce.**  
   → Xem ví dụ 8.5

8. **Tạo app quản lý sản phẩm:**
   - GET: Lấy danh sách sản phẩm
   - POST: Tạo sản phẩm mới
   - PUT: Cập nhật sản phẩm
   - DELETE: Xóa sản phẩm

9. **Tích hợp API với Provider:**
   - UserProvider: Login, logout
   - ProductProvider: Load products từ API
   - CartProvider: Thêm sản phẩm vào giỏ

10. **Tạo app thời tiết hoàn chỉnh:**
    - Lấy thời tiết theo thành phố
    - Hiển thị nhiệt độ, mô tả, icon
    - Pull-to-refresh
    - Xử lý lỗi mạng  

---

# 12. **CASE STUDY: Xây dựng ứng dụng Todo REST API hoàn chỉnh**

Đây là phần quan trọng nhất để tổng hợp kiến thức. Chúng ta sẽ xây dựng một ứng dụng **Quản lý công việc (Todo App)** với đầy đủ các tính năng CRUD (Create, Read, Update, Delete) tương tác với một Mock API.

Để thực hành, chúng ta sẽ dùng mock API miễn phí: `https://jsonplaceholder.typicode.com/todos`  
(Lưu ý: API này chỉ "giả lập" các thay đổi, dữ liệu không thực sự lưu lại trên server sau khi refresh, nhưng response trả về đúng chuẩn RESTful).

---

## 12.1. **Phân tích bài toán & Tư duy thiết kế**

Trước khi code, hãy tư duy về **Luồng dữ liệu (Data Flow)**:

1.  **GET /todos**: Lấy danh sách công việc về hiển thị.
2.  **POST /todos**: Gửi công việc mới lên server -> nhận về object vừa tạo -> thêm vào list hiển thị.
3.  **PATCH /todos/{id}**: Gửi trạng thái `completed: true/false` -> cập nhật UI.
4.  **DELETE /todos/{id}**: Gửi lệnh xóa -> xóa khỏi list hiển thị.

**Kiến trúc đơn giản cho bài này:**

```
lib/
├── models/
│   └── todo.dart        # Chứa dữ liệu (id, title, completed)
├── services/
│   └── todo_service.dart # Chứa logic gọi API (http get, post...)
└── screens/
    └── todo_screen.dart  # Chứa UI & Logic cập nhật state
```

---

## 12.2. **Bước 1: Thiết kế Model (Data Layer)**

Dữ liệu JSON trả về từ API có dạng:
```json
{
  "userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
}
```

Tạo file `lib/models/todo.dart`:

```dart
class Todo {
  final int id;
  final String title;
  bool completed; // Không final để có thể thay đổi trạng thái ở UI

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  // Factory constructor: Parse JSON thành Object
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }

  // Method: Chuyển Object thành JSON (để gửi lên server)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}
```

> **Góc chuyên gia:**  
> Tại sao `completed` không phải là `final`?  
> Trong các architecture phức tạp (như BLoC, Redux), model thường là `immutable` (bất biến - tất cả đều final). Khi cần sửa, ta tạo ra một object mới (copy). Tuy nhiên, với ví dụ đơn giản này dùng `setState`, việc để `completed` có thể thay đổi (mutable) giúp code gọn hơn khi cập nhật checkbox.

---

## 12.3. **Bước 2: Xây dựng Service (API Layer)**

Tạo file `lib/services/todo_service.dart`.  
Class này chịu trách nhiệm **duy nhất** là giao tiếp với Server. Tuyệt đối không để code UI (như `showDialog`, `SnackBar`) vào đây.

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class TodoService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';
  
  // Headers mặc định cho các request POST/PUT/PATCH
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // 1. Lấy danh sách Todos (GET)
  // Limit=10 để demo cho gọn, tránh lấy cả 200 items
  static Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('$baseUrl?_limit=10'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      // Convert List<dynamic> -> List<Todo>
      return body.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách công việc');
    }
  }

  // 2. Thêm Todo mới (POST)
  static Future<Todo> addTodo(String title) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'completed': false,
        'userId': 1, // Mock API yêu cầu field này
      }),
    );

    if (response.statusCode == 201) { // 201 Created
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Thêm thất bại');
    }
  }

  // 3. Cập nhật trạng thái (PATCH)
  // Dùng PATCH thay vì PUT vì ta chỉ update 1 trường 'completed'
  static Future<Todo> updateTodoStatus(int id, bool status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: _headers,
      body: jsonEncode({'completed': status}),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Cập nhật thất bại');
    }
  }

  // 4. Xóa Todo (DELETE)
  static Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Xóa thất bại');
    }
  }
}
```

> **Lưu ý quan trọng:**  
> - Luôn kiểm tra `statusCode` chuẩn (200 cho OK, 201 cho Created).  
> - Dùng `jsonEncode` để chuyển Map -> String khi gửi đi.  
> - Headers `Content-Type: application/json` là bắt buộc với hầu hết API hiện đại khi gửi body.

---

## 12.4. **Bước 3: Xây dựng UI (Presentation Layer)**

Tạo file `lib/screens/todo_screen.dart`.  
Ở đây ta sẽ dùng chiến thuật:
1.  Load dữ liệu lần đầu bằng `initState`.
2.  Sau mỗi hành động (Thêm/Sửa/Xóa), ta cập nhật trực tiếp vào List local để UI phản hồi ngay lập tức (**Optimistic UI**) hoặc fetch lại data tùy chiến lược. Ở đây, vì Mock API không lưu data thật, ta sẽ **cập nhật List local** dựa trên response trả về.

```dart
import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // State quản lý danh sách
  List<Todo> _todos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  // Hàm load dữ liệu tách riêng để tái sử dụng
  Future<void> _loadTodos() async {
    try {
      final todos = await TodoService.fetchTodos();
      if (mounted) {
        setState(() {
          _todos = todos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Hàm xử lý Thêm Todo
  Future<void> _processAddTodo(String title) async {
    // 1. Show loading (nếu muốn) hoặc disable nút
    try {
      // 2. Gọi API
      final newTodo = await TodoService.addTodo(title);
      
      // 3. API thành công -> Update UI
      if (mounted) {
        setState(() {
          // Thêm vào đầu danh sách
          _todos.insert(0, newTodo); 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm công việc!')),
        );
      }
    } catch (e) {
      // Xử lý lỗi
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  // Hàm xử lý Xóa Todo
  Future<void> _processDeleteTodo(int id) async {
    // Optimistic Update: Xóa trên UI trước cho mượt
    final index = _todos.indexWhere((element) => element.id == id);
    final backupItem = _todos[index]; // Backup để restore nếu lỗi

    setState(() {
      _todos.removeAt(index);
    });

    try {
      await TodoService.deleteTodo(id);
      // Thành công thì không cần làm gì thêm vì đã xóa ở UI rồi
    } catch (e) {
      // Thất bại -> Khôi phục lại UI
      if (mounted) {
        setState(() {
          _todos.insert(index, backupItem);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xóa thất bại!')));
      }
    }
  }

  // Hàm xử lý Toggle Status
  Future<void> _processToggle(Todo todo) async {
    // Save previous state
    final oldStatus = todo.completed;
    
    // Update UI ngay lập tức (Optimistic)
    setState(() {
      todo.completed = !oldStatus;
    });

    try {
      await TodoService.updateTodoStatus(todo.id, !oldStatus);
    } catch (e) {
      // Revert nếu lỗi
      if (mounted) {
        setState(() {
          todo.completed = oldStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi cập nhật!')));
      }
    }
  }

  // Hàm hiện Dialog thêm công việc
  void _showAddDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Công việc mới'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Nhập tên công việc...'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                _processAddTodo(textController.text);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Thêm'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo REST API'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTodos),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
                   const SizedBox(height: 16),
                   Text('Lỗi: $_error'),
                   ElevatedButton(onPressed: _loadTodos, child: const Text('Thử lại')),
                ],
              ),
            );
          }
          if (_todos.isEmpty) {
            return const Center(child: Text('Chưa có công việc nào'));
          }
          
          return RefreshIndicator(
            onRefresh: _loadTodos,
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Dismissible(
                  key: ValueKey(todo.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _processDeleteTodo(todo.id),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (_) => _processToggle(todo),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.completed 
                           ? TextDecoration.lineThrough 
                           : null,
                        color: todo.completed ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Text('ID: ${todo.id}'),
                  ),
                );
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

## 12.5. **Phân tích kỹ thuật các điểm "đắt giá" trong code trên**

1.  **Optimistic UI Update (Cập nhật lạc quan):**
    *   Trong hàm `_processToggle` và `_processDeleteTodo`, ta cập nhật UI (`setState`) **trước khi** gọi API.
    *   **Tại sao?** Giúp app phản hồi *ngay lập tức*, tạo cảm giác mượt mà (zero latency) cho người dùng.
    *   **Nếu API lỗi?** Ta có cơ chế `try...catch` để hoàn tác (revert) lại dữ liệu cũ và báo lỗi. Đây là kỹ thuật UX chuyên nghiệp.

2.  **Tách biệt logic (Separation of Concerns):**
    *   `TodoService` không biết gì về UI (không có `context`, không `SnackBar`).
    *   `TodoScreen` chỉ gọi hàm từ Service và xử lý kết quả để hiển thị.

3.  **Xử lý State linh hoạt:**
    *   Dùng biến `_isLoading` và `_error` để kiểm soát các trạng thái màn hình khác nhau.
    *   Dùng `mounted` check trước khi `setState` trong hàm async để tránh lỗi `setState() called after dispose()`.

4.  **Dismissible Widget:**
    *   Sử dụng Widget có sẵn của Flutter để làm tính năng "Vuốt để xóa" rất mượt mà.

Chúc mừng! Bạn đã hoàn thành một module "xương sống" của hầu hết các ứng dụng Mobile: Tương tác với REST API.

---

# 13. Mini Test cuối chương

**Câu 1:** http.get trả về gì?  
→ `Future<Response>` - Phải dùng await để lấy Response object.

**Câu 2:** jsonDecode làm gì?  
→ Chuyển JSON string → Map/List (Dart object).

**Câu 3:** FutureBuilder dùng khi nào?  
→ Khi muốn hiển thị dữ liệu từ Future/API, tự động rebuild theo trạng thái.

**Câu 4:** notifyListeners có liên quan trong networking không?  
→ Không trực tiếp (chỉ liên quan Provider). Networking dùng Future/async-await.

**Câu 5:** POST và GET khác nhau?  
→ GET lấy dữ liệu (không gửi body), POST gửi dữ liệu lên server (có body).

**Câu 6:** Tại sao cần await khi gọi http.get()?  
→ http.get() trả về Future, cần await để chờ response từ server.

**Câu 7:** Tại sao nên tách API logic vào Service?  
→ Tách biệt concerns, dễ test, dễ tái sử dụng, dễ maintain.

**Câu 8:** Các trạng thái của snapshot trong FutureBuilder?  
→ waiting (đang tải), hasError (có lỗi), hasData (có dữ liệu).

**Câu 9:** Tại sao cần timeout cho HTTP request?  
→ Tránh chờ mãi mãi khi mạng chậm hoặc server không phản hồi.

**Câu 10:** Model class giúp gì khi làm việc với API?  
→ Type-safe, dễ sử dụng, IDE autocomplete, tránh lỗi runtime.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **http** = gọi API, **JSON** = dữ liệu của API (text format).  
- **async–await** là nền tảng xử lý mạng (bất đồng bộ).  
- **FutureBuilder** giúp render UI theo trạng thái Future (waiting, error, success).  
- **Luôn tách API logic vào service** - UI chỉ hiển thị, Service xử lý API.  
- **Model class** giúp quản lý dữ liệu sạch và rõ ràng (type-safe).  
- **Luôn xử lý lỗi** - SocketException, TimeoutException, HTTP errors.  
- **Dùng timeout** cho mọi HTTP request để tránh chờ mãi mãi.  
- **Kiểm tra tất cả trạng thái** trong FutureBuilder (waiting, error, hasData).  
- **GET** lấy dữ liệu, **POST** gửi dữ liệu, **PUT** cập nhật, **DELETE** xóa.  
- **Tạo Future trong initState** (StatefulWidget) để tránh rebuild không cần thiết.  

---

# 🎉 Kết thúc chương 10  
Tiếp theo: App thật cần lưu dữ liệu cục bộ — đừng để mất khi tắt app.

👉 **Chương 11 – Local Storage (SharedPreferences, File, JSON local)**

