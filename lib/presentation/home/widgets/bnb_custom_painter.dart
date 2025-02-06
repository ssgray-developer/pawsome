import 'package:flutter/material.dart';

class BNBCustomPainter extends CustomPainter {
  final double curveProgress;

  BNBCustomPainter(
      {super.repaint,
      required this.curveProgress}); // 0.0 for straight, 1.0 for curved

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Calculate dynamic values based on the curveProgress (0.0 to 1.0)
    double curveFactor = curveProgress;

    path.moveTo(0, 20); // Start

    path.quadraticBezierTo(
        size.width * 0.20 * curveFactor,
        (-20 * curveProgress + 20),
        size.width * 0.35 * curveFactor,
        (-20 * curveProgress + 20));

    path.quadraticBezierTo(
        size.width * 0.40, (-20 * curveProgress + 20), size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0 * curveProgress), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, (-20 * curveProgress + 20),
        size.width * 0.65, (-20 * curveProgress + 20));
    path.quadraticBezierTo(
        size.width * 0.80, (-20 * curveProgress + 20), size.width, 20);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);

    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Repaint when animation changes
  }
}
