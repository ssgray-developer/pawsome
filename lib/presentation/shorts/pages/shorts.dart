import 'package:flutter/material.dart';
import 'package:pawsome/presentation/shorts/widgets/video_player_item.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  static List<String> videoUrls = [
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4", // Replace with actual video URLs
    "https://videos.pexels.com/video-files/6853337/6853337-sd_506_960_25fps.mp4",
    "https://videos.pexels.com/video-files/4624594/4624594-sd_360_640_30fps.mp4",
    // Add more video URLs
  ];

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: ShortsScreen.videoUrls.length,
        physics: isLoading ? const NeverScrollableScrollPhysics() : null,
        itemBuilder: (context, index) {
          return VideoPlayerItem(
            videoUrl: ShortsScreen.videoUrls[index],
            title: 'hsdbfiugubfiouseboifvodiadiufewiofaorfihaoifuh',
            description: 'adsiouvnidunvpoaidvbiaudsbis',
            profileUrl: 'https://pixhost.icu/avaxhome/ae/42/00a642ae.jpg',
          );
        });
  }
}
