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
