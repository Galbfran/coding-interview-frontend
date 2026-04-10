import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:conversion_calculator/data/model/enum/change_type.dart';
import 'package:conversion_calculator/data/model/enum/crypto_currency_id.dart';
import 'package:conversion_calculator/data/model/enum/fiat_currency_id.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/presentation/cubits/calculator/calculator_cubit.dart';
import 'package:conversion_calculator/presentation/widget/calculator/currency_selection/currency_selection_catalog.dart';
import 'package:conversion_calculator/presentation/widget/calculator/form/calculator_amount_field.dart';
import 'package:conversion_calculator/presentation/widget/calculator/form/calculator_currency_header.dart';
import 'package:conversion_calculator/presentation/widget/calculator/form/calculator_exchange_button.dart';
import 'package:conversion_calculator/presentation/widget/calculator/form/calculator_summary_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CalculatorCard extends StatefulWidget {
  const CalculatorCard({super.key});

  @override
  State<CalculatorCard> createState() => _CalculatorCardState();
}

class _CalculatorCardState extends State<CalculatorCard> {
  late final TextEditingController _amountController;
  late final ValueNotifier<CryptoCurrencyId> _cryptoNotifier;
  late final ValueNotifier<FiatCurrencyId> _fiatNotifier;
  late final ValueNotifier<bool> _tengoIsCryptoNotifier;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '5.00');
    _cryptoNotifier = ValueNotifier(CryptoCurrencyId.tatumTronUsdt);
    _fiatNotifier = ValueNotifier(FiatCurrencyId.ves);
    _tengoIsCryptoNotifier = ValueNotifier(true);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _cryptoNotifier.dispose();
    _fiatNotifier.dispose();
    _tengoIsCryptoNotifier.dispose();
    super.dispose();
  }

  /// Arma el DTO solo al enviar (lee notifiers + texto del monto).
  CalculatorDto? buildDto() {
    final raw = _amountController.text.trim().replaceAll(',', '.');
    final amount = double.tryParse(raw);
    if (amount == null || amount <= 0) return null;

    final crypto = _cryptoNotifier.value;
    final fiat = _fiatNotifier.value;
    final tengoCrypto = _tengoIsCryptoNotifier.value;

    // Mismo criterio que `CalculatorDto.mock()` (100.0): el API fallaba con otros ids.
    const amountCurrencyId = 100.0;

    return CalculatorDto(
      changeType: tengoCrypto
          ? ChangeType.cryptoToFiat
          : ChangeType.fiatToCrypto,
      cryptoCurrencyId: crypto,
      fiatCurrencyId: fiat,
      amount: amount,
      amountCurrencyId: amountCurrencyId,
    );
  }

  String _amountCurrencyPrefix() {
    return _tengoIsCryptoNotifier.value
        ? CurrencySelectionCatalog.displayTitleForCrypto(_cryptoNotifier.value)
        : CurrencySelectionCatalog.displayTitleForFiat(_fiatNotifier.value);
  }

  String _receiveCurrencySuffix() {
    return _tengoIsCryptoNotifier.value
        ? _fiatNotifier.value.asApiId
        : CurrencySelectionCatalog.displayTitleForCrypto(_cryptoNotifier.value);
  }

  String _rateCurrencySuffix() => _fiatNotifier.value.asApiId;

  /// Miles con punto y decimales con coma (`1.000,00`), alineado a `es_AR`.
  String _formatAmountEsAr(double value) =>
      NumberFormat('#,##0.00', 'es_AR').format(value);

  void _onCambiar(BuildContext context) {
    final dto = buildDto();
    if (dto == null) {
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(const SnackBar(content: Text('Ingresá un monto válido')));
      return;
    }
    context.read<CalculatorCubit>().calculate(dto: dto);
  }

  /// Tras invertir TENGO/QUIERO, el tipo de cambio y el resultado cambian: si ya
  /// se había calculado antes, relanzamos la petición con el DTO actual.
  void _recalculateAfterSwapIfNeeded(BuildContext context) {
    final cubit = context.read<CalculatorCubit>();
    if (cubit.state is CalculatorInitial) return;
    final dto = buildDto();
    if (dto == null) return;
    cubit.calculate(dto: dto);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 12,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<CalculatorCubit, CalculatorState>(
          buildWhen: (prev, next) => prev != next,
          builder: (context, state) {
            final loading = state is CalculatorLoading;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CalculatorCurrencyHeader(
                  cryptoNotifier: _cryptoNotifier,
                  fiatNotifier: _fiatNotifier,
                  tengoIsCryptoNotifier: _tengoIsCryptoNotifier,
                  interactionsEnabled: !loading,
                  onSwap: () {
                    _tengoIsCryptoNotifier.value =
                        !_tengoIsCryptoNotifier.value;
                    _recalculateAfterSwapIfNeeded(context);
                  },
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _cryptoNotifier,
                    _fiatNotifier,
                    _tengoIsCryptoNotifier,
                  ]),
                  builder: (context, _) => CalculatorAmountField(
                    controller: _amountController,
                    currencyPrefix: _amountCurrencyPrefix(),
                    enabled: !loading,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSummary(context, state),
                const SizedBox(height: 20),
                CalculatorExchangeButton(
                  onPressed: loading ? null : () => _onCambiar(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static const String _noConversionValue = 'Sin conversión';

  /// Altura reservada bajo las filas para el detalle de error (vacío en otros estados).
  /// Evita que la card crezca o encoja al pasar de error ↔ éxito.
  static const double _summaryDetailSlotHeight = 52;

  Widget _buildSummary(BuildContext context, CalculatorState state) {
    final errorColor = Theme.of(context).colorScheme.error;
    final detail = switch (state) {
      CalculatorError(:final message) => message,
      _ => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._summaryRows(context, state, errorColor),
        SizedBox(
          height: _summaryDetailSlotHeight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: detail == null
                ? const SizedBox.shrink()
                : Text(
                    detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.25,
                      color: errorColor.withValues(alpha: 0.85),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  List<Widget> _summaryRows(
    BuildContext context,
    CalculatorState state,
    Color errorColor,
  ) {
    return switch (state) {
      CalculatorInitial() => const [
        CalculatorSummaryRow(title: 'Tasa estimada', value: '—'),
        CalculatorSummaryRow(title: 'Recibirás', value: '—'),
        CalculatorSummaryRow(title: 'Tiempo estimado', value: '—'),
      ],
      CalculatorLoading() => const [
        CalculatorSummaryRow(
          title: 'Tasa estimada',
          value: 'Cargando…',
          valueColor: AppColors.labelGrey,
          valueFontStyle: FontStyle.italic,
        ),
        CalculatorSummaryRow(
          title: 'Recibirás',
          value: 'Cargando…',
          valueColor: AppColors.labelGrey,
          valueFontStyle: FontStyle.italic,
        ),
        CalculatorSummaryRow(
          title: 'Tiempo estimado',
          value: 'Cargando…',
          valueColor: AppColors.labelGrey,
          valueFontStyle: FontStyle.italic,
        ),
      ],
      CalculatorLoaded(:final rate, :final convertedAmount) => [
        CalculatorSummaryRow(
          title: 'Tasa estimada',
          value: '\u2248 ${_formatAmountEsAr(rate)} ${_rateCurrencySuffix()}',
        ),
        CalculatorSummaryRow(
          title: 'Recibirás',
          value:
              '\u2248 ${_formatAmountEsAr(convertedAmount)} ${_receiveCurrencySuffix()}',
        ),
        const CalculatorSummaryRow(
          title: 'Tiempo estimado',
          value: '\u2248 10 Min',
        ),
      ],
      CalculatorError() => [
        CalculatorSummaryRow(
          title: 'Tasa estimada',
          value: _noConversionValue,
          valueColor: errorColor,
          valueMaxLines: 1,
        ),
        CalculatorSummaryRow(
          title: 'Recibirás',
          value: _noConversionValue,
          valueColor: errorColor,
          valueMaxLines: 1,
        ),
        const CalculatorSummaryRow(title: 'Tiempo estimado', value: '—'),
      ],
    };
  }
}
