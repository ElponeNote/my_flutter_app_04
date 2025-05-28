import '../models/music.dart';
import 'package:flutter/foundation.dart';

class PlayerViewModel extends ChangeNotifier {
  Music? _currentMusic;
  bool _isPlaying = false;

  Music? get currentMusic => _currentMusic;
  bool get isPlaying => _isPlaying;

  void play(Music music) {
    _currentMusic = music;
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    _isPlaying = true;
    notifyListeners();
  }
} 