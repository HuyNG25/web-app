import 'package:demo_nav_route/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Home Screen"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: [
          Text("...."),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, "/detail");
          }, child: Text("Open Detail"))
        ],
      )
    );
  }
}