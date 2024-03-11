import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:groc_pos_app/utils/utils.dart';

import '../../repository/expenses_repository.dart';

class ManageExpenseViewModel {
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllExpenses() {
    try {
      CollectionReference<Map<String, dynamic>> expenseCollectionReference =
          _expenseRepository.fetchAllExpenses();
      return expenseCollectionReference.snapshots();
    } catch (error) {
      debugPrint(error.toString());
      return const Stream.empty();
    }
  }

  Future<bool> removeExpense(
      Map<String, dynamic> deleteExpenseDetails, BuildContext context) async {
    try {
      bool status =
          await _expenseRepository.deleteExpense(deleteExpenseDetails);
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarSucessMessage("expense Deleted", context);
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
