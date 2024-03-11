import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/ledger_customer_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view/ledger/widgets/purchase_status_false_widget.dart';
import 'package:groc_pos_app/view/ledger/widgets/purchase_status_true_widget.dart';
import 'package:groc_pos_app/view_model/ledger/registered_customer_purchase_data_view_model.dart';

import '../../../../resources/widgets_components/no_data_message_widget.dart';
import '../../../checkout/sub_pages/ledger_customer_checkout/sub_pages/add_new_purchase_in_ledger_view.dart';

class CustomerPurchasesListMainView extends StatefulWidget {
  CustomerPurchasesListMainView({super.key, required this.data});
  dynamic data;

  @override
  State<CustomerPurchasesListMainView> createState() =>
      _CustomerPurchasesListMainViewState();
}

class _CustomerPurchasesListMainViewState
    extends State<CustomerPurchasesListMainView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>>?
      _ledgerCustomerPurchasesCollectionReferenceStream;

  _loadAllLedgerCustomerPurchases() {
    debugPrint("load all ledger data");
    _ledgerCustomerPurchasesCollectionReferenceStream =
        RegisteredCustomerPurchaseDataViewModel().fetchAllCustomerPurchases(
            (widget.data as LedgerCustomerModel).customerID);

    if (_ledgerCustomerPurchasesCollectionReferenceStream ==
        const Stream.empty()) {
      AppUtils.errorDialog(context, "Something went wrong while fetching",
          "Please try again something went wrong while fetching the products details");
      return;
    } else {
      debugPrint(_ledgerCustomerPurchasesCollectionReferenceStream.toString());
    }
  }

  _closedLedgerPurchase(Map<String, dynamic> purchaseCloseData) {
    if (purchaseCloseData == null) {
      AppUtils.errorDialog(
        context,
        "Purchase Data Cannot Be Null",
        "Purchase Data Cannot Be Null",
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) {
        if (purchaseCloseData["purchase_status"]) {
          return PurchaseStatusTrueWidget();
        } else {
          return PurchaseStateFalseWidget(
            purchaseCloseData: purchaseCloseData,
          );
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAllLedgerCustomerPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Groc-POS Customer Ledger Purchases",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
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
          Container(
            margin: const EdgeInsets.all(10),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      (widget.data as LedgerCustomerModel)
                          .customerName
                          .toString(),
                      style: GoogleFonts.getFont(
                        AppFontsNames.kBodyFont,
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Phone No#: "),
                            Text(
                              (widget.data as LedgerCustomerModel)
                                  .customerPhoneNUmber,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("CNIC: "),
                            Text(
                              (widget.data as LedgerCustomerModel).customerCNIC,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Customer Address:\n${(widget.data as LedgerCustomerModel).customerAddress.toString()}",
                      style: GoogleFonts.getFont(
                        AppFontsNames.kBodyFont,
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Amount Due: ${(double.parse((widget.data as LedgerCustomerModel).customerTotalAmountDue)).abs().toString()} PKR",
                      style: GoogleFonts.getFont(
                        AppFontsNames.kBodyFont,
                        textStyle: TextStyle(
                          color: double.parse(
                                          (widget.data as LedgerCustomerModel)
                                              .customerTotalAmountDue)
                                      .abs() >
                                  0
                              ? Colors.red
                              : Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          Text(
            "All Customer Purchases\nTransactions",
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
          const Divider(),
          StreamBuilder(
            stream: _ledgerCustomerPurchasesCollectionReferenceStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                AppUtils.flushBarErrorMessage(
                    "Some Error While Fetching Data", context);
                return const Text('Some Error While Fetching Data');
              }
              // print(snapshot.data!.docs.length.toString());
              if (snapshot.connectionState == ConnectionState.done) {
                AppUtils.snakBar("All Ledger Loaded", context);
              }

              if (snapshot.data!.docs.isEmpty) {
                return const NoDataMessageWidget(
                  dataOf: "Purchases",
                  message: "Go To Checkout To add ledger entries",
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final customerPurchaseData = snapshot.data!.docs[index];
                    debugPrint(" - ${customerPurchaseData.toString()}");
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Map<String, dynamic> closePurchaseData = {
                            'purhcase_id': customerPurchaseData.id.toString(),
                            'customer_id':
                                (widget.data as LedgerCustomerModel).customerID,
                            'purchase_status':
                                customerPurchaseData["purchase_done"],
                            'date_of_payment': formatter.format(DateTime.now()),
                            'entire_purchase_data_snapshot':
                                customerPurchaseData,
                            'ledger_customer_data':
                                widget.data as LedgerCustomerModel
                          };

                          _closedLedgerPurchase(closePurchaseData);
                        },
                        child: Container(
                          color: customerPurchaseData["purchase_done"]
                              ? Colors.green
                              : Colors.red,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "Purchase Title: ${customerPurchaseData['purchase_title']}",
                                    style: GoogleFonts.getFont(
                                      AppFontsNames.kBodyFont,
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text("Purchase Date: "),
                                          Text(
                                            customerPurchaseData[
                                                    "date_of_purchase"]
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text("Due Date: "),
                                          Text(
                                            customerPurchaseData[
                                                    'purchase_due_date']
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Amount To Be Paid: ${customerPurchaseData["amount_to_be_paid"].toString()}",
                                    style: GoogleFonts.getFont(
                                      AppFontsNames.kBodyFont,
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Total Amount of Purchase: ${double.parse(customerPurchaseData["grand_total_purchase"].toString()).abs()}",
                                    style: GoogleFonts.getFont(
                                      AppFontsNames.kBodyFont,
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Is Payment Done: ${customerPurchaseData["purchase_done"] ? "Yes" : "No"}",
                                    style: GoogleFonts.getFont(
                                      AppFontsNames.kBodyFont,
                                      textStyle: TextStyle(
                                          color: customerPurchaseData[
                                                  "purchase_done"]
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
