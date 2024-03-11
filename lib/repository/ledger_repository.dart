import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groc_pos_app/data/network/firebase_backend_service.dart';

class LedgerRepository {
  final FirebaseApiService _firebaseApiService = FirebaseApiService();

  Future<bool> addNewCustomerInLedger(
      Map<String, dynamic> newCustomerDataInLedger) async {
    try {
      bool status = await _firebaseApiService
          .addNewCustomerInLedger(newCustomerDataInLedger);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> fetchAllLedgerCustomers() {
    try {
      CollectionReference<Map<String, dynamic>>
          fetchAllLedgerCollectionReference =
          _firebaseApiService.fetchAllLedgerData();
      return fetchAllLedgerCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteCustomer(Map<String, dynamic> deleteProductDetails) async {
    try {
      bool status =
          await _firebaseApiService.deleteLedgerCustomer(deleteProductDetails);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> fetchAllCustomerPurchases(
      String customerID) {
    try {
      CollectionReference<Map<String, dynamic>>
          fetchAllLedgerCollectionReference =
          _firebaseApiService.fetchAllLedgerCustomerPurchases(customerID);
      return fetchAllLedgerCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> closeAPurchaseRecordInLedger(
      Map<String, dynamic> closePurchaseData) async {
    try {
      bool status = await _firebaseApiService
          .closeAPurchaseRecordInLedger(closePurchaseData);
      return true;
    } catch (error) {
      rethrow;
    }
  }
}
