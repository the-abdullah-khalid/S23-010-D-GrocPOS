import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';

class ScannedProductsController extends GetxController {
  final allScannedProductsList = <ProductModel>[
    // ProductModel(
    //     productBarcode: "620514018256",
    //     productBrand: "national",
    //     productCategory: "Other",
    //     productId: "620514018256:national ketchup",
    //     productManufactureName: "national",
    //     productMrp: 90.0,
    //     productPurchasePrice: 50.0,
    //     productName: "national ketchup",
    //     productStock: 30,
    //     productUnit: "Packets (Pac)",
    //     productExpiryDate: "10/31/2023")
  ].obs;
  final checkOutViewModelController = Get.find<MainCheckOutViewModel>();
  final subTotal = 0.0.obs;
  final discountAmount = 0.0.obs;
  final grandTotal = 0.0.obs;
  final amountPaidCustomer = 0.0.obs;
  final changeForCustomer = 0.0.obs;

  final discountFieldController = TextEditingController().obs;
  final amountPaidByCustomerController = TextEditingController().obs;
  Rx<String> paymentMethod = 'Cash Payment'.obs;

  addNewProductInTheCartViaBarCode(ProductModel scannedProduct) {
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
      AppUtils.snakBarSucessGetX("New Product Added in the Cart",
          "Product Name is :${scannedProduct.productId}", 1);
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
    AppUtils.snakBarErrorGetX(
        "Cart is Reset", "Product Removed From the Cart", 2);
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

  calculateSubTotal() {
    // try {
    //   amountPaidCustomer.value =
    //       double.parse(amountPaidByCustomerController.value.text.toString());
    //   discountAmount.value =
    //       double.parse(discountFieldController.value.text.toString());
    // } catch (error) {
    //   amountPaidCustomer.value = 0;
    //   amountPaidByCustomerController.value.text = "0";
    //   discountAmount.value = 0;
    //   discountFieldController.value.text = "0";
    // }

    if (amountPaidByCustomerController.value.text.isEmpty ||
        discountFieldController.value.text.isEmpty) {
      debugPrint("hellloooo}");

      amountPaidCustomer.value = 0;
      discountAmount.value = 0;
      discountFieldController.value.text = '0';
      return;
    } else {
      amountPaidCustomer.value =
          double.parse(amountPaidByCustomerController.value.text.toString());
      discountAmount.value =
          double.parse(discountFieldController.value.text.toString());

      subTotal.value = 0;
      for (ProductModel scannedProduct in allScannedProductsList) {
        int quantity = scannedProduct.productQuantityInCart;
        double itemCost = quantity * (scannedProduct.productMrp);
        subTotal.value += itemCost;
      }
      double discountFactor = discountAmount.value / 100;
      discountAmount.value = subTotal.value * discountFactor;
      grandTotal.value = subTotal.value - discountAmount.value;

      if (amountPaidCustomer.value >= grandTotal.value) {
        changeForCustomer.value = amountPaidCustomer.value - grandTotal.value;
      } else {
        changeForCustomer.value = 0;
      }
    }
  }

  resetCartVariables() {
    amountPaidCustomer.value = 0;
    subTotal.value = 0;
    discountAmount.value = 0;
    grandTotal.value = 0;
    paymentMethod.value = 'Cash Payment';
    resetTheProductQuantitiesInCart();
  }

  computeSubTotal() {
    discountFieldController.value.text = '0';
    subTotal.value = 0;
    for (ProductModel scannedProduct in allScannedProductsList) {
      int quantity = scannedProduct.productQuantityInCart;
      double itemCost = quantity * (scannedProduct.productMrp);
      subTotal.value += itemCost;
    }
    double discountFactor = 0;
    discountAmount.value = subTotal.value * discountFactor;
    grandTotal.value = subTotal.value - discountAmount.value;
  }
}
