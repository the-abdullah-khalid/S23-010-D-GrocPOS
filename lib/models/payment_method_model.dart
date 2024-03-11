import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';

class PaymentMethodModel {
  final String accountNumber;
  final String paymentMethod;
  final String paymentQRImageUrl;

  PaymentMethodModel(
      {required this.accountNumber,
      required this.paymentMethod,
      required this.paymentQRImageUrl});

  factory PaymentMethodModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;

    debugPrint(data.toString());

    if (data == null) {
      return PaymentMethodModel(
        accountNumber: "",
        paymentMethod: "",
        paymentQRImageUrl: "",
      );
    }
    return PaymentMethodModel(
      accountNumber: data[DatabasePaymentCollectionName.ACCOUNTNUMBER],
      paymentMethod: data[DatabasePaymentCollectionName.PAYMENTMETHOD],
      paymentQRImageUrl: data[DatabasePaymentCollectionName.PAYMENTQRIMAGEURL],
    );
  }
}
