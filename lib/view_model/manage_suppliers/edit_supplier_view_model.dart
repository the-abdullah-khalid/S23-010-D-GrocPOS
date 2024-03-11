import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groc_pos_app/repository/supplier_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class EditSupplierDetailsViewModel {
  final SupplierRepository _supplierRepository = SupplierRepository();

  Future<bool> editSupplierDetails(
      BuildContext context, Map<String, dynamic> updatedSupplierDetails) async {
    try {
      bool status = await _supplierRepository
          .updateSupplierDetails(updatedSupplierDetails);
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage(
            "Supplier Details Updated Sucessfully", context);
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
}
