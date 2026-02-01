import 'package:flutter/material.dart';

class StudentProvider extends ChangeNotifier{
   int age = 18;

   void increase(){
    age++;
    notifyListeners();
   }
}