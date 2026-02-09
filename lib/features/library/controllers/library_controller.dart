import 'package:flutter/material.dart';
import '../data/library_data.dart';

class LibraryController extends ChangeNotifier {
  String _selectedFilter = LibraryData.filters.first;

  String get selectedFilter => _selectedFilter;

  void selectFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      notifyListeners();
    }
  }
}
