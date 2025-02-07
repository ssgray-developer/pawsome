import 'package:flutter/material.dart';
import 'package:pawsome/presentation/shorts/widgets/video_player_item.dart';

class ShortsScreen extends StatelessWidget {
  const ShortsScreen({super.key});

  static List<String> videoUrls = [
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4", // Replace with actual video URLs
    "https://videos.pexels.com/video-files/6853337/6853337-sd_506_960_25fps.mp4",
    "https://videos.pexels.com/video-files/4624594/4624594-sd_360_640_30fps.mp4",
    // Add more video URLs
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return VideoPlayerItem(
            videoUrl: videoUrls[index],
            title: 'hsdbfiugubfiouseboifvodiadiufewiofaorfihaoifuh',
            description: 'adsiouvnidunvpoaidvbiaudsbis',
          );
        });
  }
}
