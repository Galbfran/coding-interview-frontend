import 'package:conversion_calculator/presentation/widget/calculator/background/calculator_painter.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_card.dart';
import 'package:flutter/material.dart';

class CalculatorBody extends StatelessWidget {
  const CalculatorBody({super.key});

  static const double _cardMaxWidth = 420;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(child: CalculatorScreenBackground()),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
              child: const CalculatorCard(),
            ),
          ),
        ),
      ],
    );
  }
}
