import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';

class PurchaseStatusTrueWidget extends StatefulWidget {
  const PurchaseStatusTrueWidget({super.key});

  @override
  State<PurchaseStatusTrueWidget> createState() =>
      _PurchaseStatusTrueWidgetState();
}

class _PurchaseStatusTrueWidgetState extends State<PurchaseStatusTrueWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Payment for this purchase is already done\n\nThank You",
              textAlign: TextAlign.center,
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
          ),
        ),
      ],
    );
    ;
  }
}
