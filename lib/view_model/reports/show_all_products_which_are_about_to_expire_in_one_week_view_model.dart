import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/view_model/reports/reports_main_view_model.dart';
import 'package:intl/intl.dart';

class ShowAllProductWhichAreAboutToExpireInOneWeekViewModel
    extends GetxController {
  final reportsMainViewModelController = Get.find<ReportsMainViewModel>();
  final todayDate = DateTime.now().obs;
  final productsExpiringInAWeekList = <ProductModel>[].obs;

  findProductsExpiringWithin7Days() {
    for (ProductModel product
        in reportsMainViewModelController.allProductsList.value) {
      DateTime expirationDate =
          DateFormat('MM/dd/yyyy').parse(product.productExpiryDate);
      debugPrint("expirationDate - ${expirationDate}");

      // Calculate the difference in days between today and the expiration date
      int daysUntilExpiry = expirationDate.difference(todayDate.value).inDays;

      // Check if the product will expire within the next 7 days
      if (daysUntilExpiry > 0 && daysUntilExpiry <= 7) {
        // Add the product to the list of products expiring within 7 days
        productsExpiringInAWeekList.add(product);
      }
    }
  }
}
