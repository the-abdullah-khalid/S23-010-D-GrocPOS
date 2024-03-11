import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/invoice_model.dart';
import 'package:groc_pos_app/view_model/reports/reports_main_view_model.dart';

class ShowMonthlySalesViewModel extends GetxController {
  final reportsMainViewModelController = Get.find<ReportsMainViewModel>();

  final monthlySalesInvoices = <InvoiceModel>[].obs;
  RxDouble monthlyAmount = 0.0.obs;
  final todayDate = DateTime.now().obs;

  findAllMonthlyInvoices() {
    debugPrint(" - ${todayDate.value}");

    for (InvoiceModel invoice
        in reportsMainViewModelController.allInvoicesList) {
      debugPrint(" - ${invoice.toString()}");

      if (todayDate.value.month == invoice.invoiceDateTime.month) {
        monthlySalesInvoices.add(invoice);
      }
    }
    debugPrint("monthlySalesInvoices - ${monthlySalesInvoices.length}");

    computeMonthlySales();
  }

  computeMonthlySales() {
    for (InvoiceModel todayInvoice in monthlySalesInvoices) {
      monthlyAmount.value += todayInvoice.grandTotal;
    }
  }
}
