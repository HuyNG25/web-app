# 🟦 CHƯƠNG 11  
# **LOCAL STORAGE TRONG FLUTTER**  
*(SharedPreferences – JSON local – File Storage – Lưu dữ liệu offline)*

Ứng dụng thực tế không chỉ chạy khi mở app — nó cần **ghi nhớ thông tin**:

- Lưu tài khoản đăng nhập  
- Lưu token của API  
- Lưu theme dark/light  
- Lưu danh sách ghi chú  
- Lưu giỏ hàng mini  
- Lưu cài đặt người dùng  

Chương này giúp bạn nắm **cách lưu dữ liệu cục bộ (local) đúng chuẩn**, dễ dùng, dùng được ngay.

---

# 🎯 MỤC TIÊU HỌC TẬP

Bạn sẽ biết cách:

- Lưu/lấy dữ liệu bằng SharedPreferences  
- Lưu JSON vào file  
- Đọc/ghi file trong Flutter  
- Hiểu khi nào nên dùng kiểu lưu nào  
- Tránh các lỗi phổ biến (null, future chưa hoàn thành)  
- Tạo ứng dụng mini lưu ghi chú offline

---

# 1. **SharedPreferences – dễ nhất, nhanh nhất**

Dùng để lưu dữ liệu **nhỏ**:

- bool  
- int  
- double
- String  
- List<String>  

Không dùng để lưu dữ liệu lớn.

---

### 🧠 Giảng giải chi tiết: SharedPreferences là gì?

**SharedPreferences là gì?**

- Cơ chế lưu trữ **key-value** đơn giản
- Dữ liệu được lưu **persistent** (tồn tại sau khi đóng app)
- Chỉ lưu được các kiểu dữ liệu cơ bản
- Tự động đồng bộ giữa các lần mở app

**Cơ chế hoạt động:**

```
SharedPreferences.getInstance()
    ↓
Lấy instance (singleton)
    ↓
Lưu dữ liệu: prefs.setString("key", "value")
    ↓
Dữ liệu được ghi vào storage
    ↓
Lần sau mở app: prefs.getString("key") → "value"
```

**Ví dụ minh họa từng bước:**

```dart
// BƯỚC 1: Lấy instance (chỉ cần 1 lần)
final prefs = await SharedPreferences.getInstance();
// ↑ Instance này có thể dùng lại nhiều lần

// BƯỚC 2: Lưu dữ liệu
await prefs.setString("username", "John");
// ↑ Key: "username", Value: "John"
// ↑ await: Đợi ghi xong mới tiếp tục

// BƯỚC 3: Lấy dữ liệu
final username = prefs.getString("username");
// ↑ Trả về "John" hoặc null nếu chưa có

// BƯỚC 4: Xóa dữ liệu
await prefs.remove("username");
// hoặc
await prefs.clear();  // Xóa tất cả
```

**Các kiểu dữ liệu có thể lưu:**

```dart
// String
await prefs.setString("name", "John");
String? name = prefs.getString("name");

// int
await prefs.setInt("age", 25);
int? age = prefs.getInt("age");

// double
await prefs.setDouble("height", 1.75);
double? height = prefs.getDouble("height");

// bool
await prefs.setBool("isDarkMode", true);
bool? isDark = prefs.getBool("isDarkMode");

// List<String>
await prefs.setStringList("favorites", ["A", "B", "C"]);
List<String>? favorites = prefs.getStringList("favorites");
```

**Lưu ý quan trọng:**

- Tất cả thao tác đều là **async** (phải dùng await)
- Giá trị trả về có thể **null** nếu key chưa tồn tại
- Dùng `??` để set giá trị mặc định

---

# 2. **Cài package**

Trong pubspec.yaml:

```yaml
dependencies:
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1  # Cho file storage
```

Import:

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
```

---

# 3. **Lưu dữ liệu**

Ví dụ: lưu tên người dùng.

```dart
Future<void> saveName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("username", name);
}
```

---

### 🧠 Giảng giải chi tiết: Lưu dữ liệu với SharedPreferences

**Ví dụ minh họa từng bước:**

```dart
// ✅ ĐÚNG: Lưu dữ liệu đầy đủ
Future<void> saveUserData({
  required String name,
  required int age,
  required bool isDarkMode,
}) async {
  // BƯỚC 1: Lấy instance
  final prefs = await SharedPreferences.getInstance();
  
  // BƯỚC 2: Lưu từng giá trị
  await prefs.setString("username", name);
  await prefs.setInt("age", age);
  await prefs.setBool("isDarkMode", isDarkMode);
  
  // ✅ QUAN TRỌNG: Phải await để đảm bảo ghi xong
  print("Đã lưu dữ liệu!");
}

// ❌ SAI: Quên await
Future<void> saveNameWrong(String name) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("username", name);  // ← Quên await!
  // Dữ liệu có thể chưa được ghi khi hàm kết thúc
}
```

**Flow minh họa:**

```
User nhấn nút "Lưu"
    ↓
