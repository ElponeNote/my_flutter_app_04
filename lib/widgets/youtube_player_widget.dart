import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final void Function(Duration position, Duration duration)? onTimeUpdate;
  final double aspectRatio;
  final VoidCallback? onReady;
  const YoutubePlayerWidget({
    super.key,
    required this.controller,
    this.onTimeUpdate,
    this.aspectRatio = 16 / 9,
    this.onReady,
  });

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: CupertinoColors.activeBlue,
      progressColors: const ProgressBarColors(
        playedColor: CupertinoColors.activeBlue,
        handleColor: CupertinoColors.activeBlue,
      ),
      width: double.infinity,
      aspectRatio: aspectRatio,
      onReady: () {
        controller.addListener(() {
          if (onTimeUpdate != null) {
            onTimeUpdate!(controller.value.position, controller.value.metaData.duration);
          }
        });
        if (onReady != null) onReady!();
      },
    );
  }
} 