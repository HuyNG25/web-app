# 🟦 THỰC HÀNH CHƯƠNG 11: LOCAL STORAGE TRONG FLUTTER

> **📌 DÀNH CHO NGƯỜI MỚI BẮT ĐẦU**
> 
> Bài thực hành này hướng dẫn cách lưu trữ dữ liệu cục bộ trong Flutter bằng SharedPreferences và File Storage.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Sử dụng SharedPreferences để lưu dữ liệu nhỏ
- ✅ Lưu và đọc file JSON
- ✅ Xây dựng ứng dụng ghi chú offline
- ✅ Quản lý cài đặt app

---

## 📋 CHECKLIST CHUẨN BỊ

Trước khi bắt đầu, đảm bảo bạn có:
- [ ] Flutter SDK đã cài đặt
- [ ] Kiến thức cơ bản về async/await
- [ ] Hiểu về Model class

---

## BÀI TẬP 1: SHAREDPREFERENCES CƠ BẢN

### Mục đích
Lưu và lấy dữ liệu đơn giản với SharedPreferences.

### Yêu cầu

1. **Thêm dependencies:**
Trong `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
```

Chạy: `flutter pub get`

2. **Tạo file service:**
Tạo `lib/services/storage_service.dart`:
```dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Lưu tên người dùng
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }
  
  // Lấy tên người dùng
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
  
  // Lưu tuổi
  static Future<void> saveAge(int age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age', age);
  }
  
  // Lấy tuổi
  static Future<int?> getAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('age');
  }
  
  // Lưu trạng thái dark mode
  static Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }
  
  // Lấy trạng thái dark mode
  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false; // Mặc định false
  }
  
  // Xóa tất cả
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
```

3. **Tạo UI để test:**
Tạo `lib/screens/storage_demo_screen.dart`:
```dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class StorageDemoScreen extends StatefulWidget {
  @override
  _StorageDemoScreenState createState() => _StorageDemoScreenState();
}

class _StorageDemoScreenState extends State<StorageDemoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isDarkMode = false;
  String? _savedName;
  int? _savedAge;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final name = await StorageService.getUserName();
    final age = await StorageService.getAge();
    final isDark = await StorageService.getDarkMode();
    
    setState(() {
      _savedName = name;
      _savedAge = age;
      _isDarkMode = isDark;
      if (name != null) _nameController.text = name;
      if (age != null) _ageController.text = age.toString();
    });
  }
  
  Future<void> _saveData() async {
    await StorageService.saveUserName(_nameController.text);
    await StorageService.saveAge(int.tryParse(_ageController.text) ?? 0);
    await StorageService.saveDarkMode(_isDarkMode);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã lưu thành công!')),
    );
    
    _loadData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SharedPreferences Demo')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên người dùng',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Tuổi',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Chế độ tối'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Lưu'),
            ),
            SizedBox(height: 24),
            if (_savedName != null || _savedAge != null)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dữ liệu đã lưu:', style: TextStyle(fontWeight: FontWeight.bold)),
                      if (_savedName != null) Text('Tên: $_savedName'),
                      if (_savedAge != null) Text('Tuổi: $_savedAge'),
                      Text('Dark mode: $_isDarkMode'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
```

### Kết quả mong đợi
- Lưu và lấy được dữ liệu từ SharedPreferences
- Dữ liệu vẫn còn sau khi đóng app

---

## BÀI TẬP 2: LƯU DANH SÁCH VỚI SHAREDPREFERENCES

### Mục đích
Lưu danh sách yêu thích với SharedPreferences.

### Yêu cầu

1. **Tạo service:**
Thêm vào `lib/services/storage_service.dart`:
```dart
// Lưu danh sách yêu thích
static Future<void> saveFavorites(List<String> favorites) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('favorites', favorites);
}

// Lấy danh sách yêu thích
static Future<List<String>> getFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('favorites') ?? [];
}

// Thêm vào danh sách yêu thích
static Future<void> addFavorite(String item) async {
  final prefs = await SharedPreferences.getInstance();
  final favorites = prefs.getStringList('favorites') ?? [];
  if (!favorites.contains(item)) {
    favorites.add(item);
    await prefs.setStringList('favorites', favorites);
  }
}

// Xóa khỏi danh sách yêu thích
static Future<void> removeFavorite(String item) async {
  final prefs = await SharedPreferences.getInstance();
  final favorites = prefs.getStringList('favorites') ?? [];
  favorites.remove(item);
  await prefs.setStringList('favorites', favorites);
}
```

