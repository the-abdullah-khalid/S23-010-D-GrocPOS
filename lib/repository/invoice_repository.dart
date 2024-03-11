import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groc_pos_app/data/network/firebase_backend_service.dart';

class InvoiceRepository {
  final FirebaseApiService _firebaseApiService = FirebaseApiService();

  CollectionReference<Map<String, dynamic>> fetchAllInvoices() {
    try {
      CollectionReference<Map<String, dynamic>>
          fetchAllInvoicesCollectionReference =
          _firebaseApiService.fetchAllInvoices();
      return fetchAllInvoicesCollectionReference;
    } catch (error) {
      rethrow;
    }
  }
}
