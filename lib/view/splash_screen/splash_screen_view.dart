import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/notification_services/notification_services.dart';
import 'package:groc_pos_app/view_model/splash_screen_services/splash_screen_view_model.dart';

import '../../resources/fonts/app_fonts_names.dart';
import '../../resources/widgets_components/animated_log_groc_pos_splash_screen.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final splashScreenController = Get.put(SplashScreenViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    splashScreenController.checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 600,
              height: 300,
              child: Center(
                child: AnimatedLogo(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'GROC-POS APP',
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff246bdd),
                  letterSpacing: .5,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'A Mobile Application based Vision Powered\n POS for Retail Stores',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(
              () {
                return splashScreenController.internetConnectionStatus.value
                    ? const Column(
                        children: [
                          Icon(Icons.done),
                          Text("Internet Connected"),
                        ],
                      )
                    : const Column(
                        children: [
                          CircularProgressIndicator(),
                          Text("Checking Internet Connection Status")
                        ],
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
