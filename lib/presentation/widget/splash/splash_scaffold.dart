import 'package:flutter/material.dart';

class SplashScaffold extends StatelessWidget {
  const SplashScaffold({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body);
  }
}