saveName("John") được gọi
    ↓
SharedPreferences.getInstance() → Lấy instance
    ↓
prefs.setString("username", "John") → Ghi vào storage
    ↓
await → Đợi ghi xong
    ↓
Dữ liệu đã được lưu persistent
    ↓
Lần sau mở app: prefs.getString("username") → "John" ✅
```

---

# 4. **Lấy dữ liệu**

```dart
Future<String?> getName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("username");
}
```

---

### 🧠 Giảng giải chi tiết: Lấy dữ liệu với SharedPreferences

**Ví dụ minh họa từng bước:**

```dart
// ✅ ĐÚNG: Lấy dữ liệu với giá trị mặc định
Future<String> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  // Dùng ?? để set giá trị mặc định nếu null
  return prefs.getString("username") ?? "Guest";
}

// ✅ ĐÚNG: Kiểm tra null
Future<void> loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  
  final username = prefs.getString("username");
  if (username != null) {
    print("Username: $username");
  } else {
    print("Chưa có username");
  }
  
  final age = prefs.getInt("age") ?? 0;  // Mặc định = 0
  final isDark = prefs.getBool("isDarkMode") ?? false;  // Mặc định = false
}
```

**Lưu ý quan trọng:**

- Giá trị trả về có thể **null** nếu key chưa tồn tại
- Luôn dùng `??` để set giá trị mặc định
- Kiểm tra null trước khi dùng

---

# 5. **Lưu danh sách (List<String>)**

```dart
prefs.setStringList("favs", ["A", "B", "C"]);
```

Lấy lại:

```dart
prefs.getStringList("favs");
```

---

### 🧠 Giảng giải chi tiết: Lưu List với SharedPreferences

**Ví dụ minh họa:**

```dart
// ✅ ĐÚNG: Lưu danh sách
Future<void> saveFavorites(List<String> favorites) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList("favorites", favorites);
}

// ✅ ĐÚNG: Lấy danh sách với giá trị mặc định
Future<List<String>> getFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("favorites") ?? [];  // Mặc định = []
}

// ✅ ĐÚNG: Thêm item vào danh sách
Future<void> addFavorite(String item) async {
  final prefs = await SharedPreferences.getInstance();
  final favorites = prefs.getStringList("favorites") ?? [];
  favorites.add(item);
  await prefs.setStringList("favorites", favorites);
}

// ✅ ĐÚNG: Xóa item khỏi danh sách
Future<void> removeFavorite(String item) async {
  final prefs = await SharedPreferences.getInstance();
  final favorites = prefs.getStringList("favorites") ?? [];
  favorites.remove(item);
  await prefs.setStringList("favorites", favorites);
}
```

---

### 🎒 Ví dụ đời sống  
SharedPreferences giống như **ngăn kéo nhỏ** cạnh bàn học —  
chỉ để được vài món quan trọng: giấy note, tấm thẻ, vài món đồ lặt vặt.

Không để vali to vào đó!

---

# 6. **Ví dụ hoàn chỉnh: Lưu trạng thái theme Light/Dark**

```dart
class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("theme") ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    isDark = !isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("theme", isDark);
    notifyListeners();
  }
}
```

---

# 7. **Lưu File – khi dữ liệu lớn hơn**

Dùng khi:

- lưu danh sách ghi chú  
- lưu nội dung JSON  
- lưu dữ liệu cỡ vừa  

Thư viện dùng:  
`dart:io` (⚠ Flutter Web không hỗ trợ)

---

### 🧠 Giảng giải chi tiết: File Storage là gì?

**File Storage là gì?**

- Lưu dữ liệu dưới dạng **file** trong hệ thống
- Phù hợp cho dữ liệu **lớn hơn** SharedPreferences
- Có thể lưu JSON, text, binary data
- Cần dùng `path_provider` để lấy đường dẫn thư mục

**Cơ chế hoạt động:**

```
getApplicationDocumentsDirectory()
    ↓
Lấy thư mục lưu file của app
    ↓
Tạo File object với đường dẫn
    ↓
Ghi/đọc file: file.writeAsString() / file.readAsString()
    ↓
Dữ liệu được lưu persistent
```

**Các loại thư mục:**

```dart
// Thư mục documents (khuyến nghị)
final dir = await getApplicationDocumentsDirectory();
// Path: /data/user/0/com.example.app/files

// Thư mục temporary (sẽ bị xóa)
final tempDir = await getTemporaryDirectory();
// Path: /data/user/0/com.example.app/cache

