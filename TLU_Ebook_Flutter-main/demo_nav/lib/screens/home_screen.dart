import 'package:demo_nav/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // late String productName;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Column(
      children: [
        Text("Demo Home Screen"),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, "/detail", arguments: "Laptop X",);
            print("Màu đã chọn: $result");
        }, 
        child: Text("Open Detail Screen")
        )
      ],
    )
    );
  }
}