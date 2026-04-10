import 'package:conversion_calculator/data/model/enum/crypto_currency_id.dart';
import 'package:conversion_calculator/data/model/enum/fiat_currency_id.dart';
import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// TENGO / QUIERO con [ValueNotifier]: solo esta zona se reconstruye al cambiar monedas o swap.
class CalculatorCurrencyHeader extends StatelessWidget {
  const CalculatorCurrencyHeader({
    super.key,
    required this.cryptoNotifier,
    required this.fiatNotifier,
    required this.tengoIsCryptoNotifier,
    required this.onSwap,
  });

  final ValueNotifier<CryptoCurrencyId> cryptoNotifier;
  final ValueNotifier<FiatCurrencyId> fiatNotifier;
  final ValueNotifier<bool> tengoIsCryptoNotifier;
  final VoidCallback onSwap;

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
                        ? _cryptoPill(cryptoNotifier)
                        : _fiatPill(fiatNotifier, alignEnd: false),
                  ),
                  IconButton(
                    onPressed: onSwap,
                    icon: Icon(Icons.swap_horiz, color: AppColors.accent),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.accent.withValues(alpha: 0.15),
                    ),
                  ),
                  Expanded(
                    child: tengoCrypto
                        ? _fiatPill(fiatNotifier, alignEnd: true)
                        : _cryptoPill(cryptoNotifier, alignEnd: true),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _cryptoPill(
    ValueNotifier<CryptoCurrencyId> notifier, {
    bool alignEnd = false,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<CryptoCurrencyId>(
        value: notifier.value,
        isExpanded: true,
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.accent),
        items: CryptoCurrencyId.values
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(switch (e) {
                  CryptoCurrencyId.tatumTronUsdt => 'USDT',
                }),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v != null) notifier.value = v;
        },
      ),
    );
  }

  Widget _fiatPill(
    ValueNotifier<FiatCurrencyId> notifier, {
    bool alignEnd = false,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<FiatCurrencyId>(
        value: notifier.value,
        isExpanded: true,
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.accent),
        items: FiatCurrencyId.values
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e.asApiId),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v != null) notifier.value = v;
        },
      ),
    );
  }
}
