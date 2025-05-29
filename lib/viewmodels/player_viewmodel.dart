import 'package:flutter/foundation.dart';
import '../models/music.dart';
import '../resources/sample_data.dart';

class PlayerViewModel extends ChangeNotifier {
  Music? currentMusic;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration(seconds: 180); // 임시값

  PlayerViewModel() {
    // 앱 시작 시 첫 곡을 기본값으로 설정
    if (sampleMusics.isNotEmpty) {
      currentMusic = sampleMusics[0];
    }
  }

  void play(Music music) {
    currentMusic = music;
    isPlaying = true;
    position = Duration.zero;
    notifyListeners();
  }

  void togglePlayPause() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void seek(Duration newPosition) {
    position = newPosition;
    notifyListeners();
  }

  // 추후: 다음/이전 곡, 반복/셔플 등 구현
}
