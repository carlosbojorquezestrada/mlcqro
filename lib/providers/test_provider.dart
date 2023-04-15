import 'package:flutter/material.dart';

class TestProvider extends ChangeNotifier {
  int count = 0;
  int selectedPane = 1;

  void actualizaCount() {
    count++;
    notifyListeners();
  }

  void setSelectedPane(int value) {
    selectedPane = value;
    notifyListeners();
  }
}
