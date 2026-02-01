import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/firestore_service.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  // Hiển thị dialog thêm công việc
  void _showAddDialog(BuildContext context) {
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
                // Gọi Service thêm vào Firestore
                FirestoreService().addTodo(textController.text);
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
        title: const Text('Todo Firebase'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      // StreamBuilder lắng nghe sự thay đổi realtime từ Firestore
      body: StreamBuilder<List<Todo>>(
        stream: FirestoreService().getTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data ?? [];

          if (todos.isEmpty) {
            return const Center(child: Text('Chưa có công việc nào'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Dismissible(
                key: Key(todo.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                   // Gọi Service xóa khỏi Firestore
                   FirestoreService().deleteTodo(todo.id);
                },
                child: ListTile(
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (val) {
                      // Gọi Service cập nhật Firestore
                      if (val != null) {
                        FirestoreService().updateTodoStatus(todo.id, val);
                      }
                    },
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
