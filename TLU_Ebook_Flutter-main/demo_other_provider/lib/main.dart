import 'package:demo_other_provider/providers/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Truy cap vao bien cua CounterPrivder
    final count = context.watch<CounterProvider>().count;
    return MaterialApp(
      home:Scaffold(
        body: Column(
          children: [
            Text("Count: $count"),
            TextButton(
              onPressed: (){
                context.read<CounterProvider>().increase();
              }, 
              child: Text("Count Up"))
          ],
        ),
      )
    );
  }
}