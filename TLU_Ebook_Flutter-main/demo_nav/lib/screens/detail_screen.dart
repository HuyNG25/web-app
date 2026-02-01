import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  // final String productName;
  
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productName = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Screen"),
      ),
      body: Column(
      children: [
        Text("My Product name is $productName"),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context,"I got");
        }, 
        child: Text("Back 2 Home Screen")
        )
      ],
    )
    );
  }
}