import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groc_pos_app/repository/product_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class ProductsMainViewModel {
  final ProductRepository _productRepository = ProductRepository();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllProducts() {
    try {
      CollectionReference<Map<String, dynamic>> productCollectionReference =
          _productRepository.fetchAllProducts();
      return productCollectionReference.snapshots();
    } catch (error) {
      debugPrint(error.toString());
      return const Stream.empty();
    }
  }

  Future<bool> removeProduct(
      Map<String, dynamic> deleteProductDetails, BuildContext context) async {
    try {
      bool status =
          await _productRepository.deleteProduct(deleteProductDetails);
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage("Product Deleted", context);
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
