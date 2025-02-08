import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:marquee/marquee.dart';
import 'package:pawsome/core/theme/app_colors.dart';
import 'package:pawsome/core/theme/app_values.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final String profileUrl;
  final double? savedPosition;
  final Function(String, double)
      onPositionChanged; // Callback to update position

  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.profileUrl,
    this.savedPosition,
    required this.onPositionChanged,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool isLiked = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    // Initialize the video player controller asynchronously
    videoPlayerController.initialize().then((_) {
      // If there's a saved position, seek to it
      if (widget.savedPosition != null) {
        videoPlayerController
            .seekTo(Duration(seconds: widget.savedPosition!.toInt()));
      }

      // Set up the Chewie controller
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false, // Disable autoPlay, we'll handle it manually
        looping: true,
        allowFullScreen: false,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.white,
          handleColor: AppColors.primary,
          backgroundColor: Colors.black,
          bufferedColor: Colors.white12,
        ),
      );
      setState(() {}); // Rebuild once the Chewie controller is ready
    });
  }

  @override
  void dispose() {
    // Save the current position when the video is disposed
    widget.onPositionChanged(widget.videoUrl,
        videoPlayerController.value.position.inSeconds.toDouble());
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; // Ensure that the widget is kept alive

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void shareVideo() {
    print("Sharing the video...");
  }

  // Manually play/pause when the video becomes visible
  void onVisibilityChanged(VisibilityInfo visibilityInfo) {
    final isCurrentlyPlaying =
        chewieController?.videoPlayerController.value.isPlaying ?? false;

    if (visibilityInfo.visibleFraction >= 0.7 && !isCurrentlyPlaying) {
      chewieController?.videoPlayerController.play();
      if (mounted) {
        setState(() {
          isPaused = false;
        });
      }
    } else if (visibilityInfo.visibleFraction < 0.7 && isCurrentlyPlaying) {
      if (mounted) {
        chewieController?.videoPlayerController.pause();
        setState(() {
          isPaused = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Show shimmer effect while the video is initializing
    if (!videoPlayerController.value.isInitialized) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height - 120,
            width: double.infinity,
            child: const Center(
              child: SizedBox.shrink(),
            ),
          ),
        ),
      );
    }

    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: onVisibilityChanged,
      child: Container(
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
                    child: chewieController != null
                        ? Chewie(controller: chewieController!)
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 170,
              child: SizedBox(
                height: 40,
                width: 200,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(top: 10),
                  dense: true,
                  horizontalTitleGap: 5,
                  visualDensity: VisualDensity.comfortable,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        CachedNetworkImageProvider(widget.profileUrl),
                  ),
                  title: widget.title.isEmpty
                      ? const Text(
                          'Nil',
                          style: TextStyle(fontSize: AppSize.s14),
                        )
                      : widget.title.length < 20
                          ? Text(
                              widget.title,
                              style: const TextStyle(fontSize: AppSize.s14),
                            )
                          : Marquee(
                              text: widget.title,
                              velocity: 10,
                              blankSpace: 20,
                              numberOfRounds: 1,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              style: const TextStyle(fontSize: AppSize.s14),
                            ),
                  subtitle: widget.description.isEmpty
                      ? const Text(
                          'Nil',
                          style: TextStyle(fontSize: AppSize.s14),
                        )
                      : widget.description.length < 20
                          ? Text(
                              widget.description,
                              style: const TextStyle(fontSize: AppSize.s12),
                            )
                          : Marquee(
                              text: widget.description,
                              velocity: 20,
                              blankSpace: 20,
                              numberOfRounds: 2,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              style: const TextStyle(fontSize: AppSize.s12),
                            ),
                  subtitleTextStyle: const TextStyle(fontSize: AppSize.s12),
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
      ),
    );
  }
}
