import 'package:flutter/material.dart';

class CalculatorLoadedContent extends StatelessWidget {
  const CalculatorLoadedContent({
    super.key,
    required this.rate,
    required this.convertedAmount,
  });

  final double rate;
  final double convertedAmount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Tasa: $rate', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            'Recibirás: ${convertedAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
