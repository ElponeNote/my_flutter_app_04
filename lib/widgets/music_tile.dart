import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/music.dart';
import '../viewmodels/player_viewmodel.dart';
import '../views/player_page.dart';

class MusicTile extends StatelessWidget {
  final Music music;
  final bool dark;
  const MusicTile({super.key, required this.music, this.dark = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
        playerVM.play(music);
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => const PlayerPage()),
        );
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: dark ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
            const Icon(CupertinoIcons.play_arrow_solid, color: CupertinoColors.activeBlue, size: 28),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
