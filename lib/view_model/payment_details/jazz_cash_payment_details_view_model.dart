import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/payment_method_model.dart';
import 'package:groc_pos_app/repository/shop_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JazzCashPaymentDetailsViewModel extends GetxController {
  final ShopRepository _shopRepository = ShopRepository();
  Rx<PaymentMethodModel> paymentMethod = PaymentMethodModel(
          accountNumber: "", paymentMethod: "", paymentQRImageUrl: "")
      .obs;

  uploadEasyPisaDetails(
      Map<String, dynamic> paymentDetails, BuildContext context) async {
    try {
      await _shopRepository.uploadPaymentDetails(paymentDetails);
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage("Image Upload Successful", context);
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

  setPaymentMethod(PaymentMethodModel fetchedPaymentMethod) {
    paymentMethod.value = fetchedPaymentMethod;
  }

  fetchPaymentDetails(BuildContext context) async {
    try {
      PaymentMethodModel paymentMethodModel =
          await _shopRepository.fetchPaymentDetails("jazz-cash");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jazz-cash_payment_qr_image_url',
          paymentMethodModel.paymentQRImageUrl);
      if (paymentMethodModel != null) {
        setPaymentMethod(paymentMethodModel);
      }
    } catch (error) {
      debugPrint(error.toString());
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarErrorMessage(error.toString(), context);
      });
    }
  }
}
