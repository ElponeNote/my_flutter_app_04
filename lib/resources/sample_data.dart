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
    name: 'Pop Hits',
    thumbnailUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=80',
    musics: [
      Music(
        title: 'Blinding Lights',
        artist: 'The Weeknd',
        albumArtUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=400&q=80',
        youtubeUrl: 'https://www.youtube.com/watch?v=4NRXx6U8ABQ',
      ),
    ],
  ),
  Playlist(
    name: 'Rock Classics',
    thumbnailUrl: 'https://images.unsplash.com/photo-1465101178521-c1a9136a3b99?auto=format&fit=crop&w=400&q=80',
    musics: [
      Music(
        title: 'Bohemian Rhapsody',
        artist: 'Queen',
        albumArtUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
        youtubeUrl: 'https://www.youtube.com/watch?v=fJ9rUzIMcZQ',
      ),
    ],
  ),
  Playlist(
    name: 'Jazz Vibes',
    thumbnailUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=80',
    musics: [
      Music(
        title: 'Take Five',
        artist: 'Dave Brubeck',
        albumArtUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        youtubeUrl: 'https://www.youtube.com/watch?v=vmDDOFXSgAs',
      ),
    ],
  ),
  Playlist(
    name: 'EDM Party',
    thumbnailUrl: 'https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=400&q=80',
    musics: [
      Music(
        title: 'Wake Me Up',
        artist: 'Avicii',
        albumArtUrl: 'https://images.unsplash.com/photo-1465101178521-c1a9136a3b99?auto=format&fit=crop&w=400&q=80',
        youtubeUrl: 'https://www.youtube.com/watch?v=IcrbM1l_BoI',
      ),
    ],
  ),
  Playlist(
    name: 'K-Pop',
    thumbnailUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
    musics: [
      Music(
        title: 'Dynamite',
        artist: 'BTS',
        albumArtUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=400&q=80',
        youtubeUrl: 'https://www.youtube.com/watch?v=gdZLi9oWNZg',
      ),
    ],
  ),
  Playlist(
    name: 'Indie Mood',
    thumbnailUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
    musics: [
      Music(
        title: 'Lost Stars',
        artist: 'Adam Levine',
        albumArtUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=80',
        youtubeUrl: 'https://www.youtube.com/watch?v=cL4uhaQ58Rk',
      ),
    ],
  ),
  Playlist(
    name: 'Hip-Hop',
    thumbnailUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=400&q=80',
    musics: [
      Music(
        title: 'SICKO MODE',
        artist: 'Travis Scott',
        albumArtUrl: 'https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=400&q=80',
        youtubeUrl: 'https://www.youtube.com/watch?v=6ONRf7h3Mdk',
      ),
    ],
  ),
  Playlist(
    name: 'Acoustic',
    thumbnailUrl: 'https://images.unsplash.com/photo-1465101178521-c1a9136a3b99?auto=format&fit=crop&w=400&q=80',
    musics: [
      Music(
        title: 'Photograph',
        artist: 'Ed Sheeran',
        albumArtUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
        youtubeUrl: 'https://www.youtube.com/watch?v=nSDgHBxUbVQ',
      ),
    ],
  ),
  Playlist(
    name: 'Classic',
    thumbnailUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
    musics: [
      Music(
        title: 'Nocturne op.9 No.2',
        artist: 'Chopin',
        albumArtUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=80',
        youtubeUrl: 'https://www.youtube.com/watch?v=9E6b3swbnWg',
      ),
    ],
  ),
];
