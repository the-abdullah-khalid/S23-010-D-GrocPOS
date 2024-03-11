import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view_model/reports/show_all_products_which_are_about_to_expire_in_one_week_view_model.dart';
import 'package:intl/intl.dart';

class ShowAllProuductsWhichAreAboutToExpireInOneWeekView
    extends StatefulWidget {
  const ShowAllProuductsWhichAreAboutToExpireInOneWeekView({super.key});

  @override
  State<ShowAllProuductsWhichAreAboutToExpireInOneWeekView> createState() =>
      _ShowAllProuductsWhichAreAboutToExpireInOneWeekViewState();
}

class _ShowAllProuductsWhichAreAboutToExpireInOneWeekViewState
    extends State<ShowAllProuductsWhichAreAboutToExpireInOneWeekView> {
  final showAllProductsWhichAreAboutToExpireInOneWeekViewModel =
      Get.put(ShowAllProductWhichAreAboutToExpireInOneWeekViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showAllProductsWhichAreAboutToExpireInOneWeekViewModel
        .findProductsExpiringWithin7Days();
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
                    showAllProductsWhichAreAboutToExpireInOneWeekViewModel
                        .findProductsExpiringWithin7Days();
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
                              "Today's Date  : ${DateFormat('dd/MM/yyyy').format(showAllProductsWhichAreAboutToExpireInOneWeekViewModel.todayDate.value)}",
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
                            "Total Products Getting \nExpired In One Week \n${showAllProductsWhichAreAboutToExpireInOneWeekViewModel.productsExpiringInAWeekList.length}",
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
                "List of All The Expired Products \nWhich Are Going To Be Expired In One Week",
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
                child: Obx(
                  () {
                    if (showAllProductsWhichAreAboutToExpireInOneWeekViewModel
                        .productsExpiringInAWeekList.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.connected_tv),
                          Text("No Product Expired Near\n One Week Expiry"),
                          Text(
                              "All Your Products have not passed Expiry Dates"),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          //---------------- expiry date format ----------------
                          DateTime expirationDate = DateFormat('MM/dd/yyyy').parse(
                              showAllProductsWhichAreAboutToExpireInOneWeekViewModel
                                  .productsExpiringInAWeekList[index]
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
                                      showAllProductsWhichAreAboutToExpireInOneWeekViewModel
                                          .productsExpiringInAWeekList[index]
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
                                          showAllProductsWhichAreAboutToExpireInOneWeekViewModel
                                              .productsExpiringInAWeekList[
                                                  index]
                                              .productCategory,
                                        ),
                                        Text(
                                          "MRP : ${showAllProductsWhichAreAboutToExpireInOneWeekViewModel.productsExpiringInAWeekList[index].productMrp}",
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount:
                            showAllProductsWhichAreAboutToExpireInOneWeekViewModel
                                .productsExpiringInAWeekList.length,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
