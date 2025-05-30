import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../viewmodels/player_viewmodel.dart';
import '../views/player_page.dart';

class MiniPlayer extends StatelessWidget {
  final bool dark;
  const MiniPlayer({super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final playerVM = Provider.of<PlayerViewModel>(context);
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
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: dark
              ? CupertinoColors.black.withAlpha((0.85 * 255).toInt())
              : CupertinoColors.systemGrey6.withAlpha((0.92 * 255).toInt()),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? CupertinoColors.black.withAlpha((0.18 * 255).toInt())
                  : CupertinoColors.systemGrey2.withAlpha((0.18 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                music.albumArtUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 44,
                  height: 44,
                  color: dark ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGrey4,
                  child: Icon(CupertinoIcons.music_note, color: dark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    music.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: dark ? CupertinoColors.white : CupertinoColors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    music.artist,
                    style: TextStyle(fontSize: 13, color: dark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.backward_fill, color: dark ? CupertinoColors.white : CupertinoColors.black, size: 22),
            const SizedBox(width: 8),
            Icon(CupertinoIcons.play_fill, color: dark ? CupertinoColors.white : CupertinoColors.black, size: 28),
            const SizedBox(width: 8),
            Icon(CupertinoIcons.forward_fill, color: dark ? CupertinoColors.white : CupertinoColors.black, size: 22),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
} 