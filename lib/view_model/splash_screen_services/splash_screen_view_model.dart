import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/view/splash_screen/splash_screen_view.dart';

import '../../repository/authentication_repository.dart';
import '../../resources/routes/routes_name.dart';

class SplashScreenViewModel extends GetxController {
  RxBool internetConnectionStatus = false.obs;
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  // check Internet Connection on the splash screen
  void checkInternetConnection() async {
    debugPrint(" init splash- ${1}");

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('connected');
        }
        internetConnectionStatus.value = true;
        isLogin();
      } else {
        internetConnectionStatus.value = false;
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('not connected');
      }
      internetConnectionStatus.value = false;
    }
  }

  //check the current user login session
  Future<void> isLogin() async {
    final currentLoggedInUser = _authenticationRepository.checkUserSession();

    if (currentLoggedInUser != null) {
      //if there is a already logged in user then navigate to the main dash board screen
      // after three second move the screen to world stats
      // debugPrint(currentLoggedInUser.toString());
      Timer(
        const Duration(seconds: 5),
        () {
          // now go to the dashboard screen and also remove all the previous screens
          Get.offAllNamed(RouteName.dashboardView);
        },
      );
    } else {
      //if there is no user already logged in the system then navigate to the login screen
      // after three second move the screen to world stats
      Timer(
        const Duration(seconds: 5),
        () {
          // go the the login screen  and also remove all the previous screens
          Get.offAllNamed(RouteName.loginView);
        },
      );
    }
  }
}
