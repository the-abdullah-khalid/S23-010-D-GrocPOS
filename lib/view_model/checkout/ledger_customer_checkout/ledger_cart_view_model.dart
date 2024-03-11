import 'package:flutter/material.dart';
import 'package:groc_pos_app/models/ledger_customer_model.dart';
import 'package:groc_pos_app/repository/cart_repository.dart';

class LedgerCustomerCartViewModel {
  final CartRepository _cartRepository = CartRepository();

  Future<bool> registerPurchaseInLedger(
      List<Map<String, dynamic>> updatedStocks,
      Map<String, dynamic> invoiceDetails,
      Map<String, dynamic> purchaseData,
      LedgerCustomerModel customerData,
      BuildContext context) async {
    try {
      debugPrint("updatedStocks - ${updatedStocks}");
      debugPrint("invoiceDetails - ${invoiceDetails}");
      debugPrint("purchaseData - ${purchaseData}");
      debugPrint("customerData - ${customerData}");

      bool status = await _cartRepository.registerAPurchaseInLedger(
          updatedStocks, invoiceDetails, purchaseData, customerData);

      // bool status = await _cartRepository.registerAPurchase(
      //     updatedStocks, invoiceDetails);
      return status;
    } catch (error) {
      return false;
    }
  }
}
