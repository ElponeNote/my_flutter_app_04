import 'music.dart';

class Playlist {
  final String name;
  final String thumbnailUrl;
  final List<Music> musics;

  Playlist({
    required this.name,
    required this.thumbnailUrl,
    required this.musics,
  });
}
