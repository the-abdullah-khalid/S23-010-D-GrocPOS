import 'package:flutter/cupertino.dart';
import 'package:groc_pos_app/repository/expenses_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

class AddExpenseViewModel {
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  Future<bool> addNewExpense(
      BuildContext context, Map<String, dynamic> newExpenseData) async {
    try {
      bool status = await _expenseRepository.addNewExpense(newExpenseData);
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage(
            "New Expense Added Successfully", context);
      });

      return true;
    } catch (error) {
      debugPrint(error.toString());
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarErrorMessage(error.toString(), context);
      });
    }
    return false;
  }
}
