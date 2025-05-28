import '../models/music.dart';
import 'package:flutter/foundation.dart';

class MusicListViewModel extends ChangeNotifier {
  List<Music> _musics = [];

  List<Music> get musics => _musics;

  void setMusics(List<Music> musics) {
    _musics = musics;
    notifyListeners();
  }
} 