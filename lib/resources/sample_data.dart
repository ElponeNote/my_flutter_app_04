import '../models/music.dart';
import '../models/playlist.dart';

final List<Music> sampleMusics = [
  Music(
    title: 'No One Else Like You',
    artist: 'Adam Levine',
    albumArtUrl: 'https://i.imgur.com/albumArt1.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=example1',
  ),
  Music(
    title: 'Shape of You',
    artist: 'Ed Sheeran',
    albumArtUrl: 'https://i.imgur.com/albumArt2.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=JGwWNGJdvx8',
  ),
  // ... 추가 곡
];

final List<Playlist> samplePlaylists = [
  Playlist(
    name: '빠른 선곡',
    thumbnailUrl: 'https://i.imgur.com/playlist1.jpg',
    musics: sampleMusics,
  ),
  Playlist(
    name: '에너지 충전',
    thumbnailUrl: 'https://i.imgur.com/playlist2.jpg',
    musics: sampleMusics,
  ),
  // ... 추가 플레이리스트
];
