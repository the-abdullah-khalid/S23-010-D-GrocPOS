import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/expense_model.dart';
import 'package:groc_pos_app/models/invoice_model.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/view_model/reports/reports_main_view_model.dart';

class ShowSalesVsProfiteViewModel extends GetxController {
  final reportsMainViewModelController = Get.find<ReportsMainViewModel>();
  RxDouble totalSalesAmount = 0.0.obs;
  RxDouble totalPurchasePrice = 0.0.obs;
  RxDouble totalShopExpenses = 0.0.obs;
  RxDouble totalProfit = 0.0.obs;
  RxBool isShopInProfit = false.obs;

  findTotalSalesAmount() {
    double totalSales = 0;
    for (InvoiceModel invoice
        in reportsMainViewModelController.allInvoicesList) {
      totalSales += invoice.grandTotal;
    }
    totalSalesAmount.value = totalSales;
  }

  findTotalPurchasePrice() {
    double totalPurchasePriceOverInvoice = 0;
    for (InvoiceModel invoice
        in reportsMainViewModelController.allInvoicesList) {
      for (ProductModel productInInvoice in invoice.productList) {
        totalPurchasePriceOverInvoice += productInInvoice.productPurchasePrice;
      }
    }
    totalPurchasePrice.value = totalPurchasePriceOverInvoice;
  }

  findTotalShopExpenses() {
    double allShopExpenses = 0.0;
    for (ExpenseModel shopExpense
        in reportsMainViewModelController.allExpensesList) {
      allShopExpenses += double.parse(shopExpense.expenseAmount);
    }
    totalShopExpenses.value = allShopExpenses;
  }

  computeProfit() {
    // totalProfit.value = (totalSalesAmount.value -
    //         totalPurchasePrice.value -
    //         totalShopExpenses.value)
    //     .abs();

    // totalProfit.value =
    //     (totalSalesAmount.value - totalPurchasePrice.value - 0).abs();
    //
    // isShopInProfit.value = totalProfit.value > (totalPurchasePrice.value + 0);

    // isShopInProfit.value =
    //     totalProfit.value > (totalSalesAmount.value + totalShopExpenses.value);

    totalProfit.value = (totalSalesAmount.value - totalShopExpenses.value - 0);

    debugPrint(" - ${totalProfit.value}");

    isShopInProfit.value = totalProfit.value >
        (totalSalesAmount.value - totalShopExpenses.value - 0);

    if (totalProfit.value < 0) {
      totalProfit.value = 0;
      isShopInProfit.value = false;
    }
  }
}
