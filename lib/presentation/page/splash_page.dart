import 'package:conversion_calculator/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Splash Screen'),
            ElevatedButton(
              onPressed: () {
                context.go(PathRoutes.calculator);
              },
              child: Text('Go to Calculator'),
            ),
          ],
        ),
      ),
    );
  }
}