// Thư mục external storage (Android)
final externalDir = await getExternalStorageDirectory();
// Path: /storage/emulated/0/Android/data/com.example.app/files
```

---

## Lấy thư mục lưu file (application directory)

```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getFilePath() async {
  final dir = await getApplicationDocumentsDirectory();
  return "${dir.path}/notes.json";
}
```

---

### 🧠 Giảng giải chi tiết: path_provider

**path_provider là gì?**

- Package cung cấp đường dẫn thư mục của app
- Tự động xử lý khác biệt giữa Android/iOS
- Đảm bảo thư mục tồn tại và có quyền truy cập

**Ví dụ minh họa:**

```dart
// ✅ ĐÚNG: Lấy thư mục documents
Future<String> getNotesPath() async {
  final dir = await getApplicationDocumentsDirectory();
  // dir.path = "/data/user/0/com.example.app/files"
  return "${dir.path}/notes.json";
  // Return: "/data/user/0/com.example.app/files/notes.json"
}

// ✅ ĐÚNG: Tạo thư mục con nếu cần
Future<String> getDataPath(String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final dataDir = Directory("${dir.path}/data");
  
  // Tạo thư mục nếu chưa có
  if (!await dataDir.exists()) {
    await dataDir.create(recursive: true);
  }
  
  return "${dataDir.path}/$filename";
}
```

---

## Ghi file:

```dart
Future<void> writeFile(String content) async {
  final path = await getFilePath();
  final file = File(path);
  await file.writeAsString(content);
}
```

---

### 🧠 Giảng giải chi tiết: Ghi file

**Ví dụ minh họa từng bước:**

```dart
// ✅ ĐÚNG: Ghi file đầy đủ
Future<void> writeFile(String content) async {
  // BƯỚC 1: Lấy đường dẫn
  final path = await getFilePath();
  
  // BƯỚC 2: Tạo File object
  final file = File(path);
  
  // BƯỚC 3: Ghi nội dung
  await file.writeAsString(content);
  // ↑ await: Đợi ghi xong
}

// ✅ ĐÚNG: Ghi file với error handling
Future<bool> writeFileSafe(String content) async {
  try {
    final path = await getFilePath();
    final file = File(path);
    await file.writeAsString(content);
    return true;  // Thành công
  } catch (e) {
    print("Lỗi ghi file: $e");
    return false;  // Thất bại
  }
}

// ✅ ĐÚNG: Ghi file với mode append
Future<void> appendToFile(String content) async {
  final path = await getFilePath();
  final file = File(path);
  await file.writeAsString(
    content,
    mode: FileMode.append,  // Thêm vào cuối file
  );
}
```

**Các mode ghi file:**

- `FileMode.write` - Ghi đè (mặc định)
- `FileMode.append` - Thêm vào cuối
- `FileMode.read` - Chỉ đọc
- `FileMode.writeOnly` - Chỉ ghi

---

## Đọc file:

```dart
Future<String> readFile() async {
  final path = await getFilePath();
  final file = File(path);
  return await file.readAsString();
}
```

---

### 🧠 Giảng giải chi tiết: Đọc file

**Ví dụ minh họa từng bước:**

```dart
// ✅ ĐÚNG: Đọc file đầy đủ
Future<String> readFile() async {
  // BƯỚC 1: Lấy đường dẫn
  final path = await getFilePath();
  
  // BƯỚC 2: Tạo File object
  final file = File(path);
  
  // BƯỚC 3: Kiểm tra file tồn tại
  if (await file.exists()) {
    // BƯỚC 4: Đọc nội dung
    return await file.readAsString();
  } else {
    return "";  // File chưa tồn tại
  }
}

// ✅ ĐÚNG: Đọc file với error handling
Future<String?> readFileSafe() async {
  try {
    final path = await getFilePath();
    final file = File(path);
    
    if (await file.exists()) {
      return await file.readAsString();
    } else {
      return null;  // File chưa tồn tại
    }
  } catch (e) {
    print("Lỗi đọc file: $e");
    return null;
  }
}

// ✅ ĐÚNG: Đọc file theo dòng
Future<List<String>> readFileLines() async {
  final path = await getFilePath();
  final file = File(path);
  
  if (await file.exists()) {
    return await file.readAsLines();  // Trả về List<String>
  } else {
    return [];
  }
}
```

---

# 8. **Lưu JSON vào file**

Ví dụ: danh sách ghi chú:

```dart
List<Map<String, dynamic>> notes = [
  {"title": "Học Flutter", "done": false},
  {"title": "Mua trà sữa", "done": true},
];
```

### Ghi:

```dart
writeFile(jsonEncode(notes));
```

### Đọc:

```dart
final jsonStr = await readFile();
final data = jsonDecode(jsonStr);
```

---

### 🧠 Giảng giải chi tiết: Lưu JSON vào file

**Tại sao cần lưu JSON?**

- JSON là format phổ biến để trao đổi dữ liệu
- Dễ parse, dễ đọc
- Có thể lưu object phức tạp

**Ví dụ minh họa từng bước:**

```dart
// BƯỚC 1: Chuẩn bị dữ liệu
List<Map<String, dynamic>> notes = [
  {"id": 1, "title": "Học Flutter", "done": false},
  {"id": 2, "title": "Mua trà sữa", "done": true},
];

