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
