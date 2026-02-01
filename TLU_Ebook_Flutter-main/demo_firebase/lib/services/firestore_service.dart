import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class FirestoreService {
  // Collection reference
  final CollectionReference _todoCollection =
      FirebaseFirestore.instance.collection('todos');

  // 1. Lấy danh sách (Stream - dữ liệu thời gian thực)
  Stream<List<Todo>> getTodos() {
    return _todoCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // 2. Thêm mới
  Future<void> addTodo(String title) async {
    await _todoCollection.add({
      'title': title,
      'completed': false,
    });
  }

  // 3. Cập nhật trạng thái
  Future<void> updateTodoStatus(String id, bool status) async {
    await _todoCollection.doc(id).update({
      'completed': status,
    });
  }

  // 4. Xóa
  Future<void> deleteTodo(String id) async {
    await _todoCollection.doc(id).delete();
  }
}