// BƯỚC 2: Convert sang JSON string
String jsonString = jsonEncode(notes);
// jsonString = '[{"id":1,"title":"Học Flutter","done":false},...]'

// BƯỚC 3: Ghi vào file
await writeFile(jsonString);

// BƯỚC 4: Đọc từ file
String jsonStr = await readFile();

// BƯỚC 5: Parse JSON string → Dart object
List<dynamic> data = jsonDecode(jsonStr);
List<Map<String, dynamic>> notes = data.cast<Map<String, dynamic>>();
```

**Ví dụ minh họa: Lưu object phức tạp**

```dart
// Model
class Note {
  final int id;
  final String title;
  final bool done;
  
  Note({required this.id, required this.title, required this.done});
  
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "done": done,
    };
  }
  
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["id"] as int,
      title: json["title"] as String,
      done: json["done"] as bool,
    );
  }
}

// Lưu danh sách Note
Future<void> saveNotes(List<Note> notes) async {
  // Convert List<Note> → List<Map>
  final jsonList = notes.map((note) => note.toJson()).toList();
  
  // Convert List<Map> → JSON string
  final jsonString = jsonEncode(jsonList);
  
  // Ghi vào file
  final path = await getFilePath();
  final file = File(path);
  await file.writeAsString(jsonString);
}

// Đọc danh sách Note
Future<List<Note>> loadNotes() async {
  try {
    final path = await getFilePath();
    final file = File(path);
    
    if (!await file.exists()) {
      return [];  // File chưa tồn tại
    }
    
    // Đọc JSON string
    final jsonString = await file.readAsString();
    
    // Parse JSON string → List<dynamic>
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    
    // Convert List<dynamic> → List<Note>
    return jsonList
      .map((json) => Note.fromJson(json as Map<String, dynamic>))
      .toList();
  } catch (e) {
    print("Lỗi đọc notes: $e");
    return [];
  }
}
```

**Ví dụ minh họa: Lưu object đơn**

```dart
// Lưu User object
Future<void> saveUser(User user) async {
  final jsonString = jsonEncode(user.toJson());
  final path = await getUserPath();
  final file = File(path);
  await file.writeAsString(jsonString);
}

// Đọc User object
Future<User?> loadUser() async {
  try {
    final path = await getUserPath();
    final file = File(path);
    
    if (!await file.exists()) {
      return null;
    }
    
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.fromJson(json);
  } catch (e) {
    print("Lỗi đọc user: $e");
    return null;
  }
}
```

---

# 9. **Khi nào dùng SharedPreferences? Khi nào dùng file?**

| Trường hợp | Nên dùng |
|------------|----------|
| Lưu token | SharedPreferences |
| Lưu cài đặt | SharedPreferences |
| Lưu danh sách nhỏ | SharedPreferences |
| Lưu dữ liệu nhiều dòng | File |
| Lưu JSON size lớn | File |
| Lưu tài liệu, text dài | File |
| Lưu database quan hệ | Sqflite (sẽ học chương sau) |

---

# 10. **Sai vs Đúng (lỗi sinh viên hay gặp)**

## ❌ Sai: quên await → dữ liệu chưa lưu

```dart
prefs.setString("key", value); // Không await!
```

---

### 🔍 Giảng giải chi tiết: Tại sao quên await gây lỗi?

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Quên await
Future<void> saveName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("username", name);  // ← Quên await!
  print("Đã lưu!");  // ← In ra ngay, nhưng dữ liệu có thể chưa ghi xong!
}

// Vấn đề:
// - setString() trả về Future<bool>
// - Không có await → không đợi ghi xong
// - App có thể đóng trước khi ghi xong → mất dữ liệu
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Có await
Future<void> saveName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("username", name);  // ← Có await!
  print("Đã lưu!");  // ← Chỉ in ra sau khi ghi xong
}
```

---

## ✔ Đúng:

```dart
await prefs.setString("key", value);
```

---

## ❌ Sai: lưu object vào SharedPreferences

```dart
// ❌ SAI: Lưu object trực tiếp
prefs.setString("user", userObject);  // ← Lỗi! userObject không phải String
```

---

### 🔍 Giảng giải chi tiết: Tại sao không lưu object trực tiếp?

**Ví dụ minh họa lỗi:**

```dart
class User {
  final String name;
  final int age;
  User({required this.name, required this.age});
}

// ❌ SAI: Lưu object trực tiếp
Future<void> saveUserWrong(User user) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("user", user);  // ← Lỗi compile! User không phải String
}

// ❌ SAI: Lưu object bằng toString()
Future<void> saveUserWrong2(User user) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("user", user.toString());  // ← Lưu được nhưng không parse lại được!
}
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Convert sang JSON trước
Future<void> saveUser(User user) async {
  final prefs = await SharedPreferences.getInstance();
  // Convert User → Map → JSON string
  final jsonString = jsonEncode({
    "name": user.name,
    "age": user.age,
  });
  await prefs.setString("user", jsonString);
}

// ✅ ĐÚNG: Đọc lại
Future<User?> loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString("user");
  
  if (jsonString == null) return null;
  
  // Parse JSON string → Map → User
  final json = jsonDecode(jsonString) as Map<String, dynamic>;
  return User(
    name: json["name"] as String,
    age: json["age"] as int,
  );
}
```

