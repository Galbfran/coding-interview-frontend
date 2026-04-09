part of 'calculator_cubit.dart';

sealed class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object> get props => [];
}

final class CalculatorInitial extends CalculatorState {
  const CalculatorInitial();
  @override
  List<Object> get props => [];
}

final class CalculatorLoading extends CalculatorState {
  const CalculatorLoading();
  @override
  List<Object> get props => [];
}

final class CalculatorLoaded extends CalculatorState {
  const CalculatorLoaded({required this.jsonPreview});

  final String jsonPreview;

  @override
  List<Object> get props => [jsonPreview];
}

final class CalculatorError extends CalculatorState {
  const CalculatorError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
