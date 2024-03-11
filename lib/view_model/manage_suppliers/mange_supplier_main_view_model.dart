import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groc_pos_app/repository/supplier_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class ManageSupplierMainViewModel {
  final SupplierRepository _supplierRepository = SupplierRepository();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllSuppliers(
      BuildContext context) {
    try {
      CollectionReference<Map<String, dynamic>> supplierCollectionReference =
          _supplierRepository.fetchAllSuppliers();
      return supplierCollectionReference.snapshots();
    } catch (error) {
      debugPrint(error.toString());
      AppUtils.flushBarErrorMessage(error.toString(), context);
      return const Stream.empty();
    }
  }

  Future<bool> removeSupplierDetails(
      Map<String, dynamic> deleteProductDetails, BuildContext context) async {
    try {
      bool status =
          await _supplierRepository.deleteSupplier(deleteProductDetails);
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage("Supplier Deleted", context);
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
