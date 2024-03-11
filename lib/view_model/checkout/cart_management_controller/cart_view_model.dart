import 'package:flutter/material.dart';
import 'package:groc_pos_app/repository/cart_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class CartViewModel {
  final CartRepository _cartRepository = CartRepository();

  Future<bool> registerPurchase(List<Map<String, dynamic>> updatedStocks,
      Map<String, dynamic> invoiceDetails, BuildContext context) async {
    try {
      bool status = await _cartRepository.registerAPurchase(
          updatedStocks, invoiceDetails);
      return status;
    } catch (error) {
      return false;
    }
  }
}
