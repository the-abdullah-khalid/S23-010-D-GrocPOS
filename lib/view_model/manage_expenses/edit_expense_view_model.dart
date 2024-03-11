import 'package:flutter/material.dart';
import 'package:groc_pos_app/repository/expenses_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class EditExpenseViewModel {
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  Future<bool> editExpenseDetails(
      Map<String, dynamic> editProductDetails, BuildContext context) async {
    try {
      bool status =
          await _expenseRepository.editExpenseDetails(editProductDetails);

      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage("Expense Edited Successfully", context);
      });

      return true;
    } catch (error) {
      debugPrint(error.toString());
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarErrorMessage(error.toString(), context);
      });

      return false;
    }
  }
}
