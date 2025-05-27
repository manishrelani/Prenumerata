import 'package:flutter/material.dart';

import 'global.dart';

final class SnackToast {
  SnackToast._();

  static void show({required String message, int durationMs = 3000}) {
    final context = navigatorKey.currentContext!;
    final messanger = ScaffoldMessenger.of(context);
    messanger.hideCurrentSnackBar();
    messanger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.black),
        ),
        duration: Duration(milliseconds: durationMs),
      ),
    );
  }
}
