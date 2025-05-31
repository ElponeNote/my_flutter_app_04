import '../models/music.dart';
import '../models/playlist.dart';
import 'dart:math';

final List<Music> popularMusics = [
  Music(
    title: 'APT',
    artist: '로제',
    albumArtUrl: 'https://image.bugsm.co.kr/album/images/500/40913/4091347.jpg',
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
    title: 'EASY',
    artist: 'LE SSERAFIM',
    albumArtUrl: 'https://cdnimg.melon.co.kr/cm2/album/images/112/97/282/11297282_20240223151623_500.jpg',
    youtubeUrl: 'https://youtu.be/EuYeDngHcqA?si=qlq2Y5wKHzYtFWAl',
  ),
  Music(
    title: 'I AM',
    artist: 'IVE',
    albumArtUrl: 'https://cdnimg.melon.co.kr/cm2/album/images/112/21/448/11221448_20230410155901_500.jpg',
    youtubeUrl: 'https://youtu.be/6ZUIwj3FgUY?si=C9gDgK8cEzT_8tD',
  ),
  Music(
    title: 'Candy',
    artist: 'NCT DREAM',
    albumArtUrl: 'https://cdnimg.melon.co.kr/cm2/album/images/111/60/361/11160361_20221216100654_500.jpg',
    youtubeUrl: 'https://youtu.be/zuoSn3ObMz4?si=CxPP7z8mI8R12rMi',
  ),
  Music(
    title: 'F*ck My Life',
    artist: 'SEVENTEEN',
    albumArtUrl: 'https://cdnimg.melon.co.kr/cm2/album/images/112/36/285/11236285_20230424103119_500.jpg',
    youtubeUrl: 'https://youtu.be/EVCt7zY0cW4?si=lvhxxXL0Hs6UQXB3',
  ),
  Music(
    title: 'Love Lee',
    artist: 'AKMU',
    albumArtUrl: 'https://cdnimg.melon.co.kr/cm2/album/images/112/97/282/11297282_20230818103119_500.jpg',
    youtubeUrl: 'https://youtu.be/EvBzCp4_F28?si=Hs_Hs_Hs_Hs_Hs_H',
  ),
  Music(
    title: 'Dynamite',
    artist: 'BTS (방탄소년단)',
    albumArtUrl: 'https://upload.wikimedia.org/wikipedia/en/9/9b/BTS_-_Dynamite_%28official_cover%29.png',
    youtubeUrl: 'https://youtu.be/gdZLi9oWNZg',
  ),
  Music(
    title: 'How You Like That',
    artist: 'BLACKPINK',
    albumArtUrl: 'https://upload.wikimedia.org/wikipedia/en/0/0e/Blackpink_-_How_You_Like_That.png',
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
