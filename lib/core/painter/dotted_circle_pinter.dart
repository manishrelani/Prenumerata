import 'dart:math';

import 'package:flutter/material.dart';

class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final int dotCount = 40;
    final double radius = size.width / 2;
    final double dotRadius = 1;
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < dotCount; i++) {
      double angle = (2 * pi / dotCount) * i;
      Offset center = Offset(size.width / 2, size.height / 2);
      Offset dotOffset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawCircle(dotOffset, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
