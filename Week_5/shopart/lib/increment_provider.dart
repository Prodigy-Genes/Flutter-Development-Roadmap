


import 'package:flutter/material.dart';

class IncrementProvider extends ChangeNotifier{
  int _counter = 0;

  int get counter => _counter;

  // function to increment the counter
  void increment(){
    _counter += 1;
    notifyListeners();
  }

  // function to decrement the counter
  void decrement(){
    _counter -= 1;
    notifyListeners();
  }

  // function to reset the counter
  void reset(){
    _counter = 0;
    notifyListeners();
  }


}