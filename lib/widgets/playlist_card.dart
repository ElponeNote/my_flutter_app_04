import 'package:flutter/cupertino.dart';
import '../models/playlist.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final bool isShorts;
  const PlaylistCard({super.key, required this.playlist, this.isShorts = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(isShorts ? 12 : 8),
          child: Image.network(
            playlist.thumbnailUrl,
            width: isShorts ? 80 : 90,
            height: isShorts ? 60 : 90,
            fit: BoxFit.cover,
          ),
        ),
        if (!isShorts)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SizedBox(
              width: 90,
              child: Text(
                playlist.name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
