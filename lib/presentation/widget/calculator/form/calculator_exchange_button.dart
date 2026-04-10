import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:conversion_calculator/presentation/widget/calculator/form/calculator_form_tokens.dart';
import 'package:flutter/material.dart';

class CalculatorExchangeButton extends StatelessWidget {
  const CalculatorExchangeButton({
    super.key,
    required this.onPressed,
    this.label = 'Cambiar',
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        elevation: onPressed != null
            ? CalculatorFormTokens.exchangeButtonElevation
            : 0,
        shadowColor: AppColors.accent.withValues(alpha: 0.32),
        surfaceTintColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: CalculatorFormTokens.exchangeButtonLabelFontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}
