import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../viewmodels/player_viewmodel.dart';
import '../widgets/youtube_player_widget.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  YoutubePlayerController? _controller;
  int _tabIndex = 0; // 0: 노래, 1: 동영상
  int _bottomTabIndex = 0; // 0: 다음 트랙, 1: 가사, 2: 관련 항목

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final music = Provider.of<PlayerViewModel>(context).currentMusic;
    if (music != null) {
      final videoId = YoutubePlayer.convertUrlToId(music.youtubeUrl);
      if (videoId != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            hideControls: false,
            controlsVisibleAtStart: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: false,
          ),
        );
        _controller!.addListener(() {
          if (mounted) {
            setState(() {
              // _position = _controller!.value.position;
              // _duration = _controller!.value.metaData.duration;
            });
          }
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
                    const SizedBox(height: 24),
                    // 앨범아트
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        music.albumArtUrl,
                        width: 260,
                        height: 260,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => SizedBox(
                          width: 260,
                          height: 260,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: CupertinoColors.darkBackgroundGray,
                            ),
                            child: const Icon(CupertinoIcons.music_note, size: 60, color: CupertinoColors.systemGrey2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // 곡명/아티스트
                    Text(
                      music.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CupertinoColors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      music.artist,
                      style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 18),
                    // 유튜브 플레이어
                    if (_controller != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: YoutubePlayerWidget(
                          controller: _controller!,
                          aspectRatio: 16 / 9,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            padding: const EdgeInsets.all(8),
                            child: Icon(CupertinoIcons.shuffle, size: 26, color: CupertinoColors.systemGrey2),
                            onPressed: () {},
                          ),
                          CupertinoButton(
                            padding: const EdgeInsets.all(8),
                            child: Icon(CupertinoIcons.backward_end_fill, size: 32, color: CupertinoColors.white),
                            onPressed: () {},
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
                            onPressed: () {},
                          ),
                          CupertinoButton(
                            padding: const EdgeInsets.all(8),
                            child: Icon(CupertinoIcons.repeat, size: 26, color: CupertinoColors.systemGrey2),
                            onPressed: () {},
                          ),
                        ],
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
