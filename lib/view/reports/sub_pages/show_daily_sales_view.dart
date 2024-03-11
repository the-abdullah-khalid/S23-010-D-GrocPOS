import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/no_data_message_widget.dart';
import 'package:groc_pos_app/view_model/reports/reports_main_view_model.dart';
import 'package:groc_pos_app/view_model/reports/show_daily_sales_view_model.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('dd/MM/yyyy');

class ShowDailySalesView extends StatefulWidget {
  const ShowDailySalesView({super.key});

  @override
  State<ShowDailySalesView> createState() => _ShowDailySalesViewState();
}

class _ShowDailySalesViewState extends State<ShowDailySalesView> {
  final showDailySalesViewModel = Get.put(ShowDailySalesViewModel());
  final reportsMainViewModelController = Get.find<ReportsMainViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showDailySalesViewModel.findAllTodayInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Sales Reports",
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
                  "Daily Sales Reports",
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
                    showDailySalesViewModel.findAllTodayInvoices();
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
                              "Today's Date  : ${DateFormat('dd/MM/yyyy').format(showDailySalesViewModel.todayDate.value)}",
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
                            "Total Sales of Today :\n ${showDailySalesViewModel.todaySalesAmount.toStringAsFixed(2)} /PKR",
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
                "Today's Transaction Brief",
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
                    if (showDailySalesViewModel.todaySalesInvoices.isEmpty) {
                      return const NoDataMessageWidget(
                        dataOf: "No Today Sales ",
                        message: "Please do some sales",
                      );
                    } else {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                children: [
                                  Text(
                                      "Customer Name : ${showDailySalesViewModel.todaySalesInvoices.value[index].customerName}"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Grand Total :${showDailySalesViewModel.todaySalesInvoices[index].grandTotal}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Discount %: ${showDailySalesViewModel.todaySalesInvoices[index].discountPercentage}"),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Sub Total :${showDailySalesViewModel.todaySalesInvoices[index].subTotal}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Amount Paid : ${showDailySalesViewModel.todaySalesInvoices[index].amountPaidByCustomer}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Total Items Purchased :${showDailySalesViewModel.todaySalesInvoices[index].productList.length}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount:
                            showDailySalesViewModel.todaySalesInvoices.length,
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
