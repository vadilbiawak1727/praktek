import 'package:flutter/material.dart';

class BioData extends ChangeNotifier {
  String? image;
  double score = 0;
  DateTime? selectedDate;

  void setImage(String? value) {
    image = value;
    notifyListeners();
  }

  void setScore(double value) {
    score = value;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
