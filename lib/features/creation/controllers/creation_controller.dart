import 'package:flutter/material.dart';
import '../data/creation_data.dart';

enum CreationTab { simple, custom, remix, edit }

class CreationController extends ChangeNotifier {
  // ── Active tab ────────────────────────────────────────────────
  CreationTab _activeTab = CreationTab.simple;
  CreationTab get activeTab => _activeTab;

  void setTab(CreationTab tab) {
    if (_activeTab == tab) return;
    _activeTab = tab;
    notifyListeners();
  }

  // ── Simple tab ────────────────────────────────────────────────
  final TextEditingController descriptionController = TextEditingController();
  String? _selectedGenre;
  String? _selectedMood;

  String? get selectedGenre => _selectedGenre;
  String? get selectedMood => _selectedMood;

  void selectGenre(String genre) {
    _selectedGenre = _selectedGenre == genre ? null : genre;
    notifyListeners();
  }

  void selectMood(String mood) {
    _selectedMood = _selectedMood == mood ? null : mood;
    notifyListeners();
  }

  // ── Simple tab — instrumental toggle ─────────────────────────
  bool _instrumental = false;
  bool get instrumental => _instrumental;

  void toggleInstrumental() {
    _instrumental = !_instrumental;
    notifyListeners();
  }

  // ── Remix tab — selected audio file ──────────────────────────
  String? _remixFileName;
  String? get remixFileName => _remixFileName;

  void setRemixFile(String name) {
    _remixFileName = name;
    notifyListeners();
  }

  void clearRemixFile() {
    _remixFileName = null;
    notifyListeners();
  }

  // ── Custom & Remix text fields ────────────────────────────────
  final TextEditingController lyricsController = TextEditingController();
  final TextEditingController promptController = TextEditingController();
  final TextEditingController negativeTagsController = TextEditingController();

  // ── Advanced options — collapsed state ───────────────────────
  bool _advancedExpanded = false;
  bool get advancedExpanded => _advancedExpanded;

  void toggleAdvanced() {
    _advancedExpanded = !_advancedExpanded;
    notifyListeners();
  }

  // ── Advanced options — Duration ───────────────────────────────
  int _durationSeconds = CreationData.defaultDurationSeconds;
  int get durationSeconds => _durationSeconds;
  bool get isDurationModified =>
      _durationSeconds != CreationData.defaultDurationSeconds;

  void incrementDuration() {
    if (_durationSeconds < CreationData.maxDurationSeconds) {
      _durationSeconds = (_durationSeconds + CreationData.durationStep)
          .clamp(CreationData.minDurationSeconds, CreationData.maxDurationSeconds);
      notifyListeners();
    }
  }

  void decrementDuration() {
    if (_durationSeconds > CreationData.minDurationSeconds) {
      _durationSeconds = (_durationSeconds - CreationData.durationStep)
          .clamp(CreationData.minDurationSeconds, CreationData.maxDurationSeconds);
      notifyListeners();
    }
  }

  void clearDuration() {
    _durationSeconds = CreationData.defaultDurationSeconds;
    notifyListeners();
  }

  // ── Advanced options — Tempo ──────────────────────────────────
  int _tempoBpm = CreationData.defaultTempoBpm;
  int get tempoBpm => _tempoBpm;
  bool get isTempoModified => _tempoBpm != CreationData.defaultTempoBpm;

  void incrementTempo() {
    if (_tempoBpm < CreationData.maxTempoBpm) {
      _tempoBpm++;
      notifyListeners();
    }
  }

  void decrementTempo() {
    if (_tempoBpm > CreationData.minTempoBpm) {
      _tempoBpm--;
      notifyListeners();
    }
  }

  void clearTempo() {
    _tempoBpm = CreationData.defaultTempoBpm;
    notifyListeners();
  }

  // ── Advanced options — Time Signature ────────────────────────
  int _timeSignatureIndex = CreationData.defaultTimeSignatureIndex;
  int get timeSignatureValue =>
      CreationData.timeSignatureValues[_timeSignatureIndex];
  bool get isTimeSignatureModified =>
      _timeSignatureIndex != CreationData.defaultTimeSignatureIndex;

  void incrementTimeSignature() {
    _timeSignatureIndex =
        (_timeSignatureIndex + 1) % CreationData.timeSignatureValues.length;
    notifyListeners();
  }

  void decrementTimeSignature() {
    _timeSignatureIndex =
        (_timeSignatureIndex - 1 + CreationData.timeSignatureValues.length) %
            CreationData.timeSignatureValues.length;
    notifyListeners();
  }

  void clearTimeSignature() {
    _timeSignatureIndex = CreationData.defaultTimeSignatureIndex;
    notifyListeners();
  }

  // ── Advanced options — Key ────────────────────────────────────
  int _keyIndex = CreationData.defaultKeyIndex;
  String get keyValue => CreationData.musicalKeys[_keyIndex];
  bool get isKeyModified => _keyIndex != CreationData.defaultKeyIndex;

  void nextKey() {
    _keyIndex = (_keyIndex + 1) % CreationData.musicalKeys.length;
    notifyListeners();
  }

  void prevKey() {
    _keyIndex =
        (_keyIndex - 1 + CreationData.musicalKeys.length) % CreationData.musicalKeys.length;
    notifyListeners();
  }

  void clearKey() {
    _keyIndex = CreationData.defaultKeyIndex;
    notifyListeners();
  }

  // ── Advanced options — Thinking slider ───────────────────────
  double _thinkingValue = CreationData.defaultThinkingValue;
  double get thinkingValue => _thinkingValue;

  void setThinking(double value) {
    _thinkingValue = value;
    notifyListeners();
  }

  // ── Reset all advanced options ────────────────────────────────
  void resetAdvanced() {
    _durationSeconds = CreationData.defaultDurationSeconds;
    _tempoBpm = CreationData.defaultTempoBpm;
    _timeSignatureIndex = CreationData.defaultTimeSignatureIndex;
    _keyIndex = CreationData.defaultKeyIndex;
    _thinkingValue = CreationData.defaultThinkingValue;
    negativeTagsController.clear();
    notifyListeners();
  }

  // ── Generate (busy flag) ──────────────────────────────────────
  bool _busy = false;
  bool get busy => _busy;

  void _setBusy(bool v) {
    _busy = v;
    notifyListeners();
  }

  Future<void> generate() async {
    _setBusy(true);
    try {
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      _setBusy(false);
    }
  }

  // ── Dispose ───────────────────────────────────────────────────
  @override
  void dispose() {
    descriptionController.dispose();
    lyricsController.dispose();
    promptController.dispose();
    negativeTagsController.dispose();
    super.dispose();
  }
}
