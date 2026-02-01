import 'package:flutter/material.dart';
import 'package:my_provider/providers/count_provider.dart';
import 'package:provider/provider.dart';

class MyCount extends StatelessWidget {
  const MyCount({super.key});

  @override
  Widget build(BuildContext context) {
    int count = context.watch<CountProvider>().count;
    return Text("Count: $count");
  }
}