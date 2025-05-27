import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomCirculerProgress extends StatelessWidget {
  const CustomCirculerProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _SpinKitCubeGrid(
        duration: const Duration(milliseconds: 600),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _SpinKitCubeGrid extends StatefulWidget {
  const _SpinKitCubeGrid({
    this.color,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
  }) : assert(
         !(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
         'You should specify either a itemBuilder or a color',
       );

  final Color? color;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;

  @override
  State<_SpinKitCubeGrid> createState() => _SpinKitCubeGridState();
}

class _SpinKitCubeGridState extends State<_SpinKitCubeGrid> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim1;
  late Animation<double> _anim2;
  late Animation<double> _anim3;
  late Animation<double> _anim4;
  late Animation<double> _anim5;

  final double size = 50;

  @override
  void initState() {
    super.initState();

    _controller = (AnimationController(vsync: this, duration: widget.duration))..repeat(reverse: true);
    _anim1 = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeIn),
      ),
    );
    _anim2 = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeIn),
      ),
    );
    _anim3 = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );
    _anim4 = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeIn),
      ),
    );
    _anim5 = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double angle = _controller.status == AnimationStatus.forward ? 0 : math.pi;
        // Just rotate it 180 degrees to display it as showcased
        return Transform.rotate(
          angle: angle,
          child: child,
        );
      },
      child: SizedBox.fromSize(
        size: Size.square(size),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _square(_anim3, 0),
                _square(_anim4, 1),
                _square(_anim5, 2),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _square(_anim2, 3),
                _square(_anim3, 4),
                _square(_anim4, 5),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _square(_anim1, 6),
                _square(_anim2, 7),
                _square(_anim3, 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _square(Animation<double> animation, int index) {
    return ScaleTransition(
      scale: animation,
      child: SizedBox.fromSize(
        size: Size.square(size / 3),
        child: _itemBuilder(index),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: widget.color));
}