---

## ✔ Đúng:

```dart
prefs.setString("user", jsonEncode(userObject));
```

---

## ❌ Sai: viết file trong build()  
→ build chạy liên tục → app lag

---

### 🔍 Giảng giải chi tiết: Tại sao không viết file trong build()?

**Ví dụ minh họa lỗi:**

```dart
class NoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ SAI: Ghi file trong build()
    writeFile("some content");  // ← build() chạy nhiều lần → ghi file nhiều lần!
    
    return Scaffold(...);
  }
}

// Vấn đề:
// - build() chạy mỗi khi widget rebuild
// - Ghi file trong build() → ghi file nhiều lần không cần thiết
// - App lag, performance kém
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Ghi file trong method riêng
class NoteScreen extends StatefulWidget {
  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  Future<void> saveNotes() async {
    // Ghi file ở đây, gọi từ button hoặc initState
    await writeFile("content");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: saveNotes,  // ← Gọi từ button
        child: Text("Lưu"),
      ),
    );
  }
}
```

---

## ✔ Đúng: viết file trong hàm riêng, gọi từ button hoặc initState

---

## ❌ Sai: quên import path_provider  
→ không lấy được directory

---

### 🔍 Giảng giải chi tiết: Lỗi quên import

**Ví dụ minh họa lỗi:**

```dart
// ❌ SAI: Quên import
// import 'package:path_provider/path_provider.dart';  // ← Quên!

Future<String> getFilePath() async {
  final dir = await getApplicationDocumentsDirectory();  // ← Lỗi! Không tìm thấy function
  return "${dir.path}/notes.json";
}
```

**✅ Giải pháp:**

```dart
// ✅ ĐÚNG: Có import đầy đủ
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

Future<String> getFilePath() async {
  final dir = await getApplicationDocumentsDirectory();  // ← OK!
  return "${dir.path}/notes.json";
}
```

---

## 🔴 Case Study: Các lỗi khác thường gặp

### Case Study 1: Quên kiểm tra null khi đọc

#### ❌ Vấn đề:

```dart
Future<void> loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString("username");
  print(username.length);  // ← Crash nếu username = null!
}
```

#### ✅ Giải pháp:

```dart
Future<void> loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString("username") ?? "Guest";  // ← Giá trị mặc định
  print(username.length);  // ← An toàn
}
```

---

### Case Study 2: Quên kiểm tra file tồn tại

#### ❌ Vấn đề:

```dart
Future<String> readFile() async {
  final path = await getFilePath();
  final file = File(path);
  return await file.readAsString();  // ← Crash nếu file chưa tồn tại!
}
```

#### ✅ Giải pháp:

```dart
Future<String> readFile() async {
  final path = await getFilePath();
  final file = File(path);
  
  if (await file.exists()) {
    return await file.readAsString();
  } else {
    return "";  // ← Trả về giá trị mặc định
  }
}
```

---

### Case Study 3: Ghi file không có error handling

#### ❌ Vấn đề:

```dart
Future<void> saveData(String data) async {
  final file = File(await getFilePath());
  await file.writeAsString(data);  // ← Crash nếu không có quyền ghi!
}
```

#### ✅ Giải pháp:

```dart
Future<bool> saveData(String data) async {
  try {
    final file = File(await getFilePath());
    await file.writeAsString(data);
    return true;  // Thành công
  } catch (e) {
    print("Lỗi ghi file: $e");
    return false;  // Thất bại
  }
}
```

---

### Case Study 4: Lưu dữ liệu lớn vào SharedPreferences

#### ❌ Vấn đề:

```dart
// ❌ SAI: Lưu danh sách lớn vào SharedPreferences
Future<void> saveLargeList(List<String> items) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList("items", items);  // ← items có 10000 phần tử!
  // SharedPreferences không phù hợp cho dữ liệu lớn
}
```

#### ✅ Giải pháp:

```dart
// ✅ ĐÚNG: Lưu vào file
Future<void> saveLargeList(List<String> items) async {
  final jsonString = jsonEncode(items);
  final file = File(await getFilePath());
  await file.writeAsString(jsonString);  // ← File phù hợp hơn
}
```

---

# 11. **Best Practices & Performance**

## 11.1. **Khi nào dùng SharedPreferences vs File?**

**SharedPreferences - Dùng khi:**
- Dữ liệu nhỏ (< 1MB)
- Cài đặt, token, flag
- Danh sách ngắn (< 100 items)
- Cần truy cập nhanh

