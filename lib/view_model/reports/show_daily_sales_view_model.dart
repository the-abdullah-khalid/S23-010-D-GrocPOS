import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/invoice_model.dart';

import 'reports_main_view_model.dart';

class ShowDailySalesViewModel extends GetxController {
  final reportsMainViewModelController = Get.find<ReportsMainViewModel>();

  final todaySalesInvoices = <InvoiceModel>[].obs;
  RxDouble todaySalesAmount = 0.0.obs;
  final todayDate = DateTime.now().obs;

  findAllTodayInvoices() {
    for (InvoiceModel invoice
        in reportsMainViewModelController.allInvoicesList) {
      debugPrint(" - ${invoice.toString()}");

      if (todayDate.value.day == invoice.invoiceDateTime.day &&
          todayDate.value.month == invoice.invoiceDateTime.month &&
          todayDate.value.year == invoice.invoiceDateTime.year) {
        todaySalesInvoices.add(invoice);
      }
    }
    debugPrint("findAllTodayInvoices - ${todaySalesInvoices.length}");

    computeDailySales();
  }

  computeDailySales() {
    for (InvoiceModel todayInvoice in todaySalesInvoices) {
      todaySalesAmount.value += todayInvoice.grandTotal;
    }
  }
}
