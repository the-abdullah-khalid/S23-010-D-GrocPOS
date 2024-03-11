import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';

class NoDataMessageWidget extends StatelessWidget {
  const NoDataMessageWidget({
    super.key,
    this.message = "Click to + to add data",
    required this.dataOf,
  });

  final String dataOf;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("assets/images/no_data.webp"),
            height: 200,
            width: 200,
          ),
          Text(
            "No Data Found For $dataOf. $message",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff246bdd),
                letterSpacing: .5,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
