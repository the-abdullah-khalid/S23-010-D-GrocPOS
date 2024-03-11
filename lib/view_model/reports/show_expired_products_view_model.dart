import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/view_model/reports/reports_main_view_model.dart';
import 'package:intl/intl.dart';

class ShowExpiredProductsViewModel extends GetxController {
  final reportsMainViewModelController = Get.find<ReportsMainViewModel>();
  final todayDate = DateTime.now().obs;
  final expiredProductsList = <ProductModel>[].obs;

  findAllExpiredProducts() {
    for (ProductModel product
        in reportsMainViewModelController.allProductsList.value) {
      DateTime expirationDate =
          DateFormat('MM/dd/yyyy').parse(product.productExpiryDate);
      debugPrint("expirationDate - ${expirationDate}");

      bool isExpired = todayDate.value.isAfter(expirationDate);
      if (isExpired) {
        expiredProductsList.add(product);
      }
    }
  }
}
