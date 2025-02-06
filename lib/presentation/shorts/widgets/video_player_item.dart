import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/core/theme/app_colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    // await controller.initialize();
    // Initialize video player controller asynchronously
    videoPlayerController.initialize().then((_) {
      // Once video is initialized, setup Chewie controller
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        // autoInitialize: true,
        looping: true,
        // showControls: true,
        allowFullScreen: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.white, // Change the played color to red
          handleColor: AppColors.primary, // Change the handle color to green
          backgroundColor:
              Colors.black, // Set background color for progress bar
          bufferedColor: Colors.white12,
        ),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void shareVideo() {
    print("Sharing the video...");
  }

  @override
  Widget build(BuildContext context) {
    // Wait until the video is initialized before showing Chewie
    if (!videoPlayerController.value.isInitialized) {
      return const Center(
          child:
              CircularProgressIndicator()); // Show loading while initializing
    }

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 120,
                child: AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: Chewie(controller: chewieController)),
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            right: 20,
            child: Column(
              spacing: 10,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: toggleLike,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: shareVideo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
