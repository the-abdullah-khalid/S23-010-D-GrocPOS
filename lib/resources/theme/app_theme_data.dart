import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class AppThemeData {
  static final appThemeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: CustomAppColors.mainThemeColorBlueLogo,
    ),
  );
}