2. **Tạo UI:**
Tạo `lib/screens/favorites_screen.dart`:
```dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favorites = [];
  final TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }
  
  Future<void> _loadFavorites() async {
    final favorites = await StorageService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }
  
  Future<void> _addFavorite() async {
    if (_controller.text.isEmpty) return;
    
    await StorageService.addFavorite(_controller.text);
    _controller.clear();
    _loadFavorites();
  }
  
  Future<void> _removeFavorite(String item) async {
    await StorageService.removeFavorite(item);
    _loadFavorites();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách yêu thích')),
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
                      hintText: 'Nhập item yêu thích...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addFavorite,
                  child: Text('Thêm'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final item = _favorites[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeFavorite(item),
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
- Lưu và quản lý được danh sách yêu thích
- Thêm/xóa item trong danh sách

---

## BÀI TẬP 3: LƯU FILE JSON

### Mục đích
Lưu và đọc dữ liệu phức tạp vào file JSON.

### Yêu cầu

1. **Thêm dependencies:**
```yaml
dependencies:
  path_provider: ^2.1.1
```

2. **Tạo Model:**
Tạo `lib/models/note.dart`:
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
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
  
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
```

3. **Tạo Storage Service:**
Tạo `lib/services/note_storage.dart`:
```dart
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class NoteStorage {
  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/notes.json';
  }
  
  Future<List<Note>> loadNotes() async {
    try {
      final file = File(await _getFilePath());
      
      if (!await file.exists()) {
        return [];
      }
      
      final jsonString = await file.readAsString();
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      
      return jsonList
          .map((json) => Note.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Lỗi đọc file: $e');
      return [];
    }
  }
  
  Future<bool> saveNotes(List<Note> notes) async {
    try {
      final jsonList = notes.map((note) => note.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      final file = File(await _getFilePath());
      await file.writeAsString(jsonString);
      
      return true;
    } catch (e) {
      print('Lỗi ghi file: $e');
      return false;
    }
  }
}
```

4. **Tạo UI:**
Tạo `lib/screens/notes_screen.dart`:
```dart
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_storage.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteStorage _storage = NoteStorage();
  List<Note> _notes = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }
  
  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });
    
    final notes = await _storage.loadNotes();
    
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }
  
  Future<void> _addNote(String title, String content) async {
    final note = Note(
      id: DateTime.now().toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    
    _notes.add(note);
    await _storage.saveNotes(_notes);
    _loadNotes();
  }
  
  Future<void> _deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _storage.saveNotes(_notes);
    _loadNotes();
  }
  
  Future<void> _toggleNote(String id) async {
    final note = _notes.firstWhere((note) => note.id == id);
    final index = _notes.indexOf(note);
    _notes[index] = Note(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      isCompleted: !note.isCompleted,
    );
    await _storage.saveNotes(_notes);
    _loadNotes();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Ghi chú')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: Text('Ghi chú')),
      body: _notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Chưa có ghi chú nào'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: note.isCompleted,
                      onChanged: (_) => _toggleNote(note.id),
                    ),
                    title: Text(
                      note.title,
                      style: TextStyle(
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(note.content),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteNote(note.id),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
  
  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm ghi chú'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Nội dung',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                _addNote(titleController.text, contentController.text);
                Navigator.pop(context);
              }
            },
            child: Text('Thêm'),
          ),
        ],
      ),
    );
  }
}
```

### Kết quả mong đợi
- Lưu và đọc được danh sách ghi chú từ file JSON
- Dữ liệu vẫn còn sau khi đóng app

---

## BÀI TẬP 4: ỨNG DỤNG CÀI ĐẶT

### Mục đích
Xây dựng màn hình cài đặt với SharedPreferences.

### Yêu cầu

Tạo `lib/screens/settings_screen.dart`:
```dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _language = 'vi';
  bool _notificationsEnabled = true;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final values = await Future.wait([
      StorageService.getDarkMode(),
      // Thêm các settings khác nếu cần
    ]);
    
    setState(() {
      _isDarkMode = values[0] as bool;
      _isLoading = false;
    });
  }
  
  Future<void> _saveDarkMode(bool value) async {
    await StorageService.saveDarkMode(value);
    setState(() {
      _isDarkMode = value;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Cài đặt')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: Text('Cài đặt')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Chế độ tối'),
            value: _isDarkMode,
            onChanged: _saveDarkMode,
          ),
          ListTile(
            title: Text('Ngôn ngữ'),
            subtitle: Text(_language == 'vi' ? 'Tiếng Việt' : 'English'),
            trailing: DropdownButton<String>(
              value: _language,
              items: [
                DropdownMenuItem(value: 'vi', child: Text('VI')),
                DropdownMenuItem(value: 'en', child: Text('EN')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _language = value;
                  });
                }
              },
            ),
          ),
          SwitchListTile(
            title: Text('Nhận thông báo'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
```

### Kết quả mong đợi
- Màn hình cài đặt hoàn chỉnh
- Lưu được các tùy chọn

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành tất cả bài tập, bạn nên:
- [ ] Sử dụng được SharedPreferences
- [ ] Lưu và đọc file JSON
- [ ] Xây dựng được ứng dụng ghi chú offline
- [ ] Quản lý được cài đặt app

---

## 🎉 KẾT THÚC

Chúc mừng! Bạn đã hoàn thành bài thực hành Local Storage.

👉 **Tiếp theo:** Bài 12 - Firebase hoặc các bài nâng cao khác
