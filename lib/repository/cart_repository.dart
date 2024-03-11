import 'package:groc_pos_app/data/network/firebase_backend_service.dart';
import 'package:groc_pos_app/models/ledger_customer_model.dart';

class CartRepository {
  final FirebaseApiService _firebaseApiService = FirebaseApiService();

  Future<bool> registerAPurchase(
      List<Map<String, dynamic>> updatedStocksDetails,
      Map<String, dynamic> invoiceDetails) async {
    try {
      bool status = await _firebaseApiService.registerPurchase(
          updatedStocksDetails, invoiceDetails);
      return status;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> registerAPurchaseInLedger(
    List<Map<String, dynamic>> updatedStocksDetails,
    Map<String, dynamic> invoiceDetails,
    Map<String, dynamic> purchaseDataForLedger,
    LedgerCustomerModel customerData,
  ) async {
    try {
      bool status = await _firebaseApiService.registerPurchaseInLedger(
          updatedStocksDetails,
          invoiceDetails,
          purchaseDataForLedger,
          customerData);

      return status;
    } catch (error) {
      rethrow;
    }
  }
}
