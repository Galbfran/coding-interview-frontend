import 'package:flutter/material.dart';

class SplashPulsingBrand extends StatelessWidget {
  const SplashPulsingBrand({
    super.key,
    required this.listenable,
    required this.scale,
    required this.opacity,
    this.assetPath = 'assets/el_dorado_icono.png',
    this.size = 112,
  });

  final Listenable listenable;
  final Animation<double> scale;
  final Animation<double> opacity;
  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.scale(
            scale: scale.value,
            child: child,
          ),
        );
      },
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
