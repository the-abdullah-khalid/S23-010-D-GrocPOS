import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groc_pos_app/data/network/firebase_backend_service.dart';

class SupplierRepository {
  final FirebaseApiService _firebaseApiService = FirebaseApiService();

  Future<bool> addNewSupplier(Map<String, dynamic> newSupplierDetails) async {
    try {
      bool status =
          await _firebaseApiService.addNewSupplier(newSupplierDetails);
      return status;
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> fetchAllSuppliers() {
    try {
      CollectionReference<Map<String, dynamic>> suppliersCollectionReference =
          _firebaseApiService.fetchAllShopSuppliers();
      return suppliersCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateSupplierDetails(
      Map<String, dynamic> updatedSupplierDetails) async {
    try {
      bool status = await _firebaseApiService
          .updateSupplierDetails(updatedSupplierDetails);
      return status;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteSupplier(
      Map<String, dynamic> deleteSupplierDetails) async {
    try {
      bool status = await _firebaseApiService
          .deleteSupplierDetails(deleteSupplierDetails);
      return true;
    } catch (error) {
      rethrow;
    }
  }
}
