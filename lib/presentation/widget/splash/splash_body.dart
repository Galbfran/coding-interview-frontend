import 'dart:async';

import 'package:conversion_calculator/core/router/app_router.dart';
import 'package:conversion_calculator/presentation/widget/splash/splash_gradient_background.dart';
import 'package:conversion_calculator/presentation/widget/splash/splash_pulsing_brand.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  static const Duration navigationDelay = Duration(seconds: 2);

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _navTimer = Timer(SplashBody.navigationDelay, () {
      if (!mounted) return;
      context.go(PathRoutes.calculator);
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashGradientBackground(
      child: Center(
        child: SplashPulsingBrand(
          listenable: _pulseController,
          scale: _scale,
          opacity: _opacity,
        ),
      ),
    );
  }
}
