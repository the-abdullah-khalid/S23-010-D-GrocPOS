import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view/manage_suppliers/widgets/easy_pisa_qr_widget.dart';
import 'package:groc_pos_app/view_model/payment_details/easy_pisa_payment_details_view_model.dart';

class ShowEasyPisaDetailsView extends StatefulWidget {
  const ShowEasyPisaDetailsView({super.key});

  @override
  State<ShowEasyPisaDetailsView> createState() =>
      _ShowEasyPisaDetailsViewState();
}

class _ShowEasyPisaDetailsViewState extends State<ShowEasyPisaDetailsView> {
  final EasyPisaPaymentDetailsViewModel
      easyPisaPaymentDetailsViewModelContoller =
      Get.put(EasyPisaPaymentDetailsViewModel());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPaymentDetails();
  }

  _loadPaymentDetails() {
    easyPisaPaymentDetailsViewModelContoller.fetchPaymentDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Easy Paisa Details Page",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Easy Pisa Detail Here',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    AppFontsNames.kBodyFont,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff246bdd),
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() {
                if (easyPisaPaymentDetailsViewModelContoller
                        .paymentMethod.value.accountNumber ==
                    "") {
                  return const CircularProgressIndicator();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      child: EasyPisaQRWidget(
                          easyPisaPaymentDetailsViewModelContoller:
                              easyPisaPaymentDetailsViewModelContoller),
                    ),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
