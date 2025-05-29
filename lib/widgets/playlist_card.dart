import 'package:flutter/cupertino.dart';
import '../models/playlist.dart';
import 'package:provider/provider.dart';
import '../viewmodels/player_viewmodel.dart';
import '../views/player_page.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final bool isShorts;
  final bool dark;
  const PlaylistCard({super.key, required this.playlist, this.isShorts = false, this.dark = false});

  @override
  Widget build(BuildContext context) {
    if (isShorts) {
      // Shorts 스타일: 작은 썸네일, 세로형
      return GestureDetector(
        onTap: () {
          if (playlist.musics.isNotEmpty) {
            final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
            playerVM.play(playlist.musics[0]);
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => const PlayerPage()),
            );
          }
        },
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  playlist.thumbnailUrl,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 54,
                    height: 54,
                    color: dark ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGrey4,
                    child: Icon(CupertinoIcons.music_note, color: dark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2, size: 22),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 54,
                child: Text(
                  playlist.name,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: dark ? CupertinoColors.white : CupertinoColors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }
    // 기본 그리드 카드
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (playlist.musics.isNotEmpty) {
          final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
          playerVM.play(playlist.musics[0]);
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const PlayerPage()),
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight, // 셀의 높이에 맞춤
            child: Container(
              decoration: BoxDecoration(
                color: dark ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      playlist.thumbnailUrl,
                      height: constraints.maxHeight * 0.58, // 예: 58%만 이미지
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: constraints.maxHeight * 0.58,
                        color: dark ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGrey4,
                        child: Icon(CupertinoIcons.music_note, color: dark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlist.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: dark ? CupertinoColors.white : CupertinoColors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            playlist.musics.isNotEmpty ? playlist.musics[0].artist : '',
                            style: TextStyle(fontSize: 10, color: dark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey),
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
          );
        },
      ),
    );
  }
}
