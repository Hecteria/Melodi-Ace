import 'package:flutter/material.dart';
import '../data/player_data.dart';

class PlayerController extends ChangeNotifier {
  bool _isPlaying = true;
  bool _isShuffle = false;
  bool _isRepeat = false;
  bool _isFavorite = true;
  double _progress = 0.43;

  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  bool get isFavorite => _isFavorite;
  double get progress => _progress;

  String get currentTimeLabel =>
      PlayerData.formatTime(_progress * PlayerData.currentTrack.totalSeconds);

  String get totalTimeLabel =>
      PlayerData.formatTime(PlayerData.currentTrack.totalSeconds);

  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void seekTo(double value) {
    _progress = value;
    notifyListeners();
  }
}
