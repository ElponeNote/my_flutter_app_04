import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../viewmodels/player_viewmodel.dart';
import '../views/player_page.dart';
import '../utils/image_helper.dart';
import '../viewmodels/music_list_viewmodel.dart';
import '../models/music.dart';

class MiniPlayer extends StatelessWidget {
  final bool dark;
  const MiniPlayer({super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final playerVM = Provider.of<PlayerViewModel>(context);
    final musicListVM = Provider.of<MusicListViewModel>(context, listen: false);
    // 추천 선곡 리스트로 playQueue를 초기화 (필요시)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (playerVM.playQueue.isEmpty || playerVM.playQueue.length != musicListVM.musics.length) {
        playerVM.initQueueFromRecommended(List<Music>.from(musicListVM.musics)..shuffle());
      }
    });
    final music = playerVM.currentMusic;
    if (music == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const PlayerPage(),
          ),
        );
      },
      child: Container(
        height: 68,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: dark
              ? CupertinoColors.black.withAlpha((0.90 * 255).toInt())
              : CupertinoColors.systemGrey6.withAlpha((0.97 * 255).toInt()),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: dark ? CupertinoColors.systemGrey.withValues(alpha: 0.18) : CupertinoColors.systemGrey4.withValues(alpha: 0.18),
            width: 0.7,
          ),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? CupertinoColors.black.withValues(alpha: 0.18)
                  : CupertinoColors.systemGrey2.withValues(alpha: 0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: getMusicImageProvider(music),
                width: 68,
                height: 68,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 68,
                  height: 68,
                  color: dark ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGrey4,
                  child: Icon(CupertinoIcons.music_note, color: dark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    music.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: dark ? CupertinoColors.white : CupertinoColors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    music.artist,
                    style: TextStyle(fontSize: 15, color: dark ? CupertinoColors.systemGrey2 : CupertinoColors.systemGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                playerVM.togglePlayPause();
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const PlayerPage(),
                  ),
                );
              },
              child: Icon(
                playerVM.isPlaying ? CupertinoIcons.pause_solid : CupertinoIcons.play_arrow_solid,
                color: CupertinoColors.activeBlue,
                size: 38,
              ),
            ),
            const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
} 