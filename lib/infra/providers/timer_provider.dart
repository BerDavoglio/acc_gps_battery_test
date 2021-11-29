import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  int _counter = 5;

  get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void decrementCounter() {
    if (_counter == 1) {
      _counter = 1;
    } else {
      _counter--;
    }
    notifyListeners();
  }
}
