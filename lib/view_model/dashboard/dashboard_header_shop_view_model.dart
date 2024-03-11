import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/utils/utils.dart';

import '../../models/shop_model.dart';
import '../../repository/shop_repository.dart';

class DashboardHeaderShopViewModel extends GetxController {
  final ShopRepository _shopRepository = ShopRepository();

  Rx<ShopModel> shopModel = ShopModel(
    shopAddress: "loading",
    shopId: "loading",
    shopName: "loading",
    shopOwnerEmail: "loading",
    shopOwnerPhone: "loading",
    shopOwnerName: "loading",
    shopProfileImageUrl: "loading",
  ).obs;

  setShopModel(ShopModel fetchedShopModel) {
    shopModel.value = fetchedShopModel;
  }

  Future<void> fetchShopDetails(BuildContext context) async {
    try {
      debugPrint('fetch called');
      ShopModel responseShopModel = await _shopRepository.fetchShopDetails();
      if (responseShopModel != null) {
        setShopModel(responseShopModel);
      }
    } catch (error) {
      debugPrint(error.toString());
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarErrorMessage(error.toString(), context);
      });
    }
  }
}
