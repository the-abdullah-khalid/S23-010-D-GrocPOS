import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view_model/payment_details/jazz_cash_payment_details_view_model.dart';

class ShowJazzCashDetailsView extends StatefulWidget {
  const ShowJazzCashDetailsView({super.key});

  @override
  State<ShowJazzCashDetailsView> createState() => _ShowJazzCashViewState();
}

class _ShowJazzCashViewState extends State<ShowJazzCashDetailsView> {
  final JazzCashPaymentDetailsViewModel jazzPaymentDetailsViewModelContoller =
      Get.put(JazzCashPaymentDetailsViewModel());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPaymentDetails();
  }

  _loadPaymentDetails() {
    jazzPaymentDetailsViewModelContoller.fetchPaymentDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Jazz Cash Details Page",
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
                  'Jazz Cash Detail Here',
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
                if (jazzPaymentDetailsViewModelContoller
                        .paymentMethod.value.accountNumber ==
                    "") {
                  return const CircularProgressIndicator();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              width: double.infinity,
                              height: 125,
                              child: Image(
                                image: AssetImage(
                                  "assets/logos/jazz-cash-logo.png",
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Jazz Cash Payment Details"),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Jazz Cash Account Number : ${jazzPaymentDetailsViewModelContoller.paymentMethod.value.accountNumber}",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Image(
                              image: NetworkImage(
                                  jazzPaymentDetailsViewModelContoller
                                      .paymentMethod.value.paymentQRImageUrl),
                            )
                          ],
                        ),
                      ),
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
