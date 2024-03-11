import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view_model/reports/show_stocks_report_view_model.dart';

class ShowStocksReportsView extends StatefulWidget {
  const ShowStocksReportsView({super.key});

  @override
  State<ShowStocksReportsView> createState() => _ShowStocksReportsViewState();
}

class _ShowStocksReportsViewState extends State<ShowStocksReportsView> {
  final showStockReportViewModel = Get.put(ShowStockReportsViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Stocks Reports",
            style: GoogleFonts.getFont(AppFontsNames.kBodyFont,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                "Stocks Reports",
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
              height: 10,
            ),
            const Text(
              "Green Color Means Stock Greater than 25 Units",
              style: TextStyle(color: Colors.green),
            ),
            const Text(
              "Red Color Means Stock Greater than 25 Units",
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 1000,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  int currentStockIntValue = showStockReportViewModel
                      .fetchAllProductsList()[index]
                      .productStock;
                  bool isStockLow = currentStockIntValue < 20;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            showStockReportViewModel
                                .fetchAllProductsList()[index]
                                .productName,
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
                              Text(showStockReportViewModel
                                  .fetchAllProductsList()[index]
                                  .productCategory),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  isStockLow
                                      ? const Icon(
                                          Icons.arrow_downward,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.arrow_upward,
                                          color: Colors.green,
                                        ),
                                  Text(
                                    "Stock : ${showStockReportViewModel.fetchAllProductsList()[index].productStock} : ${showStockReportViewModel.fetchAllProductsList()[index].productUnit.toString()} ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: isStockLow
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount:
                    showStockReportViewModel.fetchAllProductsList().length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
