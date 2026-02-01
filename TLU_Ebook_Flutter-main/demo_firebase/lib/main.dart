import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/todo_screen.dart';

// Hàm main phải là async để chờ Firebase init
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Quan trọng: Khởi tạo Firebase
  // Lưu ý: Cần chạy 'flutterfire configure' để sinh file firebase_options.dart
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  // Tạm thời comment code init thật để tránh lỗi build khi chưa configure
  // Bạn cần mở comment đoạn trên sau khi cấu hình xong
  await Firebase.initializeApp(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Firebase Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const TodoScreen(),
    );
  }
}
