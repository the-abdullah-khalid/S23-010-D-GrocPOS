import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:groc_pos_app/models/payment_method_model.dart';
import 'package:groc_pos_app/models/shop_model.dart';

import '../data/network/firebase_backend_service.dart';

class ShopRepository {
  final FirebaseApiService _firebaseApiService = FirebaseApiService();

  Future<ShopModel> fetchShopDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> responseShopDetails =
          await _firebaseApiService.fetchShopDetailsApi();

      // debugPrint(responseShopDetails.toString());
      ShopModel shopModel = ShopModel.fromSnapshot(responseShopDetails);
      if (shopModel == null) {
        throw Exception('Shop Model got null something went wrong');
      }
      return shopModel;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<dynamic> updateShopDetails(
      Map<String, dynamic> updatedProfileData) async {
    try {
      dynamic _response =
          await _firebaseApiService.updateProfileDetails(updatedProfileData);

      return _response;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllShopExpenses() async {
    try {
      CollectionReference<Map<String, dynamic>>
          responseExpensesDetailsCollection =
          await _firebaseApiService.fetchAllExpenseDetails();
      debugPrint(" - ${responseExpensesDetailsCollection.toString()}");

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await responseExpensesDetailsCollection.get();

      List<DocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      List<Map<String, dynamic>> expenses = [];

      for (var document in documents) {
        Map<String, dynamic> data = document.data()!;
        // Process data as needed
        expenses.add(data);
      }

      return expenses;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  // upload payment details
  Future<void> uploadPaymentDetails(Map<String, dynamic> paymentDetails) async {
    try {
      dynamic response =
          await _firebaseApiService.uploadPaymentDetails(paymentDetails);

      if (kDebugMode) {
        print(response);
      }
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Future<Map<String, dynamic>?> fetchPaymentDetails(
  //     String paymentDetailsCollectionName) async {
  //   try {
  //     Map<String, dynamic>? paymentDetails = await _firebaseApiService
  //         .fetchPaymentDetails(paymentDetailsCollectionName);
  //
  //     if (paymentDetails != null) {
  //       // The payment details exist, you can use them here
  //       print('Payment details: $paymentDetails');
  //       return paymentDetails;
  //     } else {
  //       // Payment details not found
  //       print('Payment details not found.');
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  //   return null;
  // }

  Future<PaymentMethodModel> fetchPaymentDetails(
      String paymentDetailsCollectionName) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> responseShopDetails =
          await _firebaseApiService
              .fetchPaymentDetails(paymentDetailsCollectionName);

      // debugPrint(responseShopDetails.toString());
      PaymentMethodModel paymentDetails =
          PaymentMethodModel.fromSnapshot(responseShopDetails);
      if (paymentDetails == null) {
        throw Exception('Shop Model got null something went wrong');
      }
      return paymentDetails;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}
