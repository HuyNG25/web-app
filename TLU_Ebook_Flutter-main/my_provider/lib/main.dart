import 'package:flutter/material.dart';
import 'package:my_provider/providers/count_provider.dart';
import 'package:my_provider/providers/age_provider.dart';
import 'package:my_provider/screens/my_age.dart';
import 'package:my_provider/screens/my_count.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountProvider()),
        ChangeNotifierProvider(create: (_) => AgeProvider()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyCount(),
            MyAge(),
            TextButton(
              onPressed: (){
                context.read<CountProvider>().increase();
                context.read<AgeProvider>().increase();
              }, 
              child: Text("Click Here to Change"))
          ],
        )
      )
    );
  }
}