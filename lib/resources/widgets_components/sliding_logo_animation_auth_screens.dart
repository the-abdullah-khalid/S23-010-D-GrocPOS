import 'package:flutter/material.dart';

import 'animated_log_groc_pos_splash_screen.dart';

class SlidingLogoAnimationAuthScreens extends StatelessWidget {
  final double height;
  final double width;
  const SlidingLogoAnimationAuthScreens({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: const AnimatedLogo(),
      ),
    );
  }
}
