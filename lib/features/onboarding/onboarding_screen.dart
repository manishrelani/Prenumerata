import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/routes/screen_name.dart';
import '../../core/widget/buttons/btn_primary.dart';
import '../../core/widget/platform_spacer.dart';
import 'widget/animated_stacked_logo_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            const Expanded(
                  flex: 5,
                  child: RepaintBoundary(
                    child: AnimatedStackedLogoWidget(),
                  ),
                )
                .animate()
                .scale(
                  duration: 1000.ms,
                  curve: Curves.ease,
                )
                .moveY(
                  delay: 100.ms,
                  duration: 1000.ms,
                  curve: Curves.ease,
                  begin: MediaQuery.sizeOf(context).height * 0.2,
                ),

            const Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text(
                        'Manage all your subscriptions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        'Keep Regular expenses on hand and recieive timely notifications of upcoming fees',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .moveY(
                  duration: 1000.ms,
                  curve: Curves.ease,
                  begin: MediaQuery.sizeOf(context).height * 0.1,
                )
                .fade(
                  duration: 1000.ms,
                  curve: Curves.ease,
                ),
            BtnPrimary(
              title: 'Get Started',
              onPressed: () {
                Navigator.pushReplacementNamed(context, ScreenName.home);
              },
            ).animate().moveY(
              duration: 1000.ms,
              curve: Curves.ease,
              begin: MediaQuery.sizeOf(context).height * 0.2,
            ),
            const PlatformSpacer(),
          ],
        ),
      ),
    );
  }
}
