import 'package:flutter/material.dart';
import 'package:prenumerata/core/widget/bounce.dart';

class BtnPrimary extends StatelessWidget {
  const BtnPrimary({
    super.key,
    required this.title,
    this.onPressed,
    this.height = 48.0,
    this.width = double.infinity,
    this.style,
  });
  final String title;
  final VoidCallback? onPressed;
  final double height;
  final double width;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    return Bounce(
      onPressed: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: (isDisabled ? Colors.black : Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          height: height,
          width: width,
          child: Center(
            child: FittedBox(
              child: Text(
                title,
                style:
                    style ??
                    TextStyle(
                      color: isDisabled ? Colors.grey[600] : Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
