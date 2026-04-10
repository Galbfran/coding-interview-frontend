import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CalculatorSummaryRow extends StatelessWidget {
  const CalculatorSummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.valueFontStyle,
    this.valueMaxLines = 3,
  });

  final String title;
  final String value;
  final Color? valueColor;
  final FontStyle? valueFontStyle;
  final int valueMaxLines;

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: valueColor ?? AppColors.textStrong,
      fontStyle: valueFontStyle,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.labelGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: valueMaxLines,
              overflow: TextOverflow.ellipsis,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}
