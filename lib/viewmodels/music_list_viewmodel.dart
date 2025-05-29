import 'package:flutter/foundation.dart';
import '../models/music.dart';
import '../models/playlist.dart';
import '../resources/sample_data.dart';

class MusicListViewModel extends ChangeNotifier {
  List<Music> musics = sampleMusics;
  List<Playlist> playlists = samplePlaylists;

  // 추후 검색, 필터링, 추가/삭제 등 메서드 구현 예정
}
