import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/presentation/shorts/widgets/video_player_item.dart';

class ProfilePictureItem extends StatelessWidget {
  const ProfilePictureItem({
    super.key,
    required this.widget,
  });

  final VideoPlayerItem widget;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: CachedNetworkImageProvider(widget.profileUrl),
    );
  }
}
