import 'package:flutter/material.dart';

import '../widgets/video_player_item.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  static List<String> videoUrls = [
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    "https://videos.pexels.com/video-files/6853337/6853337-sd_506_960_25fps.mp4",
    "https://videos.pexels.com/video-files/4624594/4624594-sd_360_640_30fps.mp4",
  ];

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  final PageController pageController = PageController();
  Map<String, double> videoPositions = {};

  void updateVideoPosition(String videoUrl, double position) {
    setState(() {
      videoPositions[videoUrl] = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      itemCount: ShortsScreen.videoUrls.length,
      itemBuilder: (context, index) {
        String videoUrl = ShortsScreen.videoUrls[index];
        return VideoPlayerItem(
          videoUrl: videoUrl,
          title: 'Video Title $index',
          description: 'Description of Video $index',
          profileUrl: 'https://pixhost.icu/avaxhome/ae/42/00a642ae.jpg',
          savedPosition: videoPositions[videoUrl],
          onPositionChanged: updateVideoPosition,
        );
      },
    );
  }
}
