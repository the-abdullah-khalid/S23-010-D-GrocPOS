import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/repository/authentication_repository.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/utils/utils.dart';

class MainDashBoardViewModel {
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  void logoutUser(BuildContext context) {
    try {
      _authenticationRepository.logoutApi();
      AppUtils.flushBarSucessMessage("Log-Out Success", context);

      Timer(const Duration(seconds: 1), () {
        Get.offAllNamed(RouteName.loginView)!.then((value) =>
            AppUtils.flushBarSucessMessage("Log-Out Success", context));
      });
    } catch (error) {
      debugPrint(error.toString());
      AppUtils.flushBarErrorMessage(error.toString(), context);
    }
  }
}
