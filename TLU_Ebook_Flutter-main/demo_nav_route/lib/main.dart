import 'package:demo_nav_route/screens/detail_screen.dart';
import 'package:demo_nav_route/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/detail" : (context) => DetailScreen()
      },
      // home: HomeScreen()
    );
  }
}