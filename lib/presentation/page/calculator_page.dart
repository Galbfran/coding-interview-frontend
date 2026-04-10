import 'package:conversion_calculator/core/network/dio_client.dart';
import 'package:conversion_calculator/core/utils/env.dart';
import 'package:conversion_calculator/data/datasources/recommendations_remote_datasource.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:conversion_calculator/data/repositories/conversion_repository_impl.dart';
import 'package:conversion_calculator/presentation/cubits/calculator/calculator_cubit.dart';
import 'package:conversion_calculator/presentation/widget/app_bar.dart';
import 'package:conversion_calculator/presentation/widget/calculator_body.dart';
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
      child: const CalculatorView(),
    );
  }
}

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarWidget(),
      ),
      body: const CalculatorBody(),
    );
  }
}
