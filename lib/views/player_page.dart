import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../viewmodels/player_viewmodel.dart';
import '../widgets/youtube_player_widget.dart';
import '../viewmodels/music_list_viewmodel.dart';
import '../models/music.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  YoutubePlayerController? _controller;
  int _tabIndex = 0; // 0: 노래, 1: 동영상
  int _bottomTabIndex = 0; // 0: 다음 트랙, 1: 가사, 2: 관련 항목
  bool _shuffle = false;
  bool _repeat = false;
  int _currentIndex = 0;

  void _playMusicAt(int index, List<Music> musics) {
    if (index < 0 || index >= musics.length) return;
    Provider.of<PlayerViewModel>(context, listen: false).play(musics[index]);
    setState(() {
      _currentIndex = index;
    });
  }

  void _playNext(List<Music> musics) {
    if (_shuffle) {
      final random = musics.toList()..removeAt(_currentIndex);
      if (random.isNotEmpty) {
        final next = (random..shuffle()).first;
        _playMusicAt(musics.indexOf(next), musics);
      }
    } else {
      int nextIndex = _currentIndex + 1;
      if (nextIndex >= musics.length) nextIndex = 0;
      _playMusicAt(nextIndex, musics);
    }
  }

  void _playPrevious(List<Music> musics) {
    int prevIndex = _currentIndex - 1;
    if (prevIndex < 0) prevIndex = musics.length - 1;
    _playMusicAt(prevIndex, musics);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final musicListVM = Provider.of<MusicListViewModel>(context, listen: false);
    final musics = musicListVM.musics;
    final music = Provider.of<PlayerViewModel>(context).currentMusic;
    if (music != null) {
      _currentIndex = musics.indexWhere((m) => m.youtubeUrl == music.youtubeUrl);
      final videoId = YoutubePlayer.convertUrlToId(music.youtubeUrl);
      if (videoId != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            hideControls: true,
            controlsVisibleAtStart: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: false,
          ),
        );
        _controller!.addListener(() {
          if (mounted) {
            setState(() {});
            // 곡이 끝났는지 감지
            if (_controller!.value.playerState == PlayerState.ended) {
              if (_repeat) {
                _controller!.seekTo(Duration.zero);
                _controller!.play();
              } else {
                _playNext(musics);
              }
            }
          }
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant PlayerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final music = Provider.of<PlayerViewModel>(context, listen: false).currentMusic;
    if (music != null) {
      final videoId = YoutubePlayer.convertUrlToId(music.youtubeUrl);
      if (videoId != null) {
        _controller?.dispose();
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            hideControls: true,
            controlsVisibleAtStart: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: false,
          ),
        );
        _controller!.addListener(() {
          if (mounted) setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerVM = Provider.of<PlayerViewModel>(context);
    final music = playerVM.currentMusic;
    if (music == null) {
      return const CupertinoPageScaffold(
        child: Center(child: Text('재생할 곡이 없습니다.')),
      );
    }
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1단계: 상단 영역 (뒤로가기, 탭, 우측 아이콘)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.back, color: CupertinoColors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                width: 180,
                                child: CupertinoSegmentedControl<int>(
                                  groupValue: _tabIndex,
                                  children: const {
                                    0: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text('노래', style: TextStyle(fontSize: 15)),
                                    ),
                                    1: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text('동영상', style: TextStyle(fontSize: 15)),
                                    ),
                                  },
                                  onValueChanged: (idx) {
                                    setState(() {
                                      _tabIndex = idx;
                                    });
                                  },
                                  selectedColor: CupertinoColors.systemGrey6,
                                  unselectedColor: CupertinoColors.black,
                                  borderColor: CupertinoColors.systemGrey,
                                  pressedColor: CupertinoColors.systemGrey2,
                                ),
                              ),
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.ellipsis, color: CupertinoColors.white, size: 26),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 앨범아트
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double width = MediaQuery.of(context).size.width - 16;
                        final double height = width * 9 / 16;
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                              child: ClipRRect(
                                key: ValueKey(music.albumArtUrl),
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  music.albumArtUrl,
                                  width: width,
                                  height: height,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => SizedBox(
                                    width: width,
                                    height: height,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.darkBackgroundGray,
                                      ),
                                      child: const Icon(CupertinoIcons.music_note, size: 60, color: CupertinoColors.systemGrey2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 7),
                    // 곡명/아티스트
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, anim) => SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(anim),
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: Column(
                        key: ValueKey(music.title + music.artist),
                        children: [
                          Text(
                            music.title,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CupertinoColors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            music.artist,
                            style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 유튜브 플레이어
                    if (_controller != null)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                        child: Padding(
                          key: ValueKey(music.youtubeUrl),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: YoutubePlayerWidget(
                            controller: _controller!,
                            aspectRatio: 16 / 9,
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    // 좋아요/댓글/저장/공유 버튼 (유튜브 플레이어 하단)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: const [
                              Icon(CupertinoIcons.heart_fill, color: CupertinoColors.systemRed, size: 28),
                              SizedBox(height: 2),
                              Text('1.2K', style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: const [
                              Icon(CupertinoIcons.chat_bubble_text, color: CupertinoColors.systemGrey, size: 28),
                              SizedBox(height: 2),
                              Text('댓글', style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: const [
                              Icon(CupertinoIcons.bookmark, color: CupertinoColors.systemGrey, size: 28),
                              SizedBox(height: 2),
                              Text('저장', style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: const [
                              Icon(CupertinoIcons.share, color: CupertinoColors.systemGrey, size: 28),
                              SizedBox(height: 2),
                              Text('공유', style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    // 컨트롤 버튼 (셔플, 이전, 재생/일시정지, 다음, 반복)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Consumer<MusicListViewModel>(
                        builder: (context, musicListVM, _) {
                          final musics = musicListVM.musics;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                child: Icon(CupertinoIcons.shuffle, size: 26, color: _shuffle ? CupertinoColors.white : CupertinoColors.systemGrey2),
                                onPressed: () {
                                  setState(() {
                                    _shuffle = !_shuffle;
                                  });
                                },
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                child: Icon(CupertinoIcons.backward_end_fill, size: 32, color: CupertinoColors.white),
                                onPressed: () {
                                  _playPrevious(musics);
                                },
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  playerVM.isPlaying ? CupertinoIcons.pause_solid : CupertinoIcons.play_arrow_solid,
                                  size: 44,
                                  color: CupertinoColors.white,
                                ),
                                onPressed: () {
                                  if (_controller != null) {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                      playerVM.setPlaying(false);
                                    } else {
                                      _controller!.play();
                                      playerVM.setPlaying(true);
                                    }
                                  }
                                },
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                child: Icon(CupertinoIcons.forward_end_fill, size: 32, color: CupertinoColors.white),
                                onPressed: () {
                                  _playNext(musics);
                                },
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                child: Icon(CupertinoIcons.repeat, size: 26, color: _repeat ? CupertinoColors.white : CupertinoColors.systemGrey2),
                                onPressed: () {
                                  setState(() {
                                    _repeat = !_repeat;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _bottomTabBar(
              selectedIndex: _bottomTabIndex,
              onTap: (idx) {
                setState(() {
                  _bottomTabIndex = idx;
                });
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _bottomTabBar({required int selectedIndex, required void Function(int) onTap}) {
    final tabs = ['다음 트랙', '가사', '관련 항목'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(tabs.length, (idx) {
          final isSelected = selectedIndex == idx;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(idx),
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: Text(
                  tabs[idx],
                  style: TextStyle(
                    color: isSelected ? CupertinoColors.white : CupertinoColors.systemGrey2,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
