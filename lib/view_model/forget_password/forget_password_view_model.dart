import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/utils/utils.dart';

import '../../repository/authentication_repository.dart';

class ForgetPasswordViewModel extends GetxController {
  final roundedButtonLoadingStatus = false.obs;
  final emailController = TextEditingController().obs;
  final _authenticationRepository = AuthenticationRepository();

  setRoundedButtonLoadingStatus(bool status) {
    roundedButtonLoadingStatus.value = status;
  }

  performForgetPassword(BuildContext context, dynamic userData) {
    if (emailController.value.text.isEmpty ||
        emailController.value.text == null) {
      AppUtils.flushBarErrorMessage(
          "Please enter a valid email to get the reset link", context);
      return;
    } else {
      _forgetPassword(userData, context);
    }
  }

  Future<void> _forgetPassword(dynamic userData, BuildContext context) async {
    setRoundedButtonLoadingStatus(true);
    _authenticationRepository.forgetPasswordApi(userData).then((value) {
      setRoundedButtonLoadingStatus(false);
      AppUtils.flushBarSucessMessage(
          "Forget Password Link Sending Success", context);

      AppUtils.sucessDialog(context, 'Forget Password',
          'We have sent a password reset link on your email you entered');
    }).onError((error, stackTrace) {
      setRoundedButtonLoadingStatus(false);
      debugPrint(error.toString());
      AppUtils.flushBarErrorMessage(error.toString(), context);
      AppUtils.errorDialog(context, "Incorrect Email Given",
          'Kindly give the correct and working email id');
    });
  }
}
