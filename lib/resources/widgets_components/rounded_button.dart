import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  bool loading;

  RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: CustomAppColors.mainThemeColorBlueLogo,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: GoogleFonts.getFont(
                    AppFontsNames.kBodyFont,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
