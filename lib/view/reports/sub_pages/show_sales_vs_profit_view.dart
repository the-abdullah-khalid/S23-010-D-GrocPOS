import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view_model/reports/show_sales_vs_profit_view_model.dart';

class ShowSalesVsProfitView extends StatefulWidget {
  const ShowSalesVsProfitView({super.key});

  @override
  State<ShowSalesVsProfitView> createState() => _ShowSalesVsProfitViewState();
}

class _ShowSalesVsProfitViewState extends State<ShowSalesVsProfitView> {
  final showSalesVsProfitViewModel = Get.put(ShowSalesVsProfiteViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showSalesVsProfitViewModel.findTotalShopExpenses();
    showSalesVsProfitViewModel.findTotalPurchasePrice();
    showSalesVsProfitViewModel.findTotalSalesAmount();
    showSalesVsProfitViewModel.computeProfit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Sales Vs Profit",
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
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Sales Vs Profit",
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
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text(
                            "Total Sales Amount",
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
                            height: 20,
                          ),
                          Text(
                            "${showSalesVsProfitViewModel.totalSalesAmount.value} PKR",
                            style: GoogleFonts.getFont(
                              AppFontsNames.kBodyFont,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text(
                            "Total Purchase Amount \n (Amount Spend On Buying Products)",
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
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${showSalesVsProfitViewModel.totalPurchasePrice.value} PKR",
                            style: GoogleFonts.getFont(
                              AppFontsNames.kBodyFont,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text(
                            "Total Shop Expenses\n(Amount Paid To Suppliers, Shop Bills Etc)",
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
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${showSalesVsProfitViewModel.totalShopExpenses.value} PKR",
                            style: GoogleFonts.getFont(
                              AppFontsNames.kBodyFont,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text(
                            "Total Profit",
                            style: GoogleFonts.getFont(
                              color: showSalesVsProfitViewModel
                                      .isShopInProfit.value
                                  ? Colors.green
                                  : Colors.red,
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
                            height: 20,
                          ),
                          Text(
                            "${showSalesVsProfitViewModel.totalProfit.value} PKR",
                            style: GoogleFonts.getFont(
                              AppFontsNames.kBodyFont,
                              color: showSalesVsProfitViewModel
                                      .isShopInProfit.value
                                  ? Colors.green
                                  : Colors.red,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff246bdd),
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
