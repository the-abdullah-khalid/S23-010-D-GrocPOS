import 'package:flutter/material.dart';
import 'package:groc_pos_app/repository/product_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class EditProductViewModel {
  final ProductRepository _productRepository = ProductRepository();
  Future<bool> editProductDetails(
      Map<String, dynamic> editProductDetails, BuildContext context) async {
    try {
      bool status =
          await _productRepository.editProductDetails(editProductDetails);

      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage("Product Edited Successfully", context);
      });

      return true;
    } catch (error) {
      debugPrint(error.toString());
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarErrorMessage(error.toString(), context);
      });

      return false;
    }
  }
}
