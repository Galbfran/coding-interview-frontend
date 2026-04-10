import 'package:conversion_calculator/core/network/dio_client.dart';
import 'package:conversion_calculator/core/utils/env.dart';
import 'package:conversion_calculator/data/datasources/recommendations_remote_datasource.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/data/repositories/conversion_repository_impl.dart';
import 'package:conversion_calculator/presentation/cubits/calculator/calculator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalculatorCubit(
        repository: ConversionRepositoryImpl(
          dataSource: RecommendationsRemoteDataSource(
            client: DioClient(baseUrl: Env.baseUrl),
          ),
        ),
      )..calculate(dto: CalculatorDto.mock()),
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
              CalculatorLoaded(:final rate, :final convertedAmount) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tasa: $rate', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        'Recibirás: ${convertedAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              CalculatorError(:final message) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    message,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
            };
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CalculatorCubit>().calculate(dto: CalculatorDto.mock()),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
