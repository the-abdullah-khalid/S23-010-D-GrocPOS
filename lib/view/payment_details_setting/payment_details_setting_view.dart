import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';

import '../../resources/fonts/app_fonts_names.dart';
import '../../resources/widgets_components/rounded_button.dart';

class PaymentDetailsSettingView extends StatefulWidget {
  const PaymentDetailsSettingView({super.key});

  @override
  State<PaymentDetailsSettingView> createState() =>
      _PaymentDetailsSettingViewState();
}

class _PaymentDetailsSettingViewState extends State<PaymentDetailsSettingView> {
  _uploadJazzCashDetails() {
    Get.toNamed(RouteName.jazzCashUploadDetails);
  }

  _uploadEasyPiasaDetails() {
    Get.toNamed(RouteName.easyPisaUploadDetails);
  }

  _showEasyPisaDetails() {
    Get.toNamed(RouteName.easyPisaShowDetails);
  }

  _showJazzCashDetails() {
    Get.toNamed(RouteName.jazzCashShowDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Groc-POS All Products",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Payment Details Settings",
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff246bdd),
                  letterSpacing: .5,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        height: 125,
                        child: Image(
                          image: AssetImage(
                            "assets/logos/easy-pisa.png",
                          ),
                        ),
                      ),
                      const Text("Easy Paisa Payment Settings"),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundButton(
                        onTap: () {
                          _uploadEasyPiasaDetails();
                        },
                        title: "Upload Details",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundButton(
                        onTap: () {
                          _showEasyPisaDetails();
                        },
                        title: "Show Details",
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        height: 125,
                        child: Image(
                          image: AssetImage(
                            "assets/logos/jazz-cash-logo.png",
                          ),
                        ),
                      ),
                      const Text("Jazz Cash Payment Settings"),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundButton(
                        onTap: () {
                          _uploadJazzCashDetails();
                        },
                        title: "Upload Details",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundButton(
                        onTap: () {
                          _showJazzCashDetails();
                        },
                        title: "Show Details",
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
