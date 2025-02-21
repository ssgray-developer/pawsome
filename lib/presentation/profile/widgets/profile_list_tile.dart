import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  final Widget leadingWidget;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const ProfileListTile(
      {super.key,
      required this.leadingWidget,
      required this.title,
      this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      dense: false,
      leading: leadingWidget,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
            overflow: TextOverflow.ellipsis),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(color: Colors.grey[600]),
            ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey[800],
        size: 18,
      ),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
