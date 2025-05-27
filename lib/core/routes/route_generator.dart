import 'package:flutter/material.dart';

import '../../features/home/presentation/main/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import 'screen_name.dart';

final class RouteGenerator {
  RouteGenerator._();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ScreenName.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case ScreenName.onboard:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const SizedBox(),
        );
    }
  }
}
