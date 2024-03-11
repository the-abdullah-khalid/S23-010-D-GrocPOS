import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/repository/shop_repository.dart';

class PieChartViewModel extends GetxController {
  final ShopRepository shopRepository = ShopRepository();
  final allExpensesList = [].obs;
  final totalExpense = 0.0.obs;

  fetchAllExpensesData() {
    final documents = shopRepository.fetchAllShopExpenses();
    documents.then((value) {
      allExpensesList.value = value;
    });
  }

  setTotalExpenses(double totalAmount) {
    totalExpense.value = totalAmount;
  }
}