**File Storage - Dùng khi:**
- Dữ liệu lớn (> 1MB)
- JSON phức tạp
- Danh sách dài (> 100 items)
- Cần lưu nhiều file

**Bảng so sánh:**

| Đặc điểm | SharedPreferences | File Storage |
|----------|------------------|--------------|
| **Kích thước** | Nhỏ (< 1MB) | Lớn (không giới hạn) |
| **Tốc độ** | Rất nhanh | Nhanh |
| **Dễ dùng** | Rất dễ | Dễ |
| **Kiểu dữ liệu** | Cơ bản (String, int, bool...) | Bất kỳ (JSON, text, binary) |
| **Ví dụ** | Token, theme, settings | Notes, logs, cache |

---

## 11.2. **Best Practices**

1. **Luôn dùng await** cho thao tác async.
2. **Luôn kiểm tra null** và set giá trị mặc định.
3. **Xử lý lỗi đầy đủ** với try-catch.
4. **Tách logic storage** vào Service class.
5. **Cache SharedPreferences instance** nếu gọi nhiều lần.
6. **Kiểm tra file tồn tại** trước khi đọc.
7. **Dùng Model class** cho JSON để đảm bảo type-safe.

---

# 12. **CASE STUDY 1: Ứng dụng Ghi chú Offline (File + JSON)**

Chúng ta sẽ xây dựng một ứng dụng ghi chú đơn giản, **lưu trữ dữ liệu vào file JSON local**. Dữ liệu vẫn còn nguyên ngay cả khi tắt ứng dụng.

**Cấu trúc dự án:**
```
lib/
  models/
    note.dart
  services/
    note_storage.dart
  screens/
    note_screen.dart
```

### Bước 1: Tạo Model (`models/note.dart`)

```dart
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isCompleted;
  
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isCompleted = false,
  });
  
  // Chuyển Object -> JSON Map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "createdAt": createdAt.toIso8601String(),
      "isCompleted": isCompleted,
    };
  }
  
  // Chuyển JSON Map -> Object
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["id"] as String,
      title: json["title"] as String,
      content: json["content"] as String,
      createdAt: DateTime.parse(json["createdAt"] as String),
      isCompleted: json["isCompleted"] as bool? ?? false,
    );
  }
}
```

### Bước 2: Tạo Service (`services/note_storage.dart`)

Class này quản lý việc đọc/ghi file.

```dart
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class NoteStorage {
  // Lấy đường dẫn file lưu trữ
  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/notes.json";
  }
  
  // Đọc danh sách ghi chú từ file
  Future<List<Note>> loadNotes() async {
    try {
      final file = File(await _getFilePath());
      
      // Nếu file chưa tồn tại -> trả về list rỗng
      if (!await file.exists()) return [];
      
      final jsonString = await file.readAsString();
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      
      return jsonList
        .map((json) => Note.fromJson(json as Map<String, dynamic>))
        .toList();
    } catch (e) {
      print("Lỗi đọc file: $e");
      return [];
    }
  }
  
  // Lưu danh sách ghi chú vào file
  Future<bool> saveNotes(List<Note> notes) async {
    try {
      final jsonList = notes.map((note) => note.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      final file = File(await _getFilePath());
      await file.writeAsString(jsonString);
      
      return true;
    } catch (e) {
      print("Lỗi ghi file: $e");
      return false;
    }
  }
}
```

### Bước 3: Tích hợp UI (`screens/note_screen.dart`)

Load data ở `initState`, thêm/sửa/xóa gọi Service và cập nhật UI.

*(Code UI tương tự như ví dụ trước, tập trung vào logic gọi `_storage.saveNotes` mỗi khi dữ liệu thay đổi)*

---

# 13. **CASE STUDY 2: Quản lý Cài đặt (SharedPreferences)**

Ứng dụng settings cho phép người dùng lưu: Theme (Sáng/Tối), Ngôn ngữ (Vi/En), và có nhận thông báo hay không.

**Cấu trúc:**
```
lib/
  services/
    settings_service.dart
  screens/
    settings_screen.dart
```

### Bước 1: Tạo Service (`services/settings_service.dart`)

```dart
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _keyTheme = 'is_dark_mode';
  static const _keyLanguage = 'language_code';
  static const _keyNotif = 'notifications_enabled';

  // --- THEME ---
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTheme, isDark);
  }

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTheme) ?? false; // Mặc định là Sáng (false)
  }

  // --- LANGUAGE ---
  static Future<void> saveLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, langCode);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'vi'; // Mặc định Tiếng Việt
  }

  // --- NOTIFICATIONS ---
  static Future<void> saveNotification(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotif, isEnabled);
  }

  static Future<bool> getNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotif) ?? true; // Mặc định là Bật
  }
}
```

### Bước 2: UI Màn hình Cài đặt (`screens/settings_screen.dart`)

