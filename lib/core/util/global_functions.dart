import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'global.dart';

void showCustomModelBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool isScrollControlled = false,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 500),
    ),

    builder: builder,
  );
}

void showLoader() {
  navigatorKey.currentContext!.loaderOverlay.show();
}

void hideLoader() {
  navigatorKey.currentContext!.loaderOverlay.hide();
}
