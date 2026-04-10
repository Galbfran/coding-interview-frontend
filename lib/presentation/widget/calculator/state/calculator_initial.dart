import 'package:flutter/material.dart';

/// Cuerpo cuando el cubit aún no emitió un estado de trabajo (raro tras el primer evento).
class CalculatorInitialContent extends StatelessWidget {
  const CalculatorInitialContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
