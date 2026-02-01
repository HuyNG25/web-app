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
