import 'package:flutter/material.dart';

mixin TapDebouncer<T extends StatefulWidget> on State<T> {
  bool _isButtonEnabled = true;

  void handleTap(void Function()? onPressed) async {
    if (_isButtonEnabled) {
      if (mounted) {
        setState(() {
          _isButtonEnabled = false;
        });
      }
      onPressed?.call();
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _isButtonEnabled = true;
        });
      }
    }
  }
}
