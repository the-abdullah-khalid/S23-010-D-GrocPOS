import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/colors/pie_chart_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';

import 'widget/products_list_checkout_widget.dart';

class CheckOutMainView extends StatefulWidget {
  const CheckOutMainView({super.key});

  @override
  State<CheckOutMainView> createState() => _CheckOutMainViewState();
}

class _CheckOutMainViewState extends State<CheckOutMainView> {
  final mainCheckOutViewModel = Get.put(MainCheckOutViewModel());

  _loadAllProducts() {
    mainCheckOutViewModel.fetchAllProducts();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAllProducts();
  }

  _performWalkInCustomerNavigation() {
    Get.toNamed(RouteName.walkInCustomerCheckOutView)?.then((value) {
      _loadAllProducts();
    });
  }

  _performLedgerRegisteredCustomerNavigation() {
    Get.toNamed(RouteName.ledgerInCustomerCheckOutView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Checkout Main Screen",
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
            const SizedBox(
              height: 20,
            ),
            Text(
              'Check-Out Main Menu',
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
            Obx(() {
              if (mainCheckOutViewModel.allProductsList.value.isEmpty) {
                return const Column(
                  children: [
                    CircularProgressIndicator(),
                    Text("Please Wait All Products are loading")
                  ],
                );
              } else {
                return Expanded(
                  child: ProductsListCheckOutWidget(
                      allProductsList:
                          mainCheckOutViewModel.allProductsList.value),
                );
              }
            }),
            const Divider(
              color: CustomAppColors.mainThemeColorBlueLogo,
            ),
            Text(
              "Select Customer Type",
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: _performWalkInCustomerNavigation,
              icon: const Icon(Icons.nordic_walking),
              label: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Walk In Customer",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton.icon(
              onPressed: _performLedgerRegisteredCustomerNavigation,
              icon: const Icon(Icons.app_registration),
              label: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Ledger Registered Customer",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
