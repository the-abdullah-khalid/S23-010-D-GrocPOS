import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groc_pos_app/repository/ledger_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class ManageLedgerMainViewModel {
  final LedgerRepository _ledgerRepository = LedgerRepository();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllLedgerData() {
    try {
      CollectionReference<Map<String, dynamic>> ledgerCollectionReference =
          _ledgerRepository.fetchAllLedgerCustomers();
      return ledgerCollectionReference.snapshots();
    } catch (error) {
      debugPrint(error.toString());
      return const Stream.empty();
    }
  }

  Future<bool> removeCustomerDetailsFromLedger(
      Map<String, dynamic> deleteCustomerDetails, BuildContext context) async {
    try {
      debugPrint(
          "delete customer deetails - ${deleteCustomerDetails.toString()}");

      bool status =
          await _ledgerRepository.deleteCustomer(deleteCustomerDetails);

      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage(
            "customer ledger record Deleted", context);
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
