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
  Duration _position = Duration.zero;
  Duration _duration = Duration(seconds: 0);

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
              _position = _controller!.value.position;
              _duration = _controller!.value.metaData.duration;
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Now Playing'),
        backgroundColor: CupertinoColors.black,
        border: null,
      ),
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // 앨범아트
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  music.albumArtUrl,
                  width: 260,
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 260,
                    height: 260,
                    color: CupertinoColors.darkBackgroundGray,
                    child: const Icon(CupertinoIcons.music_note, size: 60, color: CupertinoColors.systemGrey2),
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
              // 컨트롤 버튼 (랜덤, 이전, 재생/일시정지, 다음, 반복)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 랜덤 재생 버튼
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(CupertinoIcons.shuffle, size: 28, color: CupertinoColors.systemGrey2),
                    onPressed: () {},
                  ),
                  // 이전 곡
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(CupertinoIcons.backward_end_fill, size: 32, color: CupertinoColors.white),
                    onPressed: () {},
                  ),
                  // 재생/일시정지
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      playerVM.isPlaying ? CupertinoIcons.pause_solid : CupertinoIcons.play_arrow_solid,
                      size: 44,
                      color: CupertinoColors.white,
                    ),
                    onPressed: () {
                      playerVM.togglePlayPause();
                      if (_controller != null) {
                        if (playerVM.isPlaying) {
                          _controller!.play();
                        } else {
                          _controller!.pause();
                        }
                      }
                    },
                  ),
                  // 다음 곡
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(CupertinoIcons.forward_end_fill, size: 32, color: CupertinoColors.white),
                    onPressed: () {},
                  ),
                  // 반복 재생 버튼
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(CupertinoIcons.repeat, size: 28, color: CupertinoColors.systemGrey2),
                    onPressed: () {},
                  ),
                ],
              ),
              // 진행바 및 시간
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position), style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 13)),
                    Text(_formatDuration(_duration), style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 13)),
                  ],
                ),
              ),
              // 하단 탭(가사, 다음 트랙, 관련 항목 등)
              const Spacer(),
              Container(
                height: 48,
                color: CupertinoColors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text('다음 트랙', style: TextStyle(color: CupertinoColors.white, fontSize: 15)),
                    Text('가사', style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 15)),
                    Text('관련 항목', style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
