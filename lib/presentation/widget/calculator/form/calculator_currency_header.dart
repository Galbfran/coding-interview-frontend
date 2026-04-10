import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:conversion_calculator/data/model/enum/crypto_currency_id.dart';
import 'package:conversion_calculator/data/model/enum/fiat_currency_id.dart';
import 'package:conversion_calculator/presentation/widget/calculator/currency_selection/currency_selection_catalog.dart';
import 'package:conversion_calculator/presentation/widget/calculator/currency_selection/currency_selection_sheet.dart';
import 'package:conversion_calculator/presentation/widget/calculator/form/calculator_form_tokens.dart';
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
        final hInset = CalculatorFormTokens.selectorHorizontalInset;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: CalculatorFormTokens.selectorLabelBorderOverlap,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    CalculatorFormTokens.selectorBorderRadius,
                  ),
                  border: Border.all(
                    color: AppColors.accent,
                    width: CalculatorFormTokens.selectorBorderWidth,
                  ),
                ),
                clipBehavior: Clip.none,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: tengoCrypto
                                ? _cryptoPill(context, alignEnd: false)
                                : _fiatPill(context, alignEnd: false),
                          ),
                          Expanded(
                            child: tengoCrypto
                                ? _fiatPill(context, alignEnd: true)
                                : _cryptoPill(context, alignEnd: true),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                      scale: CalculatorFormTokens.swapButtonVisualScale,
                      child: _SwapOverlapButton(
                        enabled: interactionsEnabled,
                        onSwap: onSwap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: CalculatorFormTokens.selectorLabelTop,
              left: hInset,
              child: const _SelectorEdgeLabel(text: 'TENGO'),
            ),
            Positioned(
              top: CalculatorFormTokens.selectorLabelTop,
              right: hInset,
              child: const _SelectorEdgeLabel(text: 'QUIERO'),
            ),
          ],
        );
      },
    );
  }

  Widget _cryptoPill(BuildContext context, {required bool alignEnd}) {
    final label = CurrencySelectionCatalog.displayTitleForCrypto(
      cryptoNotifier.value,
    );
    final asset = CurrencySelectionCatalog.assetPathForCrypto(
      cryptoNotifier.value,
    );
    return _pill(
      context: context,
      label: label,
      assetPath: asset,
      alignEnd: alignEnd,
      onTap: interactionsEnabled ? () => _pickCrypto(context) : null,
    );
  }

  Widget _fiatPill(BuildContext context, {required bool alignEnd}) {
    final label = CurrencySelectionCatalog.displayTitleForFiat(
      fiatNotifier.value,
    );
    final asset = CurrencySelectionCatalog.assetPathForFiat(fiatNotifier.value);
    return _pill(
      context: context,
      label: label,
      assetPath: asset,
      alignEnd: alignEnd,
      onTap: interactionsEnabled ? () => _pickFiat(context) : null,
    );
  }

  Widget _pill({
    required BuildContext context,
    required String label,
    required String assetPath,
    required bool alignEnd,
    required VoidCallback? onTap,
  }) {
    final active = onTap != null;
    final arrowColor = active ? AppColors.textStrong : AppColors.labelGrey;

    final capsule = Radius.circular(CalculatorFormTokens.selectorBorderRadius);
    final splashShape = alignEnd
        ? BorderRadius.only(topRight: capsule, bottomRight: capsule)
        : BorderRadius.only(topLeft: capsule, bottomLeft: capsule);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: splashShape,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: CalculatorFormTokens.selectorMinHeight,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: alignEnd
                  ? CalculatorFormTokens.selectorPillInnerGap
                  : CalculatorFormTokens.selectorHorizontalInset,
              right: alignEnd
                  ? CalculatorFormTokens.selectorHorizontalInset
                  : CalculatorFormTokens.selectorPillInnerGap,
              top: CalculatorFormTokens.selectorPillPadding.top,
              bottom: CalculatorFormTokens.selectorPillPadding.bottom,
            ),
            child: Row(
              mainAxisAlignment: alignEnd
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (alignEnd) const Spacer(),
                Image.asset(
                  assetPath,
                  width: CalculatorFormTokens.selectorIconSize,
                  height: CalculatorFormTokens.selectorIconSize,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: CalculatorFormTokens.selectorLabelFontSize,
                    fontWeight: FontWeight.w600,
                    color: active ? AppColors.textStrong : AppColors.labelGrey,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: arrowColor, size: 22),
                if (!alignEnd) const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Etiqueta sobre el borde del selector: fondo [surface] para interrumpir la línea naranja.
class _SelectorEdgeLabel extends StatelessWidget {
  const _SelectorEdgeLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CalculatorFormTokens.selectorEdgeLabelHorizontalPadding,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textStrong,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SwapOverlapButton extends StatelessWidget {
  const _SwapOverlapButton({required this.enabled, required this.onSwap});

  final bool enabled;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    final d = CalculatorFormTokens.swapButtonDiameter;
    return Material(
      color: AppColors.accent,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onSwap : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: d,
          height: d,
          child: Center(
            child: Icon(
              Icons.swap_horiz,
              color: enabled
                  ? AppColors.onAccent
                  : AppColors.onAccent.withValues(alpha: 0.5),
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
