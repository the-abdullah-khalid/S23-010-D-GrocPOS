import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repository/authentication_repository.dart';
import '../../resources/routes/routes_name.dart';
import '../../utils/utils.dart';

class SignUpViewModel extends GetxController {
  final roundedButtonLoadingStatus = false.obs;
  AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  void setRoundedButtonsStatus(bool status) {
    roundedButtonLoadingStatus.value = status;
  }

  //--------------------- signup functionality ---------------------------------
  Future<void> signupNewUser(
      Map<String, dynamic> userSignUpData, BuildContext context) async {
    setRoundedButtonsStatus(true);
    try {
      await authenticationRepository.signupApi(userSignUpData);
      debugPrint("Register User Successes");
      setRoundedButtonsStatus(false);
      Future.delayed(const Duration(seconds: 1), () {
        AppUtils.flushBarSucessMessage("Sign-Up Success", context);
      });
      //move to the main dash board
      // Navigator.pushNamed(context, RouteName.mainDashBoard);

      // Navigator.pushNamed(context, RouteName.mainDashBoard);
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage("Sign up Success", context);
      });

      Timer(const Duration(seconds: 1), () {
        Get.offAllNamed(RouteName.dashboardView)!.then(
          (value) {
            Get.delete<SignUpViewModel>();
          },
        );
      });
    } catch (error) {
      if (kDebugMode) {
        print("Register User Failed");
        print(error.toString());
      }
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarErrorMessage(error.toString(), context);
      });
      setRoundedButtonsStatus(false);
      return;
    }
  }
}
