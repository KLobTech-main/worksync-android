import 'package:flutter/material.dart';

class CalendarModel extends ChangeNotifier {
  final Map<DateTime, List<String>> events = {};

  void addEvents(List<Map<String, dynamic>> holidays) {
    holidays.forEach((holiday) {
      DateTime date = holiday['date'];
      String name = holiday['name'];

      if (events[date] == null) {
        events[date] = [];
      }
      events[date]?.add(name);
    });
    notifyListeners();
  }
}
