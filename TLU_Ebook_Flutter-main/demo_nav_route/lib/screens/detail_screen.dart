import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Detail Screen"),
        backgroundColor: const Color.fromARGB(255, 159, 198, 5),
      ),
      body: Column(
        children: [
          Text("...."),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Back 2 Home"))
        ],
      )
    );;
  }
}