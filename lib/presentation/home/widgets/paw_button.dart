import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PawButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PawButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.primary,
          fixedSize: const Size(60, 60)),
      child: Image.asset(
        'assets/images/icon_image.png',
        width: 30,
        color: AppColors.white,
      ),
    );
  }
}
