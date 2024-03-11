import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/invoice_model.dart';
import 'package:groc_pos_app/models/product_model.dart';

import 'reports_main_view_model.dart';

class ShowBestSellingProductsViewModel extends GetxController {
  final reportsMainViewModelController = Get.find<ReportsMainViewModel>();
  final bestSellingProductsList = <Map<String, dynamic>>[].obs;

  findBestSellingProducts() {
    for (ProductModel productInInventory
        in reportsMainViewModelController.allProductsList.value) {
      int numberOfOccurances = 0;
      for (InvoiceModel invoice
          in reportsMainViewModelController.allInvoicesList.value) {
        for (ProductModel productInInvoice in invoice.productList) {
          if (productInInventory.productId
                  .compareTo(productInInvoice.productId) ==
              0) {
            numberOfOccurances++;
          }
        }
      }
      Map<String, dynamic> bestSellingProductData = {
        'product_details': productInInventory,
        'number_of_occurances_in_recipts': numberOfOccurances,
      };

      bestSellingProductsList.add(bestSellingProductData);
    }

    debugPrint(
        "bestSellingProductData - ${bestSellingProductsList.toString()}");

    bestSellingProductsList.sort((a, b) => b['number_of_occurances_in_recipts']
        .compareTo(a['number_of_occurances_in_recipts']));

    debugPrint(
        "bestSellingProductData - ${bestSellingProductsList[0]['number_of_occurances_in_recipts'].toString()}");
  }
}
