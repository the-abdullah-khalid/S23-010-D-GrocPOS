import 'package:flutter/material.dart';
import 'package:groc_pos_app/resources/app_urls/logos_paths.dart';
import 'package:lottie/lottie.dart';

import '../app_urls/animations_paths.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key? key}) : super(key: key);

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //setup the controller as soon as the screen loads
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose(); //stop the animation on screen switch
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? const Image(image: AssetImage(AppLogosPath.appSplashScreenLogoPath))
        : Lottie.asset(AppAnimationsPaths.appAnimationsPaths,
            controller: _controller, onLoaded: (comp) {
            _controller.duration = comp.duration;
            _controller.forward();
          });
  }
}
