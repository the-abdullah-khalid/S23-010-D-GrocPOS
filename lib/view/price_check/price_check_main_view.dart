import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/view/checkout/widget/products_list_checkout_widget.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';
import 'package:groc_pos_app/view_model/price_check/price_check_main_view_model.dart';

class PriceCheckMainView extends StatefulWidget {
  const PriceCheckMainView({super.key});

  @override
  State<PriceCheckMainView> createState() => _PriceCheckMainViewState();
}

class _PriceCheckMainViewState extends State<PriceCheckMainView> {
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

  _performOpenPriceCheckFunctionality() {
    Get.toNamed(RouteName.openPriceCheckFunctionality);
  }

  _performLedgerRegisteredCustomerNavigation() {}

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
              onPressed: _performOpenPriceCheckFunctionality,
              icon: const Icon(Icons.search),
              label: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Open Price Check Functionality",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
