import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/utils/utils.dart';

import '../../repository/authentication_repository.dart';
import '../../resources/routes/routes_name.dart';

class LoginViewModel extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final roundButtonProgressIndicator = false.obs;
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  toggleRoundedButtonProgressIndication(bool value) {
    roundButtonProgressIndicator.value = value;
  }

  Future<void> handleLogin(
      BuildContext context, String fcmDeviceTokenFromView) async {
    String emailID = emailController.value.text.trim().toString();
    String password = passwordController.value.text.trim().toString();
    String fcmDeviceToken = fcmDeviceTokenFromView;
    toggleRoundedButtonProgressIndication(true);
    try {
      dynamic _response = await _authenticationRepository.loginApi(
          emailID, password, fcmDeviceToken);
      debugPrint(_response.toString());
      toggleRoundedButtonProgressIndication(false);

      Future.delayed(
        Duration.zero,
        () {
          AppUtils.flushBarSucessMessage("Login Success", context);
        },
      );

      Timer(
        const Duration(seconds: 1),
        () {
          Get.offAllNamed(RouteName.dashboardView)!.then((value) {
            emailController.value.dispose();
            passwordController.value.dispose();
          });
        },
      );
    } catch (error) {
      toggleRoundedButtonProgressIndication(false);

      debugPrint('error from login view model');
      debugPrint(error.toString());
      Future.delayed(
        Duration.zero,
        () {
          AppUtils.flushBarErrorMessage(error.toString(), context);
        },
      );
    }
  }
}
