
import 'package:conversion_calculator/presentation/page/calculator_page.dart';
import 'package:conversion_calculator/presentation/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PathRoutes{
  static const String splashRoute = '/';
  static const String calculatorRoute = '/calculator';
}



final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: PathRoutes.splashRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: PathRoutes.calculatorRoute,
          builder: (BuildContext context, GoRouterState state) {
            return const CalculatorPage();
          },
        ),
      ],
    ),
  ],
);