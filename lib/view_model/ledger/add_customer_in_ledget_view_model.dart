import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:groc_pos_app/repository/ledger_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class AddCustomerInLedgerViewModel {
  final LedgerRepository _ledgerRepository = LedgerRepository();

  Future<bool> addNewCustomerInLedger(
      BuildContext context, Map<String, dynamic> newCustomerData) async {
    try {
      bool status =
          await _ledgerRepository.addNewCustomerInLedger(newCustomerData);
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage(
            "New Customer Added In Ledger Successfully", context);
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

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllCustomerPurchases(
      String customerID) {
    try {
      CollectionReference<Map<String, dynamic>> ledgerCollectionReference =
          _ledgerRepository.fetchAllCustomerPurchases(customerID);
      return ledgerCollectionReference.snapshots();
    } catch (error) {
      debugPrint(error.toString());
      return const Stream.empty();
    }
  }
}
