import 'package:flutter/material.dart';

class PlaylistDetailController extends ChangeNotifier {
  bool _isShuffled = false;
  bool _isSaved = false;
  int _playingIndex = 0;

  bool get isShuffled => _isShuffled;
  bool get isSaved => _isSaved;
  int get playingIndex => _playingIndex;

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    notifyListeners();
  }

  void toggleSaved() {
    _isSaved = !_isSaved;
    notifyListeners();
  }

  void playTrack(int index) {
    _playingIndex = index;
    notifyListeners();
  }
}
