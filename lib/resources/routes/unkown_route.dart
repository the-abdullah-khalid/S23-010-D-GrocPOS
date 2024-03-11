import 'package:flutter/material.dart';

class UnknownRoute extends StatelessWidget {
  const UnknownRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No Route Defined Yet"),
      ),
    );
  }
}
