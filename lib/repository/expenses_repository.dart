import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groc_pos_app/data/network/firebase_backend_service.dart';

class ExpenseRepository {
  final FirebaseApiService _firebaseApiService = FirebaseApiService();

  Future<bool> addNewExpense(Map<String, dynamic> newExpenseDetails) async {
    try {
      bool status = await _firebaseApiService.addNewExpense(newExpenseDetails);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> fetchAllExpenses() {
    try {
      CollectionReference<Map<String, dynamic>>
          fetchAllExpensesCollectionReference =
          _firebaseApiService.fetchAllExpenses();
      return fetchAllExpensesCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteExpense(Map<String, dynamic> deleteProductDetails) async {
    try {
      bool status =
          await _firebaseApiService.deleteExpense(deleteProductDetails);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> editExpenseDetails(
      Map<String, dynamic> editedExpenseDetails) async {
    try {
      bool status =
          await _firebaseApiService.editExpenseDetails(editedExpenseDetails);
      return true;
    } catch (error) {
      rethrow;
    }
  }
}
