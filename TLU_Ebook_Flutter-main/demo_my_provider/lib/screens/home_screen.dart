import 'package:demo_my_provider/providers/counter_provider.dart';
import 'package:demo_my_provider/providers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CounterProvider>().count;
    final age = context.watch<StudentProvider>().age;
    return Scaffold(
        body: Column(
          children: [
            Text("Count: $count"),
            Text("Student'age : $age"),
            TextButton(
              onPressed: (){
                context.read<CounterProvider>().increase();
                context.read<StudentProvider>().increase();
              }, 
              child: Text("Click Me")
              )
          ],
        )
      );
  }
}