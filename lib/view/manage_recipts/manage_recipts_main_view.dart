import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';
import 'package:groc_pos_app/models/invoice_model.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/resources/widgets_components/no_data_message_widget.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/manage_recipts/manage_recipts_main_view_model.dart';

class ManageReciptesMainView extends StatefulWidget {
  const ManageReciptesMainView({super.key});

  @override
  State<ManageReciptesMainView> createState() => _ManageReciptesMainViewState();
}

class _ManageReciptesMainViewState extends State<ManageReciptesMainView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>>?
      _allShopRecipitsCollectionReferenceStream;

  _loadAllInvoices() {
    debugPrint("load all expenses");
    _allShopRecipitsCollectionReferenceStream =
        ManageReciptsViewModel().fetchAllInvoices();

    if (_allShopRecipitsCollectionReferenceStream == const Stream.empty()) {
      AppUtils.errorDialog(context, "Something went wrong while fetching",
          "Please try again something went wrong while fetching the products details");
      return;
    } else {
      debugPrint(_allShopRecipitsCollectionReferenceStream.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAllInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Manage Receipts",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "All Shop Receipts",
                style: GoogleFonts.getFont(
                  AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: _allShopRecipitsCollectionReferenceStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  AppUtils.flushBarErrorMessage(
                      "Some Error While Fetching Data", context);
                  return const Text('Some Error While Fetching Data');
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const NoDataMessageWidget(
                    dataOf: "Receipts",
                    message: "No shop receipts are found",
                  );
                }
                print(snapshot.data!.docs.length.toString());

                return Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == null) {
                      return const Text("No Invoice has been made yet");
                    }

                    List<dynamic> productsList = snapshot.data!.docs[index]
                        [InvoiceDatabaseFieldNames.productsList];

                    return InkWell(
                      onTap: () {
                        List<dynamic> productsList =
                            snapshot.data!.docs[index]['products-list'];
                        List<ProductModel> allProductsInTheInvoice = [];

                        for (Map<String, dynamic> productMap in productsList) {
                          allProductsInTheInvoice
                              .add(ProductModel.fromMap(productMap));
                        }
                        Timestamp invoiceTimeStamp = snapshot.data!.docs[index]
                            ['date-time'] as Timestamp;
                        InvoiceModel newInvoiceModel = InvoiceModel(
                            snapshot.data!.docs[index]
                                ['amount-paid-by-customer'],
                            snapshot.data!.docs[index]['bill-id'],
                            snapshot.data!.docs[index]['change-amount'],
                            snapshot.data!.docs[index]['customer-name'],
                            snapshot.data!.docs[index]['customer-type'],
                            invoiceTimeStamp.toDate(),
                            snapshot.data!.docs[index]['discount-percentage'],
                            snapshot.data!.docs[index]['grand-total'],
                            allProductsInTheInvoice,
                            snapshot.data!.docs[index]['sub-total']);

                        debugPrint(
                            "tapped invoice - ${newInvoiceModel.toString()}");

                        Get.toNamed(RouteName.seeInvoiceDetails,
                            arguments: {"invoiceDetails": newInvoiceModel});
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                "Customer Name : ${snapshot.data!.docs[index][InvoiceDatabaseFieldNames.customerName]}",
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
                              Text(
                                "Customer Type : ${snapshot.data!.docs[index]['customer-type']}",
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Grand Total :${snapshot.data!.docs[index][InvoiceDatabaseFieldNames.grandTotal]}"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Discount %: ${snapshot.data!.docs[index][InvoiceDatabaseFieldNames.discountPercentage]}"),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Sub Total :${snapshot.data!.docs[index][InvoiceDatabaseFieldNames.subTotal]}"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Amount Paid : ${snapshot.data!.docs[index][InvoiceDatabaseFieldNames.amountPaidByCustomer]}"),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Items Purchased :${productsList.length}",
                                        style: GoogleFonts.getFont(
                                          AppFontsNames.kBodyFont,
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
