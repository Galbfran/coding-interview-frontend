import 'package:conversion_calculator/presentation/widget/splash/splash_body.dart';
import 'package:conversion_calculator/presentation/widget/splash/splash_scaffold.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScaffold(
      body: SplashBody(),
    );
  }
}
