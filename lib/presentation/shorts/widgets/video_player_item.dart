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
  final VideoPlayerController
      videoPlayerController; // Pre-initialized controller
  final bool isInitialized; // Track whether the controller is initialized

  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.profileUrl,
    this.savedPosition,
    required this.onPositionChanged,
    required this.videoPlayerController,
    required this.isInitialized,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with AutomaticKeepAliveClientMixin {
  ChewieController? chewieController;
  bool isLiked = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();

    // Initialize the Chewie controller only when the VideoPlayerController is ready
    chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoPlay: false,
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
  }

  @override
  void dispose() {
    // Do NOT dispose the video controller here, it is managed in the parent widget
    chewieController?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  // Manually play/pause when the video becomes visible
  void onVisibilityChanged(VisibilityInfo visibilityInfo) {
    final isCurrentlyPlaying = widget.videoPlayerController.value.isPlaying;

    if (visibilityInfo.visibleFraction >= 0.7 && !isCurrentlyPlaying) {
      widget.videoPlayerController.play();
      if (mounted) {
        setState(() {
          isPaused = false;
        });
      }
    } else if (visibilityInfo.visibleFraction < 0.7 && isCurrentlyPlaying) {
      if (mounted) {
        widget.videoPlayerController.pause();
        setState(() {
          isPaused = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Show shimmer effect if the video is not initialized yet
    if (!widget.isInitialized) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height - 120,
            width: double.infinity,
            child: const Center(child: SizedBox.shrink()),
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
                    aspectRatio: widget.videoPlayerController.value.aspectRatio,
                    child: Chewie(controller: chewieController!),
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
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: toggleLike,
                  ),
                  Text('999.9K'),
                  const Divider(
                    height: 10,
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

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void shareVideo() {
    print("Sharing the video...");
  }
}
