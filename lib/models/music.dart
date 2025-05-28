class Music {
  final String title;
  final String artist;
  final String albumArtUrl;
  final String youtubeUrl;

  Music({
    required this.title,
    required this.artist,
    required this.albumArtUrl,
    required this.youtubeUrl,
  });
}

// 샘플 음악 데이터
final List<Music> sampleMusics = [
  Music(
    title: 'No One Else Like You',
    artist: 'Adam Levine',
    albumArtUrl: 'https://i.imgur.com/8Km9tLL.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=9bZkp7q19f0',
  ),
  Music(
    title: 'Shape of You',
    artist: 'Ed Sheeran',
    albumArtUrl: 'https://i.imgur.com/BoN9kdC.png',
    youtubeUrl: 'https://www.youtube.com/watch?v=JGwWNGJdvx8',
  ),
  Music(
    title: 'Pretender',
    artist: 'Official HIGE DANDism',
    albumArtUrl: 'https://i.imgur.com/2yaf2wb.jpg',
    youtubeUrl: 'https://www.youtube.com/watch?v=TQ8WlA2GXbk',
  ),
]; 