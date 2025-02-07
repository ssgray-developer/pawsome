import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:pawsome/core/theme/app_colors.dart';
import 'package:pawsome/core/theme/app_values.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final String profileUrl;
  const VideoPlayerItem(
      {super.key,
      required this.videoUrl,
      required this.title,
      required this.description,
      required this.profileUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
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
    chewieController?.dispose();
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
    );
  }
}
