import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CalculatorSummaryRow extends StatelessWidget {
  const CalculatorSummaryRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      dense: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.labelGrey,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textStrong,
        ),
      ),
    );
  }
}
