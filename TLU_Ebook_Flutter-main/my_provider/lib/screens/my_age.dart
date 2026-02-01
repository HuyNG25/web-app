import 'package:flutter/material.dart';
import 'package:my_provider/providers/age_provider.dart';
import 'package:provider/provider.dart';

class MyAge extends StatelessWidget {
  const MyAge({super.key});

  @override
  Widget build(BuildContext context) {
    int age = context.watch<AgeProvider>().age;
    return Text("Age: $age");
  }
}