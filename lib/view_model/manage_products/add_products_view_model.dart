import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groc_pos_app/repository/product_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class AddProductViewModel {
  final ProductRepository _productRepository = ProductRepository();
  Future<bool> addProductDetails(
      BuildContext context, Map<String, dynamic> newProductDetails) async {
    try {
      bool status = await _productRepository.addNewProduct(newProductDetails);
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage(
            "New Product Added Successfully", context);
      });
      return true;
    } catch (error) {
      debugPrint(error.toString());
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarErrorMessage(error.toString(), context);
      });
    }
    return false;
  }
}
