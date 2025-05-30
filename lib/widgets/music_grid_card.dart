import 'package:flutter/cupertino.dart';
import '../models/music.dart';
import 'package:provider/provider.dart';
import '../viewmodels/player_viewmodel.dart';
import '../views/player_page.dart';

class MusicGridCard extends StatelessWidget {
  final Music music;
  final bool dark;
  const MusicGridCard({super.key, required this.music, this.dark = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
        playerVM.play(music);
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => const PlayerPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  music.albumArtUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: dark ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGrey4,
                    child: Icon(CupertinoIcons.music_note, color: CupertinoColors.systemGrey2, size: 40),
                  ),
                ),
              ),
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        CupertinoColors.black.withOpacity(0.7),
                        CupertinoColors.black.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        music.title,
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          shadows: [Shadow(color: CupertinoColors.black, blurRadius: 4)],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        music.artist,
                        style: TextStyle(
                          color: CupertinoColors.systemGrey2,
                          fontSize: 12,
                          shadows: [Shadow(color: CupertinoColors.black, blurRadius: 4)],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 