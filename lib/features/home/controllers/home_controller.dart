import 'package:flutter/material.dart';

enum GreetingType { morning, afternoon, evening }

class HomeController extends ChangeNotifier {
  GreetingType get greetingType {
    final hour = DateTime.now().hour;
    if (hour < 12) return GreetingType.morning;
    if (hour < 17) return GreetingType.afternoon;
    return GreetingType.evening;
  }
}
