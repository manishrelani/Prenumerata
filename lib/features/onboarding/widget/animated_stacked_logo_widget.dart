// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../generated/assets.gen.dart';

class LogoMetadata {
  final String title;
  final String imageUrl;
  final Color color;

  const LogoMetadata({
    required this.title,
    required this.imageUrl,
    required this.color,
  });
}

class AnimatedStackedLogoWidget extends StatefulWidget {
  const AnimatedStackedLogoWidget({super.key});

  @override
  State<AnimatedStackedLogoWidget> createState() => _AnimatedStackedLogoWidgetState();
}

class _AnimatedStackedLogoWidgetState extends State<AnimatedStackedLogoWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;

  bool isAnimating = false;
  bool isLeftSwipe = true;

  bool isInitialized = false;

  List<LogoMetadata> widgets = [
    const LogoMetadata(
      title: 'Netflix',
      imageUrl: Assets.svgsLogosNetflix,
      color: Colors.red,
    ),
    const LogoMetadata(
      title: 'Spotify',
      imageUrl: Assets.svgsLogosSpotify,
      color: Colors.green,
    ),
    const LogoMetadata(
      title: 'Youtube',
      imageUrl: Assets.svgsLogosYoutube,
      color: Colors.redAccent,
    ),
    const LogoMetadata(
      title: 'Figma',
      imageUrl: Assets.svgsLogosFigma,
      color: Colors.purple,
    ),
    const LogoMetadata(
      title: 'Discord',
      imageUrl: Assets.svgsLogosDiscord,
      color: Colors.blue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationComplete();
      }
    });

    accelerometerSubscription = accelerometerEventStream().listen((event) {
      if (!isAnimating) {
        if (event.x < -6) {
          _slideRight();
        } else if (event.x > 6) {
          _slideLeft();
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      initFirstAnimation();
    });
  }

  void _onAnimationComplete() {
    setState(() {
      if (isInitialized) {
        if (isLeftSwipe) {
          final first = widgets.removeAt(0);
          widgets.add(first);
          isAnimating = false;
        } else {
          final last = widgets.removeLast();
          widgets.insert(0, last);
        }
      } else {
        isInitialized = true;
      }

      isAnimating = false;
      _animationController.reset();
    });
    _animationController.reset();
  }

  void initFirstAnimation() {
    isAnimating = true;
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _slideLeft() {
    if (isAnimating || !isInitialized) return;

    isAnimating = true;
    isLeftSwipe = true;
    _animationController.forward();
  }

  void _slideRight() {
    if (isAnimating || !isInitialized) return;

    isAnimating = true;
    isLeftSwipe = false;

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final totalWidth = size.width * 0.75;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.2,
            width: totalWidth,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildBackgroundColor(),
                ..._buildStackedWidgets(totalWidth),
              ],
            ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ElevatedButton(
          //       onPressed: _slideLeft,
          //       child: const Text(' ← Slide Left'),
          //     ),
          //     const SizedBox(width: 20),

          //     ElevatedButton(
          //       onPressed: _slideRight,
          //       child: const Text('Slide Right →'),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildBackgroundColor() {
    final Color beginColor = widgets[2].color;
    final Color endColor = isLeftSwipe ? widgets[3].color : widgets[1].color;

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        final t = isAnimating && isInitialized ? _slideAnimation.value : 0.0;

        // Animate between gradients
        final Color centerColor = Color.lerp(beginColor, endColor, t)!;

        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1,
              colors: [
                centerColor,
                centerColor.withValues(alpha: 0.8),
              ],
              stops: const [0.1, 0.4],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 40.0),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).width * 0.4,
              width: MediaQuery.sizeOf(context).width * 0.4,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildStackedWidgets(double width) {
    List<MapEntry<int, Widget>> stackedWidgets = [];

    final basewidth = width / 5;

    for (int index = 0; index < 5; index++) {
      int zIndex = _getZIndex(index);
      final centerLeft = 2 * basewidth;

      final baseLeft = isInitialized ? index * basewidth : centerLeft;
      final baseScale = isInitialized ? _getScale(index) : _getScale(2);

      Widget widget = AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          double left = baseLeft;
          double scale = baseScale;
          if (isAnimating) {
            if (isInitialized) {
              int targetIndex = isLeftSwipe ? (index == 0 ? 4 : index - 1) : (index == 4 ? 0 : index + 1);
              left = baseLeft + _slideAnimation.value * ((targetIndex - index) * basewidth);
              final targetScale = _getScale(targetIndex);
              scale = baseScale + _slideAnimation.value * (targetScale - baseScale);
            } else {
              if (index != 2) {
                left = centerLeft + ((index * basewidth) - centerLeft) * _slideAnimation.value;
                final targetScale = _getScale(index);
                scale = baseScale + _slideAnimation.value * (targetScale - baseScale);
              }
            }
          }

          return Positioned(
            left: left,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: basewidth,
                height: basewidth,
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20.0,
                      spreadRadius: 30.0,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  widgets[index].imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        },
      );

      stackedWidgets.add(MapEntry(zIndex, widget));
    }

    // Sort by z-index and return widgets in proper stacking order
    stackedWidgets.sort((a, b) => a.key.compareTo(b.key));
    return stackedWidgets.map((entry) => entry.value).toList();
  }

  int _getZIndex(int index) {
    switch (index) {
      case 0:
      case 4:
        return 1; // Outermost widgets (1st and 5th)
      case 1:
      case 3:
        return 2; // Inner widgets (2nd and 4th)
      case 2:
        return 3; // Center widget (3rd)
      default:
        return 1;
    }
  }

  double _getScale(int index) {
    switch (index) {
      case 0:
      case 4:
        return 1.2;
      case 1:
      case 3:
        return 1.35;
      case 2:
        return 1.5;
      default:
        return 1;
    }
  }
}
