import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/ledger/registered_customer_purchase_data_view_model.dart';

import '../../../resources/routes/routes_name.dart';

class PurchaseStateFalseWidget extends StatefulWidget {
  PurchaseStateFalseWidget({super.key, required this.purchaseCloseData});
  Map<String, dynamic> purchaseCloseData;

  @override
  State<PurchaseStateFalseWidget> createState() =>
      _PurchaseStateFalseWidgetState();
}

class _PurchaseStateFalseWidgetState extends State<PurchaseStateFalseWidget> {
  double amountPaidByCustomer = 0.0;
  double changeAmount = 0.0;
  bool roundButtonLoadingStatus = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Registered Customer Data",
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
          const SizedBox(
            height: 10,
          ),
          Text(
            "Your Due Amount Is ${double.parse(widget.purchaseCloseData['entire_purchase_data_snapshot']['grand_total_purchase'].toString()).abs().toString()}",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter The Amount Due',
              helperText: "90PKR",
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              debugPrint(" - ${value.toString()}");

              setState(() {
                if (value.isEmpty) {
                  amountPaidByCustomer = 0;
                } else {
                  amountPaidByCustomer = double.parse(value);
                  changeAmount = double.parse((double.parse(widget
                                      .purchaseCloseData[
                                          'entire_purchase_data_snapshot']
                                          ['grand_total_purchase']
                                      .toString())
                                  .abs() -
                              amountPaidByCustomer)
                          .toString())
                      .abs();
                }
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Amount Entered By : ${amountPaidByCustomer.toString()}",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: amountPaidByCustomer >=
                          widget.purchaseCloseData[
                                  'entire_purchase_data_snapshot']
                              ['grand_total_purchase']
                      ? Colors.green
                      : Colors.red),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Change Amount  : ${changeAmount.toString()}",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: amountPaidByCustomer >=
                          widget.purchaseCloseData[
                                  'entire_purchase_data_snapshot']
                              ['grand_total_purchase']
                      ? Colors.green
                      : Colors.red),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          RoundButton(
            loading: roundButtonLoadingStatus,
            title: "Close The Purchase",
            onTap: () {
              setState(() {
                roundButtonLoadingStatus = true;
              });
              if (amountPaidByCustomer >=
                  widget.purchaseCloseData['entire_purchase_data_snapshot']
                      ['grand_total_purchase']) {
                RegisteredCustomerPurchaseDataViewModel()
                    .closeAPurchaseRecordInLedger({
                  ...widget.purchaseCloseData,
                  'amount_paid_by_customer_for_ledger_close':
                      amountPaidByCustomer,
                  'change_amount': changeAmount,
                  'current_purchase_grand_total':
                      widget.purchaseCloseData['entire_purchase_data_snapshot']
                          ['grand_total_purchase']
                }, context);

                Future.delayed(Duration.zero, () {
                  AppUtils.flushBarSucessMessage(
                      "Ledger Purchase Closed Now", context);
                });

                setState(() {
                  roundButtonLoadingStatus = true;
                });

                Get.until((route) => Get.currentRoute == RouteName.ledgerView);
              } else {
                setState(() {
                  roundButtonLoadingStatus = true;
                });
                AppUtils.errorDialog(context, "Close Purchase Error",
                    "Amount Paid Must be Greater than the Grand Total");
              }
            },
          ),
        ],
      ),
    );
    ;
  }
}
