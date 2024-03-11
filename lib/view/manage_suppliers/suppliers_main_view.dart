import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';
import 'package:groc_pos_app/models/supplier_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/widgets_components/no_data_message_widget.dart';
import '../../view_model/manage_suppliers/mange_supplier_main_view_model.dart';

class ManageSupplierMainView extends StatefulWidget {
  const ManageSupplierMainView({super.key});

  @override
  State<ManageSupplierMainView> createState() => _ManageSupplierMainViewState();
}

class _ManageSupplierMainViewState extends State<ManageSupplierMainView> {
  void performAddNewSupplier() {
    Get.toNamed(RouteName.addNewSupplier);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          title: Center(
            child: Text(
              "Groc-POS All Suppliers",
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
        body: const AllSuppliersList(),
        floatingActionButton: FloatingActionButton(
          onPressed: performAddNewSupplier,
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class AllSuppliersList extends StatefulWidget {
  const AllSuppliersList({super.key});

  @override
  State<AllSuppliersList> createState() => _AllSuppliersListState();
}

class _AllSuppliersListState extends State<AllSuppliersList> {
  late final supplierCollectionReferenceStream;
  void _loadAllSuppliers() {
    supplierCollectionReferenceStream =
        ManageSupplierMainViewModel().fetchAllSuppliers(context);

    if (supplierCollectionReferenceStream == const Stream.empty()) {
      AppUtils.errorDialog(context, "Something went wrong while fetching",
          "Please try again something went wrong while fetching the suppliers details");
      return;
    } else {
      print(supplierCollectionReferenceStream);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAllSuppliers();
  }

  _editSupplierDetails(SupplierModel tappedSupplierModel) {
    Get.toNamed(RouteName.editSupplierDetails,
        arguments: {"supplier_details": tappedSupplierModel});
  }

  _deleteSupplierDetails(SupplierModel swippedSupplierModel) async {
    if (swippedSupplierModel == null) {
      AppUtils.errorDialog(
          context, "Supplier Delete", "Something went wrong please try again");
      return;
    } else {
      final supplierDetails = {
        "supplier_id": swippedSupplierModel.supplierID,
        "supplier_address": swippedSupplierModel.supplierAddress,
        "supplier_email": swippedSupplierModel.supplierEmail,
        "supplier_name": swippedSupplierModel.supplierName,
        "supplier_of": swippedSupplierModel.supplierOf,
        "supplier_phone_no": swippedSupplierModel.supplierPhoneNo,
        "supplier_shop_name": swippedSupplierModel.supplierShopName
      };
      bool status = await ManageSupplierMainViewModel()
          .removeSupplierDetails(supplierDetails, context);
      if (!status) {
        Future.delayed(Duration.zero, () {
          AppUtils.errorDialog(context, "Product Delete Failure",
              "Something went wrong please try again");
        });
        return;
      }
    }
  }

  _openSupplierOverlay(SupplierModel tappedSupplierModel) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Text(
                    'Supplier Name : ${tappedSupplierModel.supplierName}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Supplier Shop Name : ${tappedSupplierModel.supplierShopName}',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Supplier Email : ${tappedSupplierModel.supplierEmail}',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Supplier Phone No : ${tappedSupplierModel.supplierPhoneNo}',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text('Supplier Of  : ${tappedSupplierModel.supplierOf}'),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Uri phoneno = Uri.parse(
                          'tel:+${tappedSupplierModel.supplierPhoneNo}');

                      if (await launchUrl(phoneno)) {
                        //dialer opened
                      } else {
                        //dailer is not opened
                      }
                    },
                    icon: const Icon(Icons.phone_android),
                    label: const Text('Call the Supplier'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Uri sms = Uri.parse(
                          'sms:+${tappedSupplierModel.supplierPhoneNo}?body=Query: Respected Supplier\n ');

                      if (await launchUrl(sms)) {
                        //dialer opened
                      } else {
                        //dailer is not opened
                      }
                    },
                    icon: const Icon(Icons.messenger),
                    label: const Text('SMS the Supplier'),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          'Add New Supplier',
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
          stream: supplierCollectionReferenceStream,
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

            print(snapshot.data!.docs.length.toString());

            if (snapshot.data!.docs.isEmpty) {
              return const NoDataMessageWidget(dataOf: "Supplier");
            }

            return Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return Dismissible(
                  key:
                      ValueKey(snapshot.data!.docs[index].reference.toString()),
                  onDismissed: (direction) {
                    SupplierModel currentSupplier = SupplierModel(
                      supplierPhoneNo:
                          data[SupplierDatabaseFieldNames.supplierPhoneNo],
                      supplierAddress:
                          data[SupplierDatabaseFieldNames.supplierAddress],
                      supplierEmail:
                          data[SupplierDatabaseFieldNames.supplierEmail],
                      supplierOf: data[SupplierDatabaseFieldNames.supplierOf],
                      supplierName:
                          data[SupplierDatabaseFieldNames.supplierName],
                      supplierShopName:
                          data[SupplierDatabaseFieldNames.supplierShopName],
                      supplierID: data.reference.id,
                    );
                    _deleteSupplierDetails(currentSupplier);
                  },
                  child: InkWell(
                    onLongPress: () {
                      SupplierModel currentSupplier = SupplierModel(
                        supplierPhoneNo:
                            data[SupplierDatabaseFieldNames.supplierPhoneNo],
                        supplierAddress:
                            data[SupplierDatabaseFieldNames.supplierAddress],
                        supplierEmail:
                            data[SupplierDatabaseFieldNames.supplierEmail],
                        supplierOf: data[SupplierDatabaseFieldNames.supplierOf],
                        supplierName:
                            data[SupplierDatabaseFieldNames.supplierName],
                        supplierShopName:
                            data[SupplierDatabaseFieldNames.supplierShopName],
                        supplierID: data.reference.id,
                      );
                      _editSupplierDetails(currentSupplier);
                    },
                    onTap: () {
                      SupplierModel currentSupplier = SupplierModel(
                        supplierPhoneNo:
                            data[SupplierDatabaseFieldNames.supplierPhoneNo],
                        supplierAddress:
                            data[SupplierDatabaseFieldNames.supplierAddress],
                        supplierEmail:
                            data[SupplierDatabaseFieldNames.supplierEmail],
                        supplierOf: data[SupplierDatabaseFieldNames.supplierOf],
                        supplierName:
                            data[SupplierDatabaseFieldNames.supplierName],
                        supplierShopName:
                            data[SupplierDatabaseFieldNames.supplierShopName],
                        supplierID: data.reference.id,
                      );

                      _openSupplierOverlay(currentSupplier);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Column(
                          children: [
                            Text(
                              snapshot
                                  .data!
                                  .docs[index][SupplierDatabaseFieldNames
                                      .supplierShopName]
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person),
                                    const SizedBox(width: 5),
                                    Text(
                                      snapshot
                                          .data!
                                          .docs[index][
                                              SupplierDatabaseFieldNames
                                                  .supplierName]
                                          .toString(),
                                    ),
                                  ],
                                ),
                                Text(
                                  snapshot
                                      .data!
                                      .docs[index][
                                          SupplierDatabaseFieldNames.supplierOf]
                                      .toString(),
                                ),
                                Text(
                                  snapshot
                                      .data!
                                      .docs[index][SupplierDatabaseFieldNames
                                          .supplierEmail]
                                      .toString(),
                                )
                              ],
                            )
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
        )
      ],
    );
  }
}
