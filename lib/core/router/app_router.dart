
import 'package:conversion_calculator/presentation/page/calculator_page.dart';
import 'package:conversion_calculator/presentation/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PathRoutes {
  static const String splash = '/';
  static const String calculator = '/calculator';
}

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: PathRoutes.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'calculator',
          builder: (BuildContext context, GoRouterState state) {
            return const CalculatorPage();
          },
        ),
      ],
    ),
  ],
);