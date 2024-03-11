import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../resources/colors/app_colors.dart';

class AppUtils {
  // to shift the focus of text input field on taping the next/done
  static void fieldFocusChange(
      BuildContext context, FocusNode currentNode, FocusNode nextFocusNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  static toastMessage(dynamic message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.orange,
        textColor: Colors.grey,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 30);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        borderRadius: BorderRadius.circular(20),
        backgroundColor: CustomAppColors.errorColor,
        flushbarPosition: FlushbarPosition.BOTTOM,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: const Duration(seconds: 5),
        positionOffset: 20,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
          size: 28,
        ),
      )..show(context),
    );
  }

  static void flushBarSucessMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        borderRadius: BorderRadius.circular(20),
        backgroundColor: CustomAppColors.successColor,
        flushbarPosition: FlushbarPosition.BOTTOM,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: const Duration(seconds: 5),
        positionOffset: 20,
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 28,
        ),
      )..show(context),
    );
  }

  static snakBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static errorDialog(BuildContext context, String title, String description) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    )..show();
  }

  static sucessDialog(BuildContext context, String title, String description) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    )..show();
  }

  static checkoutBeepSound() {
    final player = AudioPlayer();
    player.play(AssetSource('audio/scanner_aduio.wav'));
  }

  static snakBarSucessGetX(
      String title, String description, int durationToStayOnScreen) {
    return Get.snackbar(
      title,
      description,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
        size: 28,
      ),
      padding: const EdgeInsets.all(15),
      borderRadius: 20,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: durationToStayOnScreen),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeInOut,
    );
  }

  static snakBarErrorGetX(
      String title, String description, int durationToStayOnScreen) {
    return Get.snackbar(
      title,
      description,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
        size: 28,
      ),
      padding: const EdgeInsets.all(15),
      borderRadius: 20,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: durationToStayOnScreen),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeInOut,
    );
  }
}
