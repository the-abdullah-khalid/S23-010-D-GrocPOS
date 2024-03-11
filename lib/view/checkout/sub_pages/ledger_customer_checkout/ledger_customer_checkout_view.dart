import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';
import 'package:groc_pos_app/models/ledger_customer_model.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/colors/pie_chart_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/resources/widgets_components/no_data_message_widget.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../../../../view_model/checkout/ledger_customer_checkout/ledger_customer_checkout_main_view_model.dart';

class LedgerCustomerCheckOutView extends StatefulWidget {
  const LedgerCustomerCheckOutView({super.key});

  @override
  State<LedgerCustomerCheckOutView> createState() =>
      _LedgerCustomerCheckOutView();
}

class _LedgerCustomerCheckOutView extends State<LedgerCustomerCheckOutView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>>?
      _ledgerCollectionReferenceStream;

  _loadAllLedgerCustomer() {
    debugPrint("load all ledger data");
    _ledgerCollectionReferenceStream =
        LedgerCustomerCheckoutMainViewModel().fetchAllLedgerData();

    if (_ledgerCollectionReferenceStream == const Stream.empty()) {
      AppUtils.errorDialog(context, "Something went wrong while fetching",
          "Please try again something went wrong while fetching the products details");
      return;
    } else {
      debugPrint(_ledgerCollectionReferenceStream.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAllLedgerCustomer();
  }

  _openALedgerRegisteredCustomerForCheckoutView(
      LedgerCustomerModel tappedCustomer) {
    Get.toNamed(RouteName.openALedgerRegisteredCustomerCheckOutView,
        arguments: {
          'customer_details': tappedCustomer,
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Ledger Customer Checkout",
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
            "Shop Ledger Customer Registered",
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
          StreamBuilder(
            stream: _ledgerCollectionReferenceStream,
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
                return const NoDataMessageWidget(dataOf: "Ledger");
              }

              return Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  final customerData = snapshot.data!.docs[index];
                  return InkWell(
                    onTap: () {
                      LedgerCustomerModel newCustomer = LedgerCustomerModel(
                          customerName:
                              snapshot.data!.docs[index][LedgerCustomerDatabaseFieldNames.customerName]
                                  .toString(),
                          customerCNIC:
                              snapshot.data!.docs[index][LedgerCustomerDatabaseFieldNames.customerCNIC]
                                  .toString(),
                          customerPhoneNUmber:
                              snapshot.data!.docs[index][LedgerCustomerDatabaseFieldNames.customerPhoneNo]
                                  .toString(),
                          customerTotalAmountDue: snapshot
                              .data!
                              .docs[index][LedgerCustomerDatabaseFieldNames
                                  .customerTotalAmountDue]
                              .toString(),
                          customerAddress: snapshot
                              .data!
                              .docs[index]
                                  [LedgerCustomerDatabaseFieldNames.customerAddress]
                              .toString(),
                          customerID: snapshot.data!.docs[index].id.toString());

                      _openALedgerRegisteredCustomerForCheckoutView(
                          newCustomer);
                    },
                    onLongPress: () {},
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                customerData[LedgerCustomerDatabaseFieldNames
                                        .customerName]
                                    .toString(),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text("Phone No#: "),
                                      Text(
                                        customerData[
                                            LedgerCustomerDatabaseFieldNames
                                                .customerPhoneNo],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text("CNIC: "),
                                      Text(
                                        customerData[
                                            LedgerCustomerDatabaseFieldNames
                                                .customerCNIC],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Customer Address:\n${customerData[LedgerCustomerDatabaseFieldNames.customerAddress].toString()}",
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
                                "Amount Due: ${(double.parse(customerData[LedgerCustomerDatabaseFieldNames.customerTotalAmountDue]).abs()).toString()} PKR",
                                style: GoogleFonts.getFont(
                                  AppFontsNames.kBodyFont,
                                  textStyle: TextStyle(
                                    color: double.parse(customerData[
                                                    LedgerCustomerDatabaseFieldNames
                                                        .customerTotalAmountDue])
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
                  );
                },
                itemCount: snapshot.data!.docs.length,
              ));
            },
          ),
        ],
      ),
    );
  }
}
