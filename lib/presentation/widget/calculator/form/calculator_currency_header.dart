import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:conversion_calculator/data/model/enum/crypto_currency_id.dart';
import 'package:conversion_calculator/data/model/enum/fiat_currency_id.dart';
import 'package:conversion_calculator/presentation/widget/calculator/currency_selection/currency_selection_catalog.dart';
import 'package:conversion_calculator/presentation/widget/calculator/currency_selection/currency_selection_sheet.dart';
import 'package:flutter/material.dart';

/// TENGO / QUIERO con [ValueNotifier]: solo esta zona se reconstruye al cambiar monedas o swap.
class CalculatorCurrencyHeader extends StatelessWidget {
  const CalculatorCurrencyHeader({
    super.key,
    required this.cryptoNotifier,
    required this.fiatNotifier,
    required this.tengoIsCryptoNotifier,
    required this.onSwap,
    this.interactionsEnabled = true,
  });

  final ValueNotifier<CryptoCurrencyId> cryptoNotifier;
  final ValueNotifier<FiatCurrencyId> fiatNotifier;
  final ValueNotifier<bool> tengoIsCryptoNotifier;
  final VoidCallback onSwap;

  /// Si es `false`, no se abren selectores ni el swap (p. ej. mientras carga el API).
  final bool interactionsEnabled;

  Future<void> _pickFiat(BuildContext context) async {
    final code = await showCurrencySelectionSheet(
      context: context,
      sheetTitle: 'FIAT',
      options: CurrencySelectionCatalog.fiatOptions(),
      selectedCode: fiatNotifier.value.asApiId,
    );
    if (!context.mounted || code == null) return;
    final id = CurrencySelectionCatalog.fiatFromCode(code);
    if (id != null) fiatNotifier.value = id;
  }

  Future<void> _pickCrypto(BuildContext context) async {
    final code = await showCurrencySelectionSheet(
      context: context,
      sheetTitle: 'Cripto',
      options: CurrencySelectionCatalog.cryptoOptions(),
      selectedCode: cryptoNotifier.value.asApiId,
    );
    if (!context.mounted || code == null) return;
    final id = CurrencySelectionCatalog.cryptoFromCode(code);
    if (id != null) cryptoNotifier.value = id;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        cryptoNotifier,
        fiatNotifier,
        tengoIsCryptoNotifier,
      ]),
      builder: (context, _) {
        final tengoCrypto = tengoIsCryptoNotifier.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'TENGO',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.labelGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
                Expanded(
                  child: Text(
                    'QUIERO',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.labelGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent, width: 1.2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: tengoCrypto
                        ? _cryptoPill(context)
                        : _fiatPill(context, alignEnd: false),
                  ),
                  IconButton(
                    onPressed: interactionsEnabled ? onSwap : null,
                    icon: Icon(Icons.swap_horiz, color: AppColors.accent),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.accent.withValues(alpha: 0.15),
                    ),
                  ),
                  Expanded(
                    child: tengoCrypto
                        ? _fiatPill(context, alignEnd: true)
                        : _cryptoPill(context, alignEnd: true),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _cryptoPill(BuildContext context, {bool alignEnd = false}) {
    final label =
        CurrencySelectionCatalog.displayTitleForCrypto(cryptoNotifier.value);
    return _pill(
      context: context,
      label: label,
      alignEnd: alignEnd,
      onTap: interactionsEnabled ? () => _pickCrypto(context) : null,
    );
  }

  Widget _fiatPill(BuildContext context, {bool alignEnd = false}) {
    final label =
        CurrencySelectionCatalog.displayTitleForFiat(fiatNotifier.value);
    return _pill(
      context: context,
      label: label,
      alignEnd: alignEnd,
      onTap: interactionsEnabled ? () => _pickFiat(context) : null,
    );
  }

  Widget _pill({
    required BuildContext context,
    required String label,
    required bool alignEnd,
    required VoidCallback? onTap,
  }) {
    final arrowColor =
        onTap != null ? AppColors.accent : AppColors.labelGrey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment:
              alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (alignEnd) const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: onTap != null ? Colors.black87 : AppColors.labelGrey,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: arrowColor),
            if (!alignEnd) const Spacer(),
          ],
        ),
      ),
    );
  }
}
