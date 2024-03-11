import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';

class SupplierModel {
  final String supplierPhoneNo;
  final String supplierAddress;
  final String supplierEmail;
  final String supplierOf;
  final String supplierName;
  final String supplierShopName;
  final String supplierID;

  SupplierModel({
    required this.supplierPhoneNo,
    required this.supplierAddress,
    required this.supplierEmail,
    required this.supplierOf,
    required this.supplierName,
    required this.supplierShopName,
    required this.supplierID,
  });

  toJson() {
    return {
      "supplier_phone_no": supplierPhoneNo,
      "supplier_address": supplierAddress,
      "supplier_email": supplierEmail,
      "supplier_of": supplierOf,
      "supplier_name": supplierName,
      "supplier_shop_name": supplierShopName,
      "supplier_shop_name": supplierID,
    };
  }

  @override
  String toString() {
    return 'SupplierModel{supplier_phone_no: $supplierPhoneNo, supplier_address: $supplierAddress, supplier_email: $supplierEmail, '
        'supplier_of: $supplierOf, supplier_name: $supplierName, supplier_shop_name: $supplierShopName supplier-id : $supplierID';
  }

  factory SupplierModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;

    debugPrint(data.toString());
    return SupplierModel(
      supplierPhoneNo: data[SupplierDatabaseFieldNames.supplierPhoneNo],
      supplierAddress: data[SupplierDatabaseFieldNames.supplierAddress],
      supplierEmail: data[SupplierDatabaseFieldNames.supplierEmail],
      supplierOf: data[SupplierDatabaseFieldNames.supplierOf],
      supplierName: data[SupplierDatabaseFieldNames.supplierName],
      supplierShopName: data[SupplierDatabaseFieldNames.supplierShopName],
      supplierID: data[SupplierDatabaseFieldNames.supplierID],
    );
  }
}
