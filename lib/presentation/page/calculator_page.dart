import 'package:conversion_calculator/core/network/dio_client.dart';
import 'package:conversion_calculator/core/utils/env.dart';
import 'package:conversion_calculator/presentation/bloc/calculator/cubit/calculator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalculatorCubit(dioClient: DioClient(baseUrl: Env.baseUrl))..getRecommendations(),
      child: const _CalculatorView(),
    );
  }
}

class _CalculatorView extends StatelessWidget {
  const _CalculatorView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: BlocBuilder<CalculatorCubit, CalculatorState>(
          builder: (context, state) {
            return switch (state) {
              CalculatorInitial() => const SizedBox.shrink(),
              CalculatorLoading() => const Center(child: CircularProgressIndicator()),
              CalculatorLoaded(:final jsonPreview) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(jsonPreview, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                ),
              CalculatorError(:final message) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
            };
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CalculatorCubit>().getRecommendations(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
