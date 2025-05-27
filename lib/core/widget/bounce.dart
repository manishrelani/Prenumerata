import 'package:flutter/material.dart';

import '../mixin/tap_debouncer.dart';

class Bounce extends StatefulWidget {
  const Bounce({
    super.key,
    required this.child,
    this.isEnabled = true,
    this.shouldDebounce = true,
    this.onPressed,
  });
  final Widget child;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool shouldDebounce;

  @override
  State<Bounce> createState() => _BounceState();
}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin, TapDebouncer {
  late double _scale;

  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 100),
          lowerBound: 0.0,
          upperBound: 0.02,
        )..addListener(() {
          setState(() {});
        });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: (_) => _forwordController(),
      onTapUp: (_) => _tapUp(),
      onTapCancel: _reverseController,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  void _tapUp() {
    _reverseController();
    if (widget.shouldDebounce) {
      handleTap(widget.onPressed);
    } else {
      widget.onPressed?.call();
    }
  }

  void _reverseController() {
    if (widget.isEnabled) _controller.reverse();
  }

  void _forwordController() {
    if (widget.isEnabled) _controller.forward();
  }
}
