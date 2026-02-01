import 'package:flutter/material.dart';

class AgeProvider extends ChangeNotifier{
  int age = 18;

  void increase(){
    age++;
    notifyListeners();
  }
}