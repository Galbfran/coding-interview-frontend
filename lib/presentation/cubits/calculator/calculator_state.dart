part of 'calculator_cubit.dart';

sealed class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object> get props => [];
}

final class CalculatorInitial extends CalculatorState {
  const CalculatorInitial();
}

final class CalculatorLoading extends CalculatorState {
  const CalculatorLoading();
}

final class CalculatorLoaded extends CalculatorState {
  const CalculatorLoaded({
    required this.rate,
    required this.convertedAmount,
  });

  /// Tasa fiatToCryptoExchangeRate devuelta por el API.
  final double rate;

  /// Monto convertido ya calculado (crypto*rate o fiat/rate).
  final double convertedAmount;

  @override
  List<Object> get props => [rate, convertedAmount];
}

final class CalculatorError extends CalculatorState {
  const CalculatorError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
