import 'package:flutter/material.dart';

import '../../mixin/tap_debouncer.dart';
import '../circuler_widget.dart';

class BtnCirculer extends StatefulWidget {
  const BtnCirculer({
    required this.child,
    this.radius = 24,
    this.backgroundColor = Colors.transparent,
    this.onTap,
    this.borderSide = BorderSide.none,
    this.borderRadius,
    super.key,
  });
  final VoidCallback? onTap;
  final Widget child;
  final Color backgroundColor;
  final double radius;
  final double? borderRadius;
  final BorderSide borderSide;

  @override
  State<BtnCirculer> createState() => _BtnCirculerState();
}

class _BtnCirculerState extends State<BtnCirculer> with TapDebouncer {
  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: widget.borderRadius != null
          ? null
          : CircleBorder(side: widget.borderSide),
      borderRadius: widget.borderRadius != null
          ? BorderRadius.circular(widget.borderRadius!)
          : null,
      color: widget.backgroundColor,
      child: InkWell(
        onTap: () => handleTap(widget.onTap),
        child: CirculerWidget(
          radius: widget.radius,
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}
