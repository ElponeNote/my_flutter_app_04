import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../viewmodels/player_viewmodel.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  YoutubePlayerController? _ytController;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(seconds: 1);
  bool _isSeeking = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final music = Provider.of<PlayerViewModel>(context, listen: false).currentMusic;
    if (music != null) {
      final videoId = YoutubePlayer.convertUrlToId(music.youtubeUrl);
      if (videoId != null) {
        _ytController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            hideControls: false,
            controlsVisibleAtStart: true,
          ),
        )
        ..addListener(_ytListener);
      }
    }
  }

  void _ytListener() {
    if (_ytController == null) return;
    if (!_isSeeking) {
      setState(() {
        _position = _ytController!.value.position;
        _duration = _ytController!.value.metaData.duration;
      });
    }
  }

  @override
  void dispose() {
    _ytController?.removeListener(_ytListener);
    _ytController?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final playerViewModel = Provider.of<PlayerViewModel>(context);
    final music = playerViewModel.currentMusic;
    if (music == null) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Now Playing'),
        ),
        child: const Center(child: Text('재생 중인 곡이 없습니다.')),
      );
    }
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Now Playing'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // 앨범 커버
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  music.albumArtUrl,
                  width: 260,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // YouTube Player
              if (_ytController != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: YoutubePlayer(
                    controller: _ytController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: CupertinoColors.activeBlue,
                    width: double.infinity,
                    aspectRatio: 16 / 9,
                  ),
                ),
              const SizedBox(height: 16),
              // 곡 정보
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      music.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      music.artist,
                      style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // 좋아요/저장/공유 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: const Icon(CupertinoIcons.heart, size: 28, color: CupertinoColors.systemGrey),
                  ),
                  const SizedBox(width: 24),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: const Icon(CupertinoIcons.bookmark, size: 28, color: CupertinoColors.systemGrey),
                  ),
                  const SizedBox(width: 24),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: const Icon(CupertinoIcons.share, size: 28, color: CupertinoColors.systemGrey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 슬라이더 및 시간 표시 (실제 연동)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position), style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                        Text(_formatDuration(_duration), style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                      ],
                    ),
                    CupertinoSlider(
                      value: _duration.inSeconds > 0 ? _position.inSeconds / _duration.inSeconds : 0,
                      onChanged: (v) {
                        setState(() {
                          _isSeeking = true;
                          _position = Duration(seconds: (_duration.inSeconds * v).toInt());
                        });
                      },
                      onChangeEnd: (v) {
                        final newPosition = Duration(seconds: (_duration.inSeconds * v).toInt());
                        _ytController?.seekTo(newPosition);
                        setState(() {
                          _isSeeking = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 재생 컨트롤러
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: const Icon(CupertinoIcons.backward_end_fill, size: 36),
                  ),
                  const SizedBox(width: 32),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (playerViewModel.isPlaying) {
                        playerViewModel.pause();
                        _ytController?.pause();
                      } else {
                        playerViewModel.resume();
                        _ytController?.play();
                      }
                    },
                    child: Icon(
                      playerViewModel.isPlaying ? CupertinoIcons.pause_solid : CupertinoIcons.play_arrow_solid,
                      size: 48,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  const SizedBox(width: 32),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: const Icon(CupertinoIcons.forward_end_fill, size: 36),
                  ),
                ],
              ),
              // 반복/셔플 등 추가 버튼은 필요시 하단에 배치 가능
            ],
          ),
        ),
      ),
    );
  }
} 