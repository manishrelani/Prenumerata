import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CirculerWidget extends StatelessWidget {
  const CirculerWidget({
    required this.radius,
    required this.child,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.gradient,
    this.boxShadow,
    super.key,
  });
  final double radius;
  final Color? backgroundColor;
  final Widget child;
  final BoxBorder? border;
  final double? borderRadius;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: radius * 2,
      width: radius * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: borderRadius != null ? BoxShape.rectangle : BoxShape.circle,
        border: border,
        borderRadius: borderRadius == null
            ? null
            : BorderRadius.circular(borderRadius!),
        boxShadow: boxShadow,
        gradient: gradient,
      ),
      child: child,
    );
  }
}
