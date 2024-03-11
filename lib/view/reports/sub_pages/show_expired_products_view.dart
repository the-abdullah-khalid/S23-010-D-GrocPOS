import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/no_data_message_widget.dart';
import 'package:groc_pos_app/view_model/reports/show_expired_products_view_model.dart';
import 'package:intl/intl.dart';

class ShowExpiredProductsView extends StatefulWidget {
  const ShowExpiredProductsView({super.key});

  @override
  State<ShowExpiredProductsView> createState() =>
      _ShowExpiredProductsViewState();
}

class _ShowExpiredProductsViewState extends State<ShowExpiredProductsView> {
  final showExpiredProductViewModel = Get.put(ShowExpiredProductsViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showExpiredProductViewModel.findAllExpiredProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Expired Products Report",
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
                  "Expired Products Report",
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
                    showExpiredProductViewModel.findAllExpiredProducts();
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.production_quantity_limits),
                          Obx(
                            () => Text(
                              "Today's Date  : ${DateFormat('dd/MM/yyyy').format(showExpiredProductViewModel.todayDate.value)}",
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
              SizedBox(
                width: 300,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.price_change),
                        Obx(
                          () => Text(
                            "Total Expired ${showExpiredProductViewModel.expiredProductsList.length}",
                            textAlign: TextAlign.center,
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
              const Divider(),
              Text(
                "List of All The Expired Products In the Inventory",
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
                    if (showExpiredProductViewModel
                        .expiredProductsList.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.connected_tv),
                          Text("No Product Expired Yet"),
                          Text(
                              "All Your Products have not passed Expiry Dates"),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          //---------------- expiry date format ----------------
                          DateTime expirationDate = DateFormat('MM/dd/yyyy')
                              .parse(showExpiredProductViewModel
                                  .expiredProductsList[index]
                                  .productExpiryDate);

                          return InkWell(
                            onTap: () {},
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      showExpiredProductViewModel
                                          .expiredProductsList[index]
                                          .productName,
                                      style: GoogleFonts.getFont(
                                        AppFontsNames.kBodyFont,
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month),
                                            const SizedBox(width: 5),
                                            Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(expirationDate),
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          showExpiredProductViewModel
                                              .expiredProductsList[index]
                                              .productCategory,
                                        ),
                                        Text(
                                          "MRP : ${showExpiredProductViewModel.expiredProductsList[index].productMrp}",
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: showExpiredProductViewModel
                            .expiredProductsList.length,
                      );
                    }
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
