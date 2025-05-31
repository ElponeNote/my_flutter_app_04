import '../models/music.dart';
import '../models/playlist.dart';
import 'dart:math';

final List<Music> popularMusics = [
  Music(
    title: 'Shopper',
    artist: '아이유',
    albumArtUrl: 'https://i.ytimg.com/vi/kHW-UVXOcLU/hqdefault.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=kHW-UVXOcLU',
  ),
  Music(
    title: 'Love wins all',
    artist: '아이유',
    albumArtUrl: 'https://i.ytimg.com/vi/JleoAppaxi0/hqdefault.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=JleoAppaxi0',
  ),
  Music(
    title: '에잇',
    artist: '아이유',
    albumArtUrl: 'https://i.ytimg.com/vi/TgOu00Mf3kI/hqdefault.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=TgOu00Mf3kI',
  ),
  Music(
    title: 'Blueming',
    artist: '아이유',
    albumArtUrl: 'https://i.ytimg.com/vi/D1PvIWdJ8xo/hqdefault.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=D1PvIWdJ8xo',
  ),
  Music(
    title: 'APT',
    artist: '로제',
    albumArtUrl: 'https://img.youtube.com/vi/ekr2nIex040/hqdefault.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=ekr2nIex040',
  ),
  Music(
    title: 'The Lazy Song',
    artist: '브루노마스',
    albumArtUrl: 'https://img.youtube.com/vi/fLexgOxsZu0/hqdefault.jpg',
    youtubeUrl: 'https://youtu.be/fLexgOxsZu0?si=xU1Bv1IYHcyxhmAL',
  ),
  Music(
    title: 'Super Shy',
    artist: 'NewJeans',
    albumArtUrl: 'https://img.youtube.com/vi/ArmDp-zijuc/hqdefault.jpg',
    youtubeUrl: 'https://youtu.be/ArmDp-zijuc?si=7UhZG6i2J-FP4Tz1',
  ),
  Music(
    title: 'How Sweet',
    artist: 'NewJeans',
    albumArtUrl: 'https://img.youtube.com/vi/t1ScQa89VlY/hqdefault.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=t1ScQa89VlY',
  ),
  Music(
    title: 'I AM',
    artist: 'IVE',
    albumArtUrl: 'https://img.youtube.com/vi/6ZUIwj3FgUY/hqdefault.jpg',
    youtubeUrl: 'https://youtu.be/6ZUIwj3FgUY?si=C9gDgK8cEzT_8tD',
  ),
  Music(
    title: 'Candy',
    artist: 'NCT DREAM',
    albumArtUrl: 'https://img.youtube.com/vi/zuoSn3ObMz4/hqdefault.jpg',
    youtubeUrl: 'https://youtu.be/zuoSn3ObMz4?si=CxPP7z8mI8R12rMi',
  ),
  Music(
    title: 'Smart',
    artist: 'LE SSERAFIM',
    albumArtUrl: 'https://i.ytimg.com/vi/KNexS61fjus/hqdefault.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=KNexS61fjus',
  ),
  Music(
    title: 'Magnetic',
    artist: 'ILLIT',
    albumArtUrl: 'https://i.ytimg.com/vi/Vk5-c_v4gMU/hqdefault.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=Vk5-c_v4gMU',
  ),
  Music(
    title: 'Dynamite',
    artist: 'BTS (방탄소년단)',
    albumArtUrl: 'https://img.youtube.com/vi/gdZLi9oWNZg/hqdefault.jpg',
    youtubeUrl: 'https://youtu.be/gdZLi9oWNZg',
  ),
  Music(
    title: 'How You Like That',
    artist: 'BLACKPINK',
    albumArtUrl: 'https://img.youtube.com/vi/ioNng23DkIM/hqdefault.jpg',
    youtubeUrl: 'https://youtu.be/ioNng23DkIM',
  ),
];

List<Music> getRandomPopularMusics([int count = 10]) {
  final musics = List<Music>.from(popularMusics);
  musics.shuffle(Random());
  return musics.take(count).toList();
}

final List<Music> sampleMusics = List<Music>.from(popularMusics);

final List<Playlist> samplePlaylists = [
  Playlist(
    name: '인기 음악 플레이리스트',
    thumbnailUrl: popularMusics[0].albumArtUrl,
    musics: popularMusics,
  ),
];
