import 'package:flutter/material.dart';
import '../data/creation_data.dart';

class CreationController extends ChangeNotifier {
  final TextEditingController descriptionController = TextEditingController();

  String? _selectedGenre;
  String? _selectedMood;
  double _duration = CreationData.defaultDuration;
  double _bpm = CreationData.defaultBpm;

  String? get selectedGenre => _selectedGenre;
  String? get selectedMood => _selectedMood;
  double get duration => _duration;
  double get bpm => _bpm;

  String get durationLabel => CreationData.formatDuration(_duration);
  String get bpmLabel =>
      '${_bpm.toInt()} BPM (${CreationData.bpmLabel(_bpm)})';

  void selectGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  void selectMood(String mood) {
    _selectedMood = mood;
    notifyListeners();
  }

  void setDuration(double value) {
    _duration = value;
    notifyListeners();
  }

  void setBpm(double value) {
    _bpm = value;
    notifyListeners();
  }

  void reset() {
    descriptionController.clear();
    _selectedGenre = null;
    _selectedMood = null;
    _duration = CreationData.defaultDuration;
    _bpm = CreationData.defaultBpm;
    notifyListeners();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
