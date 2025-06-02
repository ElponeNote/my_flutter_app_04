import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../viewmodels/player_viewmodel.dart';
import '../utils/image_helper.dart';
import 'package:flutter/material.dart';

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
  void initState() {
    super.initState();
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
    final music = playerVM.currentMusic;
    if (music != null) {
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
                        final double fullWidth = MediaQuery.of(context).size.width - 16;
                        final double width = fullWidth * 0.8;
                        final double height = width * 9 / 16;
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                              child: GestureDetector(
                                onTap: () {
                                  if (_controller != null) {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                    } else {
                                      _controller!.play();
                                    }
                                  }
                                },
                                child: ClipRRect(
                                  key: ValueKey(music.albumArtUrl),
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image(
                                    image: getMusicImageProvider(music),
                                    width: width,
                                    height: height,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => SizedBox(
                                      width: width,
                                      height: height,
                                      child: Container(
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
                    // YoutubePlayerBuilder로 유튜브 플레이어 영역 리팩토링
                    if (_controller != null)
                      YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _controller!,
                          aspectRatio: 16 / 9,
                          onReady: () {
                            // YoutubePlayer가 준비되면 필요한 추가 동작 가능
                          },
                        ),
                        builder: (context, player) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: player,
                          );
                        },
                      ),
                    const SizedBox(height: 18),
                    // 좋아요/싫어요 + 댓글/저장/공유 버튼 (샘플 스타일)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Consumer<PlayerViewModel>(
                        builder: (context, playerVM, _) {
                          final isLiked = playerVM.isLiked(music);
                          final isDisliked = playerVM.isDisliked(music);
                          int likeCount = isLiked ? 95001 : 95000; // 샘플처럼 9.5만
                          String formatCount(int count) {
                            if (count >= 10000) {
                              return '${(count / 10000).toStringAsFixed(1)}만';
                            } else if (count >= 1000) {
                              return '${(count / 1000).toStringAsFixed(1)}K';
                            } else {
                              return '$count';
                            }
                          }
                          bool isSaved = playerVM.isSaved(music);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // 좋아요/싫어요
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey6.withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () => playerVM.toggleLike(music),
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.hand_thumbsup,
                                              color: isLiked ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
                                              size: 22,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              formatCount(likeCount),
                                              style: TextStyle(
                                                color: CupertinoColors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 22,
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        color: CupertinoColors.systemGrey2.withOpacity(0.25),
                                      ),
                                      GestureDetector(
                                        onTap: () => playerVM.toggleDislike(music),
                                        child: Icon(
                                          CupertinoIcons.hand_thumbsdown,
                                          color: isDisliked ? CupertinoColors.systemRed : CupertinoColors.systemGrey,
                                          size: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // 저장 버튼
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey6.withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      playerVM.toggleSave(music);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.add,
                                          color: isSaved ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        const Text('저장', style: TextStyle(color: CupertinoColors.white, fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // 공유 버튼
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey6.withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      // 공유 시트 (url 복사 등)
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) => CupertinoAlertDialog(
                                          title: const Text('공유'),
                                          content: Text('링크: ${music.youtubeUrl}'),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: const Text('닫기'),
                                              onPressed: () => Navigator.of(context).pop(),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(CupertinoIcons.share, color: CupertinoColors.systemGrey, size: 20),
                                        SizedBox(width: 4),
                                        Text('공유', style: TextStyle(color: CupertinoColors.white, fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // 상태바(진행바, 남은시간/총시간) - 위치 이동
                    Consumer<PlayerViewModel>(
                      builder: (context, playerVM, _) {
                        final pos = playerVM.position;
                        final dur = playerVM.duration;
                        String format(Duration d) {
                          String two(int n) => n.toString().padLeft(2, '0');
                          final m = two(d.inMinutes.remainder(60));
                          final s = two(d.inSeconds.remainder(60));
                          return '$m:$s';
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                          child: Material(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Text(format(pos), style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 13)),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                                      activeTrackColor: Colors.white,
                                      inactiveTrackColor: Color.fromRGBO(255,255,255,0.5),
                                      thumbColor: Colors.white,
                                    ),
                                    child: Slider(
                                      value: pos.inSeconds.clamp(0, dur.inSeconds).toDouble(),
                                      min: 0,
                                      max: dur.inSeconds.toDouble(),
                                      onChanged: (v) {
                                        playerVM.seek(Duration(seconds: v.toInt()));
                                      },
                                    ),
                                  ),
                                ),
                                Text(format(dur), style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 13)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // 컨트롤 버튼 (셔플, 이전, 재생/일시정지, 다음, 반복) - 크기 조정
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Consumer<PlayerViewModel>(
                        builder: (context, playerVM, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                onPressed: () {
                                  playerVM.toggleShuffle();
                                },
                                child: Icon(CupertinoIcons.shuffle, size: 24, color: playerVM.isShuffle ? CupertinoColors.white : CupertinoColors.systemGrey2),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                onPressed: () {
                                  playerVM.playPrevious();
                                },
                                child: Icon(CupertinoIcons.backward_end_fill, size: 32, color: CupertinoColors.systemGrey),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                onPressed: (_controller != null)
                                    ? () {
                                        setState(() {
                                          if (_controller!.value.isPlaying) {
                                            _controller!.pause();
                                          } else {
                                            _controller!.play();
                                          }
                                        });
                                      }
                                    : null,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        CupertinoColors.white,
                                        CupertinoColors.systemGrey5,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: CupertinoColors.black.withValues(alpha: 0.18),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      (_controller != null && _controller!.value.isPlaying)
                                          ? CupertinoIcons.pause_solid
                                          : CupertinoIcons.play_arrow_solid,
                                      size: 48,
                                      color: CupertinoColors.black,
                                    ),
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                onPressed: () {
                                  playerVM.playNext();
                                },
                                child: Icon(CupertinoIcons.forward_end_fill, size: 32, color: CupertinoColors.systemGrey),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(8),
                                onPressed: () {
                                  playerVM.toggleRepeatMode();
                                },
                                child: Icon(
                                  CupertinoIcons.repeat,
                                  size: 24,
                                  color: playerVM.repeatMode == RepeatMode.none
                                      ? CupertinoColors.systemGrey2
                                      : playerVM.repeatMode == RepeatMode.all
                                          ? CupertinoColors.activeBlue
                                          : CupertinoColors.systemRed,
                                ),
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

// TODO: CupertinoSlider는 thumb 크기 커스텀을 직접 지원하지 않으므로, 향후 커스텀 위젯으로 대체 필요
