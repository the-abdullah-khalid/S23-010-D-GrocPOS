import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:groc_pos_app/repository/invoice_repository.dart';

class ManageReciptsViewModel {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllInvoices() {
    try {
      CollectionReference<Map<String, dynamic>> invoiceCollectionReference =
          _invoiceRepository.fetchAllInvoices();
      return invoiceCollectionReference.snapshots();
    } catch (error) {
      debugPrint(error.toString());
      return const Stream.empty();
    }
  }
}
