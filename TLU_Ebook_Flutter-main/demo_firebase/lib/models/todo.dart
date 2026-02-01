class Todo {
  final String id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  // Chuyển từ Firestore Document -> Object
  factory Todo.fromFirestore(Map<String, dynamic> data, String id) {
    return Todo(
      id: id,
      title: data['title'] ?? '',
      completed: data['completed'] ?? false,
    );
  }

  // Chuyển Object -> JSON để lưu lên Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}
