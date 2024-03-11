import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view_model/reports/reports_main_view_model.dart';

import '../../resources/routes/routes_name.dart';

class ReportsMainView extends StatefulWidget {
  const ReportsMainView({super.key});

  @override
  State<ReportsMainView> createState() => _ReportsMainViewState();
}

class _ReportsMainViewState extends State<ReportsMainView> {
  _getThreeBestSellingProductsOfTheShop() {}
  _showAllDailySales() {
    Get.toNamed(RouteName.showDailySalesView);
  }

  _showAllMonthlySales() {
    Get.toNamed(RouteName.showMonthlySalesView);
  }

  _showExpiredProducts() {
    Get.toNamed(RouteName.showExpiredProductsView);
  }

  _showSalesVsProfit() {
    Get.toNamed(RouteName.salesVsProfitView);
  }

  _showStockReports() {
    Get.toNamed(RouteName.showStockReportsView);
  }

  _showBestSellingProducts() {
    Get.toNamed(RouteName.showBestSellingProducts);
  }

  _showAllProductsExpiryInOneWeek() {
    Get.toNamed(RouteName.showAllProductsWhichAreAboutToExpireOneWeekView);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reportsMainViewModelController.fetchAllProducts();
    reportsMainViewModelController.fetchAllInvoices();
    reportsMainViewModelController.fetchAllExpenses();
  }

  final reportsMainViewModelController = Get.put(ReportsMainViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "All Store Reports",
            style: GoogleFonts.getFont(AppFontsNames.kBodyFont,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  "Store Reports",
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
                height: 15,
              ),
              InkWell(
                onTap: _showAllDailySales,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Icon(Icons.money_rounded),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Show Daily Sales",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: _showAllMonthlySales,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Icon(Icons.money),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Show Monthly Sales",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: _showExpiredProducts,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Icon(Icons.hourglass_bottom),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Show Expired\nProducts",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: _showSalesVsProfit,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Icon(Icons.production_quantity_limits),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Sales Vs Profit",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: _showStockReports,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Icon(Icons.stacked_bar_chart),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Show Stocks Reports",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: _showBestSellingProducts,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Icon(Icons.bar_chart),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Best Selling Products",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: _showAllProductsExpiryInOneWeek,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Icon(Icons.bar_chart),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "1 Week Before \nExpiry Products",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
