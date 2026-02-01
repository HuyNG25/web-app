import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int count = 1;

  void increase() {
    count++;
    notifyListeners(); //Su khac biet
  }

  void decrease() {
    count--;
    notifyListeners();
  }
}