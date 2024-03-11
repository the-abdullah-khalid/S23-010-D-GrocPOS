import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:groc_pos_app/repository/ledger_repository.dart';

class LedgerCustomerCheckoutMainViewModel {
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
}
