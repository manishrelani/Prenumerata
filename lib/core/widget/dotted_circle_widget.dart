import 'package:flutter/material.dart';

import '../painter/dotted_circle_pinter.dart';

class DottedCircleWidget extends StatelessWidget {
  final double radius;
  final Widget? child;
  const DottedCircleWidget({super.key, required this.radius, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Center(
        child: CustomPaint(
          painter: DottedCirclePainter(),
          child: child != null ? Center(child: child) : null,
        ),
      ),
    );
  }
}
