import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/presentation/cubits/calculator/calculator_cubit.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_error.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_initial.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_loaded.dart';
import 'package:conversion_calculator/presentation/widget/calculator/calculator_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorBody extends StatelessWidget {
  const CalculatorBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        children: [
          BlocBuilder<CalculatorCubit, CalculatorState>(
            builder: (context, state) {
              return switch (state) {
                CalculatorInitial() => const CalculatorInitialContent(),
                CalculatorLoading() => const CalculatorLoadingContent(),
                CalculatorLoaded(:final rate, :final convertedAmount) =>
                  CalculatorLoadedContent(
                    rate: rate,
                    convertedAmount: convertedAmount,
                  ),
                CalculatorError(:final message) => CalculatorErrorContent(
                  message: message,
                ),
              };
            },
          ),
          ElevatedButton(
            onPressed: () => context.read<CalculatorCubit>().calculate(
              dto: CalculatorDto.mock(),
            ),
            child: const Text('Calculate'),
          ),
        ],
      ),
    );
  }
}
