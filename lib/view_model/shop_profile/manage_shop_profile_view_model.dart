import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repository/shop_repository.dart';
import '../../utils/utils.dart';

class ManageShopProfileViewModel extends GetxController {
  final buttonStatus = false.obs;
  final ShopRepository _shopRepository = ShopRepository();

  setButtonStatus(bool status) {
    buttonStatus.value = status;
  }

  Future<void> updateUserProfileDetails(
      Map<String, dynamic> updatedProfileData, BuildContext context) async {
    setButtonStatus(true);

    try {
      dynamic response =
          await _shopRepository.updateShopDetails(updatedProfileData);
      debugPrint(response);
      setButtonStatus(false);

      Future.delayed(
        Duration.zero,
        () => AppUtils.flushBarSucessMessage("Update Sucessfull", context),
      );
    } catch (error) {
      debugPrint(error.toString());
      Future.delayed(
        Duration.zero,
        () => AppUtils.flushBarErrorMessage(error.toString(), context),
      );
      setButtonStatus(true);
    }
  }
}
