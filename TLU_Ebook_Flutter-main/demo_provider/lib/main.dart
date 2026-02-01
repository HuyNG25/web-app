import 'package:demo_provider/providers/counter_provider.dart';
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
    final count = context.watch<CounterProvider>().count;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:Text("Demo Provider")
        ),
        body:Column(
          children: [
            Text("Count: $count"),
            TextButton(
              onPressed: (){
                context.read<CounterProvider>().increase();
                // print(context.watch<CounterProvider>().count);
              }, 
              child: Text("Click here to Count up"))
          ],

        )
      ),
    );
  }
}