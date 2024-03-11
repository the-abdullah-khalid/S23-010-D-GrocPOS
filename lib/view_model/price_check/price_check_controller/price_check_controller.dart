import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/view_model/price_check/price_check_main_view_model.dart';

class ScannedProductsPriceCheckController extends GetxController {
  final allScannedProductsList = <ProductModel>[].obs;
  final checkOutViewModelController = Get.find<PriceCheckMainViewModel>();

  final discountFieldController = TextEditingController().obs;
  final amountPaidByCustomerController = TextEditingController().obs;
  Rx<String> paymentMethod = 'Cash Payment'.obs;

  checkPrice(ProductModel scannedProduct) {
    debugPrint("I am called - ${scannedProduct}");

    bool isAlreadyScanned = false;
    for (ProductModel alreadyScannedProduct in allScannedProductsList.value) {
      if (alreadyScannedProduct.productBarcode
              .compareTo(scannedProduct.productBarcode) ==
          0) {
        isAlreadyScanned = true;
      }
    }
    if (!isAlreadyScanned) {
      allScannedProductsList.add(scannedProduct);
      debugPrint("new product added - ${scannedProduct.toString()}");
      Get.snackbar("New Product Added In the Cart", scannedProduct.productName);
    }
    return false;
  }

  clearScannedItemsFromCart() {
    allScannedProductsList.clear();
    Get.snackbar(
        "Reset Scanned Products", "All Previous scanned are discarded now");
  }

  removeScannedProductFromCart(ProductModel productToBeRemoved, int indexAt) {
    allScannedProductsList.removeAt(indexAt);
    Get.snackbar("Product Removed From the Cart", "");
  }

  decreaseProductCartQuantity(int index) {
    ProductModel scannedProductModel = allScannedProductsList[index];
    scannedProductModel.productQuantityInCart--;
    allScannedProductsList[index] = scannedProductModel;
  }

  increaseProductCartQuantity(int index) {
    ProductModel scannedProductModel = allScannedProductsList[index];
    scannedProductModel.productQuantityInCart++;
    allScannedProductsList[index] = scannedProductModel;
  }

  resetTheProductQuantitiesInCart() {
    List<ProductModel> restProductsList = [];
    for (ProductModel restProduct in allScannedProductsList) {
      restProduct.productQuantityInCart = 1;
    }
  }
}
