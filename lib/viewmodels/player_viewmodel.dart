import 'package:flutter/foundation.dart';
import '../models/music.dart';
import '../resources/sample_data.dart';
import 'dart:math';

/// 반복 모드
enum RepeatMode { none, all, one }

class PlayerViewModel extends ChangeNotifier {
  Music? currentMusic;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration(seconds: 180); // 임시값

  // --- 추가: 재생 컨트롤 상태 ---
  bool isShuffle = false;
  RepeatMode repeatMode = RepeatMode.none;
  int currentIndex = 0;
  List<Music> playQueue = List<Music>.from(sampleMusics);

  // --- 추가: 곡별 좋아요 상태 ---
  final Map<String, bool> likedSongs = {};

  PlayerViewModel() {
    // 앱 시작 시 첫 곡을 기본값으로 설정
    if (sampleMusics.isNotEmpty) {
      playQueue = List<Music>.from(sampleMusics);
      currentMusic = playQueue[0];
      currentIndex = 0;
    }
  }

  /// 곡 재생 및 큐/인덱스 동기화
  void play(Music music) {
    final idx = playQueue.indexWhere((m) => m.youtubeUrl == music.youtubeUrl);
    if (idx != -1) {
      currentIndex = idx;
      currentMusic = playQueue[currentIndex];
    } else {
      playQueue = List<Music>.from(sampleMusics);
      currentIndex = 0;
      currentMusic = playQueue[0];
    }
    isPlaying = true;
    position = Duration.zero;
    notifyListeners();
  }

  /// 셔플 토글
  void toggleShuffle() {
    isShuffle = !isShuffle;
    if (isShuffle) {
      // 현재 곡을 맨 앞으로 두고 나머지 랜덤
      if (currentMusic != null) {
        final rest = List<Music>.from(sampleMusics)..removeWhere((m) => m.youtubeUrl == currentMusic!.youtubeUrl);
        rest.shuffle(Random());
        playQueue = [currentMusic!, ...rest];
        currentIndex = 0;
      }
    } else {
      // 순차 큐로 복원
      playQueue = List<Music>.from(sampleMusics);
      if (currentMusic != null) {
        currentIndex = playQueue.indexWhere((m) => m.youtubeUrl == currentMusic!.youtubeUrl);
      }
    }
    notifyListeners();
  }

  /// 반복 모드 토글 (none → all → one → none)
  void toggleRepeatMode() {
    switch (repeatMode) {
      case RepeatMode.none:
        repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        repeatMode = RepeatMode.none;
        break;
    }
    notifyListeners();
  }

  /// 다음 곡 재생
  void playNext() {
    if (playQueue.isEmpty) return;
    if (repeatMode == RepeatMode.one) {
      // 같은 곡 반복
      play(currentMusic!);
      return;
    }
    int nextIdx = currentIndex + 1;
    if (nextIdx >= playQueue.length) {
      nextIdx = (repeatMode == RepeatMode.all) ? 0 : playQueue.length - 1;
    }
    currentIndex = nextIdx;
    currentMusic = playQueue[currentIndex];
    isPlaying = true;
    position = Duration.zero;
    notifyListeners();
  }

  /// 이전 곡 재생
  void playPrevious() {
    if (playQueue.isEmpty) return;
    int prevIdx = currentIndex - 1;
    if (prevIdx < 0) {
      prevIdx = (repeatMode == RepeatMode.all) ? playQueue.length - 1 : 0;
    }
    currentIndex = prevIdx;
    currentMusic = playQueue[currentIndex];
    isPlaying = true;
    position = Duration.zero;
    notifyListeners();
  }

  /// 큐 직접 설정
  void setQueue(List<Music> queue) {
    playQueue = List<Music>.from(queue);
    if (playQueue.isNotEmpty) {
      currentMusic = playQueue[0];
      currentIndex = 0;
    }
    notifyListeners();
  }

  /// 인덱스 직접 설정
  void setCurrentIndex(int idx) {
    if (idx >= 0 && idx < playQueue.length) {
      currentIndex = idx;
      currentMusic = playQueue[currentIndex];
      isPlaying = true;
      position = Duration.zero;
      notifyListeners();
    }
  }

  void togglePlayPause() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void seek(Duration newPosition) {
    position = newPosition;
    notifyListeners();
  }

  void setPlaying(bool value) {
    isPlaying = value;
    notifyListeners();
  }

  /// 곡별 좋아요 토글
  void toggleLike(Music music) {
    final key = music.youtubeUrl;
    likedSongs[key] = !(likedSongs[key] ?? false);
    notifyListeners();
  }

  /// 곡별 좋아요 여부 반환
  bool isLiked(Music music) {
    return likedSongs[music.youtubeUrl] ?? false;
  }
}
