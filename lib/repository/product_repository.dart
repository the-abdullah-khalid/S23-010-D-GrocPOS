import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groc_pos_app/data/network/firebase_backend_service.dart';

class ProductRepository {
  final FirebaseApiService _firebaseApiService = FirebaseApiService();

  Future<bool> addNewProduct(Map<String, dynamic> newProductDetails) async {
    try {
      bool status = await _firebaseApiService.addNewProduct(newProductDetails);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> fetchAllProducts() {
    try {
      CollectionReference<Map<String, dynamic>>
          fetchAllProductsCollectionReference =
          _firebaseApiService.fetchAllProductDetails();
      return fetchAllProductsCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> editProductDetails(
      Map<String, dynamic> editedProductDetails) async {
    try {
      bool status =
          await _firebaseApiService.editProductDetails(editedProductDetails);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteProduct(Map<String, dynamic> deleteProductDetails) async {
    try {
      bool status =
          await _firebaseApiService.deleteProduct(deleteProductDetails);
      return true;
    } catch (error) {
      rethrow;
    }
  }
}
