import 'package:flutter/material.dart';
import '../data/discover_data.dart';

class DiscoverController extends ChangeNotifier {
  String _selectedMoodFilter = DiscoverData.moodFilters.first;

  String get selectedMoodFilter => _selectedMoodFilter;

  void selectMoodFilter(String filter) {
    if (_selectedMoodFilter != filter) {
      _selectedMoodFilter = filter;
      notifyListeners();
    }
  }
}