```dart
import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDark = false;
  String _language = 'vi';
  bool _isNotifEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load tất cả cài đặt cùng lúc
  Future<void> _loadSettings() async {
    // Chạy song song cho nhanh
    final values = await Future.wait([
      SettingsService.getTheme(),
      SettingsService.getLanguage(),
      SettingsService.getNotification(),
    ]);

    if (mounted) {
      setState(() {
        _isDark = values[0] as bool;
        _language = values[1] as String;
        _isNotifEnabled = values[2] as bool;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text("Cài đặt")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Chế độ Tối"),
            value: _isDark,
            onChanged: (val) async {
              setState(() => _isDark = val);
              await SettingsService.saveTheme(val);
            },
          ),
          ListTile(
            title: const Text("Ngôn ngữ"),
            subtitle: Text(_language == 'vi' ? "Tiếng Việt" : "English"),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'vi', child: Text("VI")),
                DropdownMenuItem(value: 'en', child: Text("EN")),
              ],
              onChanged: (val) async {
                if (val != null) {
                  setState(() => _language = val);
                  await SettingsService.saveLanguage(val);
                }
              },
            ),
          ),
          SwitchListTile(
            title: const Text("Nhận thông báo"),
            value: _isNotifEnabled,
            onChanged: (val) async {
              setState(() => _isNotifEnabled = val);
              await SettingsService.saveNotification(val);
            },
          ),
        ],
      ),
    );
  }
}
```

---

# 14. **CASE STUDY 3: Todo App (SQLite)**


Khi dữ liệu lớn, có cấu trúc phức tạp (quan hệ bảng), hoặc cần truy vấn (search, sort, filter) nhanh, **SQLite** là lựa chọn số 1.

**Cài đặt:**

```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
```

## 14.1. **Cấu trúc cơ bản**

SQLite lưu dữ liệu trong **File** (ví dụ `demo.db`).
Mỗi **Table** (bảng) lưu các dòng dữ liệu giống nhau.

**Ví dụ:** Bảng `Todo`
| id | title | status |
|----|-------|--------|
| 1  | Học Flutter | 0 |
| 2  | Ngủ | 1 |

---

## 14.2. **CASE STUDY: Xây dựng Todo App với SQLite (Step-by-Step)**

Chúng ta sẽ xây dựng ứng dụng Todo hoàn chỉnh với `sqflite`.

### Bước 1: Tạo Model

SQLite làm việc với `Map<String, dynamic>`, nên Model cần hàm chuyển đổi.

```dart
class Todo {
  final int? id;
  final String title;
  final bool isDone;

  Todo({this.id, required this.title, this.isDone = false});

  // Convert Todo -> Map (để lưu vào DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // id auto-increment nên có thể null khi insert
      'title': title,
      'is_done': isDone ? 1 : 0, // SQLite không có bool, dùng int (0/1)
    };
  }

  // Convert Map -> Todo (để đọc từ DB)
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      isDone: map['is_done'] == 1,
    );
  }
}
```

### Bước 2: Tạo DatabaseHelper (Singleton)

