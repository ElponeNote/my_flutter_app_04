import 'package:flutter/cupertino.dart';

class MusicTile extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final VoidCallback? onTap;

  const MusicTile({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Row(
        children: [
          Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(artist, style: TextStyle(color: CupertinoColors.systemGrey)),
            ],
          ),
        ],
      ),
    );
  }
} 