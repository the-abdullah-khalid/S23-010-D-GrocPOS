import 'package:flutter/material.dart';
import 'package:groc_pos_app/view_model/payment_details/easy_pisa_payment_details_view_model.dart';

class EasyPisaQRWidget extends StatelessWidget {
  const EasyPisaQRWidget({
    super.key,
    required this.easyPisaPaymentDetailsViewModelContoller,
  });

  final EasyPisaPaymentDetailsViewModel
      easyPisaPaymentDetailsViewModelContoller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 125,
            child: Image(
              image: AssetImage(
                "assets/logos/easy-pisa.png",
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Easy Paisa Payment Details"),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Easy Paisa Account Number : ${easyPisaPaymentDetailsViewModelContoller.paymentMethod.value.accountNumber}",
          ),
          const SizedBox(
            height: 20,
          ),
          Image(
            image: NetworkImage(easyPisaPaymentDetailsViewModelContoller
                .paymentMethod.value.paymentQRImageUrl),
          )
        ],
      ),
    );
  }
}
