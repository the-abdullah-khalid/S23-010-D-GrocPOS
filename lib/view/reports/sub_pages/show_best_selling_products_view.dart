import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view_model/reports/show_best_selling_products_view_model.dart';

class ShowBestSellingProductsView extends StatefulWidget {
  const ShowBestSellingProductsView({super.key});

  @override
  State<ShowBestSellingProductsView> createState() =>
      _ShowBestSellingProductsViewState();
}

class _ShowBestSellingProductsViewState
    extends State<ShowBestSellingProductsView> {
  final showBestSellingProductsModel =
      Get.put(ShowBestSellingProductsViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showBestSellingProductsModel.findBestSellingProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Sales of Products",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Sells of Each Products",
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
              SizedBox(
                width: 300,
                child: InkWell(
                  onTap: () {
                    showBestSellingProductsModel.findBestSellingProducts();
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.production_quantity_limits),
                          SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Total Number of Products in the shop",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => Text(
                              showBestSellingProductsModel
                                  .reportsMainViewModelController
                                  .allProductsList
                                  .value
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Text(
                "List of All Products With Their Number of Sales In the Receipts",
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
              SizedBox(
                height: 500,
                child: Obx(() {
                  if (showBestSellingProductsModel
                      .bestSellingProductsList.value.isEmpty) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.connected_tv),
                        Text("No Product Sales In the Receipts"),
                        Text("Do some sales first and then come back here"),
                      ],
                    );
                  } else {
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          debugPrint(index.toString());
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "Product Details Are: ",
                                    style: GoogleFonts.getFont(
                                      AppFontsNames.kBodyFont,
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    (showBestSellingProductsModel
                                                .bestSellingProductsList[index]
                                            ['product_details'] as ProductModel)
                                        .productName,
                                    textAlign: TextAlign.center,
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
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("Total Number of Sales :"),
                                      Text(
                                        "${showBestSellingProductsModel.bestSellingProductsList[index]['number_of_occurances_in_recipts']} ",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: showBestSellingProductsModel
                            .bestSellingProductsList.value.length);
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
