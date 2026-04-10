import 'package:conversion_calculator/core/theme/app_colors.dart';
import 'package:conversion_calculator/data/model/enum/change_type.dart';
import 'package:conversion_calculator/data/model/enum/crypto_currency_id.dart';
import 'package:conversion_calculator/data/model/enum/fiat_currency_id.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/presentation/cubits/calculator/calculator_cubit.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_amount_field.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_currency_header.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_exchange_button.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_summary_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      changeType:
          tengoCrypto ? ChangeType.cryptoToFiat : ChangeType.fiatToCrypto,
      cryptoCurrencyId: crypto,
      fiatCurrencyId: fiat,
      amount: amount,
      amountCurrencyId: amountCurrencyId,
    );
  }

  String _receiveCurrencySuffix() {
    return _tengoIsCryptoNotifier.value
        ? _fiatNotifier.value.asApiId
        : 'USDT';
  }

  String _rateCurrencySuffix() => _fiatNotifier.value.asApiId;

  void _onCambiar(BuildContext context) {
    final dto = buildDto();
    if (dto == null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Ingresá un monto válido')),
      );
      return;
    }
    context.read<CalculatorCubit>().calculate(dto: dto);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 10,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CalculatorCurrencyHeader(
              cryptoNotifier: _cryptoNotifier,
              fiatNotifier: _fiatNotifier,
              tengoIsCryptoNotifier: _tengoIsCryptoNotifier,
              onSwap: () {
                _tengoIsCryptoNotifier.value = !_tengoIsCryptoNotifier.value;
              },
            ),
            const SizedBox(height: 16),
            CalculatorAmountField(controller: _amountController),
            const SizedBox(height: 20),
            BlocBuilder<CalculatorCubit, CalculatorState>(
              buildWhen: (prev, next) => prev != next,
              builder: (context, state) => _buildSummary(context, state),
            ),
            const SizedBox(height: 20),
            CalculatorExchangeButton(
              onPressed: () => _onCambiar(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CalculatorState state) {
    return switch (state) {
      CalculatorInitial() => const Column(
          children: [
            CalculatorSummaryRow(title: 'Tasa estimada', value: '—'),
            CalculatorSummaryRow(title: 'Recibirás', value: '—'),
            CalculatorSummaryRow(title: 'Tiempo estimado', value: '—'),
          ],
        ),
      CalculatorLoading() => const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        ),
      CalculatorLoaded(:final rate, :final convertedAmount) => Column(
          children: [
            CalculatorSummaryRow(
              title: 'Tasa estimada',
              value:
                  '\u2248 ${rate.toStringAsFixed(2)} ${_rateCurrencySuffix()}',
            ),
            CalculatorSummaryRow(
              title: 'Recibirás',
              value:
                  '\u2248 ${convertedAmount.toStringAsFixed(2)} ${_receiveCurrencySuffix()}',
            ),
            const CalculatorSummaryRow(
              title: 'Tiempo estimado',
              value: '\u2248 10 Min',
            ),
          ],
        ),
      CalculatorError(:final message) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ),
    };
  }
}
