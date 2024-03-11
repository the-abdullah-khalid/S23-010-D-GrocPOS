import 'package:flutter/material.dart';
import 'package:groc_pos_app/repository/supplier_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class AddNewSupplierViewModel {
  final SupplierRepository _supplierRepository = SupplierRepository();

  Future<bool> addNewSupplier(
      BuildContext context, Map<String, dynamic> supplierDetails) async {
    try {
      bool status = await _supplierRepository.addNewSupplier(supplierDetails);

      return true;
    } catch (error) {
      debugPrint(error.toString());
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarErrorMessage(error.toString(), context);
      });
    }
    return false;
  }
}
