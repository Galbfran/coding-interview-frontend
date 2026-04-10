import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SplashGradientBackground extends StatelessWidget {
  const SplashGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.sky,
            Color.lerp(AppColors.sky, AppColors.accent, 0.5)!,
          ],
        ),
      ),
      child: child,
    );
  }
}
