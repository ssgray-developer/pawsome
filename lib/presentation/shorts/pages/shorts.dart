import 'package:flutter/material.dart';
import '../widgets/video_player_item.dart';
import 'package:video_player/video_player.dart';

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
  Map<String, VideoPlayerController> videoControllers =
      {}; // To hold pre-initialized controllers
  Map<String, bool> videoControllersInitialized =
      {}; // To track initialization state

  @override
  void initState() {
    super.initState();
    // Initialize all video controllers before rendering any video
    for (var url in ShortsScreen.videoUrls) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          setState(() {
            videoControllersInitialized[url] =
                true; // Mark the controller as initialized
          });
        });
      videoControllers[url] = controller;
      videoControllersInitialized[url] = false; // Initially, set them to false
    }
  }

  void updateVideoPosition(String videoUrl, double position) {
    setState(() {
      videoPositions[videoUrl] = position;
    });
  }

  VideoPlayerController getVideoController(String videoUrl) {
    return videoControllers[videoUrl]!;
  }

  @override
  void dispose() {
    // Dispose all controllers to free up resources (disposing only once)
    for (var controller in videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      itemCount: ShortsScreen.videoUrls.length,
      itemBuilder: (context, index) {
        String videoUrl = ShortsScreen.videoUrls[index];

        // Check if the controller is initialized
        bool isInitialized = videoControllersInitialized[videoUrl] ?? false;

        // Only display the video player when it's initialized
        return VideoPlayerItem(
          videoUrl: videoUrl,
          title: 'Video Title $index',
          description: 'Description of Video $index',
          profileUrl: 'https://pixhost.icu/avaxhome/ae/42/00a642ae.jpg',
          savedPosition: videoPositions[videoUrl],
          onPositionChanged: updateVideoPosition,
          videoPlayerController: getVideoController(videoUrl),
          isInitialized: isInitialized, // Pass the initialized state
        );
      },
    );
  }
}
