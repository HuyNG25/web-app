import 'package:flutter/widgets.dart';

class CounterProvider extends ChangeNotifier{
  int count = 0;
  void increase(){
    count++;
    notifyListeners(); //Ra lenh rebuild UI = setState();
  }

  void decrease(){
    count--;
    notifyListeners();
  }
}