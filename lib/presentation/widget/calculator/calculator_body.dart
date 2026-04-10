import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/presentation/cubits/calculator/calculator_cubit.dart';
import 'package:conversion_calculator/presentation/widget/calculator/state/calculator_error.dart';
import 'package:conversion_calculator/presentation/widget/calculator/state/calculator_initial.dart';
import 'package:conversion_calculator/presentation/widget/calculator/state/calculator_loaded.dart';
import 'package:conversion_calculator/presentation/widget/calculator/state/calculator_loading.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorBody extends StatelessWidget {
  const CalculatorBody({super.key});

  static const double _cardMaxWidth = 420;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(child: CalculatorScreenBackground()),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
              child: Material(
                color: Colors.white,
                elevation: 10,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(24),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 140),
                        child: Center(
                          child: BlocBuilder<CalculatorCubit, CalculatorState>(
                            builder: (context, state) {
                              return switch (state) {
                                CalculatorInitial() =>
                                  const CalculatorInitialContent(),
                                CalculatorLoading() =>
                                  const CalculatorLoadingContent(),
                                CalculatorLoaded(
                                  :final rate,
                                  :final convertedAmount,
                                ) =>
                                  CalculatorLoadedContent(
                                    rate: rate,
                                    convertedAmount: convertedAmount,
                                  ),
                                CalculatorError(:final message) =>
                                  CalculatorErrorContent(message: message),
                              };
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => context
                            .read<CalculatorCubit>()
                            .calculate(dto: CalculatorDto.mock()),
                        child: const Text('Calculate'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