Tạo file `services/database_helper.dart`. Đây là class quản lý kết nối DB.

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class DatabaseHelper {
  // Singleton pattern: Đảm bảo chỉ có 1 instance duy nhất
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter để lấy database. Nếu chưa có thì init.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  // Khởi tạo DB
  Future<Database> _initDB(String filePath) async {
    // Lấy đường dẫn thư mục mặc định của hệ thống
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, // Gọi khi DB được tạo lần đầu
    );
  }

  // Tạo bảng
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        is_done INTEGER NOT NULL
      )
    ''');
  }

  // --- CÁC HÀM CRUD ---

  // 1. Create (Thêm)
  Future<int> create(Todo todo) async {
    final db = await instance.database;
    // conflictAlgorithm: replace - nếu trùng ID thì ghi đè
    return await db.insert('todos', todo.toMap());
  }

  // 2. Read (Đọc tất cả)
  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;
    
    // Query và sắp xếp theo thời gian (mới nhất lên đầu nếu có field time)
    // Ở đây sắp xếp theo ID giảm dần
    final result = await db.query('todos', orderBy: 'id DESC');

    return result.map((json) => Todo.fromMap(json)).toList();
  }

  // 3. Update (Sửa)
  Future<int> update(Todo todo) async {
    final db = await instance.database;

    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?', // Điều kiện update
      whereArgs: [todo.id], // Tham số thay thế cho ?
    );
  }

  // 4. Delete (Xóa)
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Close DB (khi không dùng nữa, thường ít dùng trong app mobile)
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
```

### Bước 3: Tích hợp vào UI

```dart
class TodoScreen extends StatefulWidget {
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshTodos();
  }

  // Hàm load dữ liệu từ DB
  Future<void> refreshTodos() async {
    setState(() => isLoading = true);
    // Gọi DatabaseHelper
    todos = await DatabaseHelper.instance.readAllTodos();
    setState(() => isLoading = false);
  }

  Future<void> addTodo() async {
    final todo = Todo(title: "Việc mới ${DateTime.now().second}");
    await DatabaseHelper.instance.create(todo);
    refreshTodos(); // Load lại list
  }
  
  Future<void> toggleTodo(Todo todo) async {
    final newTodo = Todo(
      id: todo.id, 
      title: todo.title, 
      isDone: !todo.isDone
    );
    await DatabaseHelper.instance.update(newTodo);
    refreshTodos();
  }

  Future<void> deleteTodo(int id) async {
    await DatabaseHelper.instance.delete(id);
    refreshTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQLite Todo')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addTodo,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) => toggleTodo(todo),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTodo(todo.id!),
                  ),
                );
              },
            ),
    );
  }
}
```

## 14.3. **Lưu ý quan trọng với SQLite**

1. **Migration (Nâng cấp DB):**
   Khi bạn sửa cấu trúc bảng (ví dụ thêm cột `description`), bạn phải tăng `version` trong `openDatabase` và xử lý `onUpgrade`.
   
   ```dart
   openDatabase(
     path,
     version: 2, // Tăng version
     onUpgrade: (db, oldVersion, newVersion) async {
       if (oldVersion < 2) {
         await db.execute('ALTER TABLE todos ADD COLUMN description TEXT');
       }
     },
   )
   ```

2. **Kiểu dữ liệu:**
   SQLite chỉ hỗ trợ: `INTEGER`, `REAL`, `TEXT`, `BLOB`.
   - `bool` lưu là `INTEGER` (0/1).
   - `DateTime` lưu là `TEXT` (ISO8601 string) hoặc `INTEGER` (timestamp).

3. **Luôn đóng connection?**
   Với app Flutter đơn giản, bạn có thể giữ connection mở suốt vòng đời app (singleton).

---

# 14. Bài tập thực hành

1. Tạo app “Ghi nhớ tên người dùng” bằng SharedPreferences.  
2. Tạo app lưu trạng thái dark/light vào SharedPreferences.  
3. Tạo app ghi chú lưu JSON vào file.  
4. Tạo danh sách yêu thích sản phẩm (favorite list) và lưu với SharedPreferences.  
5. Tạo mini app nhập nhật ký, mỗi ngày một đoạn → lưu file.

---

# 15. Mini Test cuối chương

**Câu 1:** SharedPreferences lưu được loại dữ liệu gì?  
→ int, double, bool, String, List<String>.

**Câu 2:** File storage dùng để làm gì?  
→ lưu dữ liệu lớn hoặc dạng JSON.

**Câu 3:** jsonEncode làm gì?  
→ chuyển object → chuỗi JSON.

**Câu 4:** jsonDecode làm gì?  
→ chuyển chuỗi JSON → Map/List.

**Câu 5:** Tại sao không gọi writeFile trong build()?  
→ build chạy nhiều lần → lag và phản tác dụng.

**Câu 6:** Tại sao cần await khi lưu dữ liệu?  
→ Đảm bảo dữ liệu được ghi xong trước khi tiếp tục.

**Câu 7:** Khi nào dùng SharedPreferences vs File?  
→ SharedPreferences cho dữ liệu nhỏ, File cho dữ liệu lớn.

**Câu 8:** Tại sao cần kiểm tra null khi đọc dữ liệu?  
→ Key có thể chưa tồn tại → trả về null → crash nếu không kiểm tra.

**Câu 9:** path_provider dùng để làm gì?  
→ Lấy đường dẫn thư mục của app để lưu file.

**Câu 10:** Tại sao nên tách logic storage vào Service class?  
→ Tách biệt concerns, dễ test, dễ tái sử dụng, dễ maintain.

---

# 📝 Quick Notes (Ghi nhớ nhanh)

- **SharedPreferences** = dữ liệu nhỏ (< 1MB), cài đặt, token.  
- **File storage** = dữ liệu lớn hơn, JSON, danh sách dài.  
- **SQLite** = Dữ liệu có cấu trúc, quan hệ, cần query phức tạp.
- **Luôn await** thao tác ghi dữ liệu (setString, writeAsString).  
- **Không viết file** trong build() → gây lag.  
- **Lưu object** phải convert sang JSON (jsonEncode).  
- **Luôn kiểm tra null** và set giá trị mặc định (??).  
- **Xử lý lỗi** đầy đủ với try-catch.  
- **Tách logic** storage vào Service class.  
- **Kiểm tra file tồn tại** trước khi đọc.  
- **Dùng Model class** cho JSON (type-safe).

---

# 🎉 Kết thúc chương 11  
Tiếp theo, bạn sẽ học về **UI nâng cao và Widgets thường dùng**:

👉 **Chương 12 – Widgets Nâng Cao (ListTile, Card, Dialog, Drawer, BottomNav…)**

