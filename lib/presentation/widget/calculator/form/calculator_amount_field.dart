import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:conversion_calculator/presentation/widget/calculator/form/calculator_form_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorAmountField extends StatelessWidget {
  const CalculatorAmountField({
    super.key,
    required this.controller,
    required this.currencyPrefix,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String currencyPrefix;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(CalculatorFormTokens.amountBorderRadius);
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      decoration: InputDecoration(
        contentPadding: CalculatorFormTokens.amountContentPadding,
        border: OutlineInputBorder(
          borderRadius: r,
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: CalculatorFormTokens.amountBorderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: r,
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: CalculatorFormTokens.amountBorderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: r,
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: CalculatorFormTokens.amountBorderWidthFocused,
          ),
        ),
        prefixText: '$currencyPrefix ',
        prefixStyle: const TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
