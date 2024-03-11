import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/no_data_message_widget.dart';
import 'package:groc_pos_app/view_model/reports/show_monthly_sales_view_model.dart';
import 'package:intl/intl.dart';

import '../../checkout/sub_pages/ledger_customer_checkout/sub_pages/add_new_purchase_in_ledger_view.dart';

class ShowMonthlySalesView extends StatefulWidget {
  const ShowMonthlySalesView({super.key});

  @override
  State<ShowMonthlySalesView> createState() => _ShowMonthlySalesViewState();
}

class _ShowMonthlySalesViewState extends State<ShowMonthlySalesView> {
  final showMonthlySalesViewModel = Get.put(ShowMonthlySalesViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMonthlySalesViewModel.findAllMonthlyInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Monthly Sales Reports",
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
                  "Monthly Sales Reports",
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
                    showMonthlySalesViewModel.findAllMonthlyInvoices();
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
                              "Today's Date  : ${DateFormat('dd/MM/yyyy').format(showMonthlySalesViewModel.todayDate.value)}",
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
                            "Total Sales of ${DateFormat('MMMM').format(showMonthlySalesViewModel.todayDate.value)} :\n ${showMonthlySalesViewModel.monthlyAmount.toStringAsFixed(2)} /PKR",
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
                "Monthly's Sales Receipts\nTransaction Brief",
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
                    if (showMonthlySalesViewModel
                        .monthlySalesInvoices.isEmpty) {
                      return const NoDataMessageWidget(
                        dataOf: "No Monthly Sales ",
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
                                      "Customer Name : ${showMonthlySalesViewModel.monthlySalesInvoices.value[index].customerName}"),
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
                                              "Grand Total :${showMonthlySalesViewModel.monthlySalesInvoices[index].grandTotal}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Discount %: ${showMonthlySalesViewModel.monthlySalesInvoices[index].discountPercentage}"),
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
                                              "Sub Total :${showMonthlySalesViewModel.monthlySalesInvoices[index].subTotal}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Amount Paid : ${showMonthlySalesViewModel.monthlySalesInvoices[index].amountPaidByCustomer}"),
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
                                              "Total Items Purchased :${showMonthlySalesViewModel.monthlySalesInvoices[index].productList.length}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: showMonthlySalesViewModel
                            .monthlySalesInvoices.length,
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
