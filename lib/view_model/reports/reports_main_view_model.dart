import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/expense_model.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/repository/expenses_repository.dart';
import 'package:groc_pos_app/repository/invoice_repository.dart';
import 'package:groc_pos_app/repository/product_repository.dart';
import 'package:groc_pos_app/utils/utils.dart';

import '../../models/invoice_model.dart';

class ReportsMainViewModel extends GetxController {
  final ProductRepository _productRepository = ProductRepository();
  final InvoiceRepository _invoiceRepository = InvoiceRepository();
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  // final allProductsList = <ProductModel>[].obs;
  final allInvoicesList = <InvoiceModel>[].obs;
  final allExpensesList = <ExpenseModel>[].obs;
  Rx<List<ProductModel>> allProductsList = Rx<List<ProductModel>>([]);

  fetchAllProducts() async {
    try {
      CollectionReference<Map<String, dynamic>> productsCollectionReference =
          _productRepository.fetchAllProducts();

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await productsCollectionReference.get();

      // Loop through the documents to extract data
      final List<ProductModel> allProductsModels = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        Map<String, dynamic> data = document.data();

        // Access your data here
        ProductModel newProduct = ProductModel(
            productBarcode: data["product_barcode"],
            productBrand: data["product_brand"],
            productCategory: data["product_category"],
            productId: data["product_id"],
            productManufactureName: data["product_manufacturer_name"],
            productMrp: double.parse(data["product_mrp"]),
            productPurchasePrice: double.parse(data["product_purchase_price"]),
            productName: data["product_name"],
            productStock: int.parse(data["product_stock"]),
            productUnit: data["product_unit"],
            productExpiryDate: data["expiry_date"]);
        allProductsModels.add(newProduct);
      }
      if (allProductsModels.isNotEmpty) {
        allProductsList.value = allProductsModels;
        debugPrint(
            "all products list - ${allProductsList.value.length.toString()}");
        AppUtils.snakBarSucessGetX(
            "Products Loading Status", "All Products Loaded Successfully", 1);
      }
    } catch (error) {
      debugPrint(error.toString());
      AppUtils.snakBarErrorGetX("Products Loading Status",
          "All Products Loading Failure ${error.toString()}", 5);
    }
  }

  fetchAllInvoices() async {
    try {
      CollectionReference<Map<String, dynamic>> invoicesCollectionReference =
          _invoiceRepository.fetchAllInvoices();

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await invoicesCollectionReference.get();

      // Loop through the documents to extract data
      final List<InvoiceModel> allInvoicesInShop = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        Map<String, dynamic> data = document.data();

        List<dynamic> productsList = data['products-list'];
        List<ProductModel> allProductsInTheInvoice = [];

        for (Map<String, dynamic> productMap in productsList) {
          allProductsInTheInvoice.add(ProductModel.fromMap(productMap));
        }

        Timestamp invoiceTimeStamp = data['date-time'] as Timestamp;

        debugPrint(data['discount-percentage'].runtimeType.toString());
        debugPrint(data['discount-percentage'].runtimeType.toString());
        debugPrint(data['discount-percentage'].runtimeType.toString());
        debugPrint(data['grand-total'].runtimeType.toString());
        debugPrint(data['sub-total'].runtimeType.toString());
        InvoiceModel newInvoiceModel = InvoiceModel(
          double.parse(data['amount-paid-by-customer'].toString()),
          data['bill-id'],
          data['change-amount'],
          data['customer-name'],
          data['customer-type'],
          invoiceTimeStamp.toDate(),
          double.parse(data['discount-percentage'].toString()),
          double.parse(data['grand-total'].toString()),
          allProductsInTheInvoice,
          double.parse(data['sub-total'].toString()),
        );

        allInvoicesInShop.add(newInvoiceModel);
        allInvoicesList.add(newInvoiceModel);
      }
      // if (allInvoicesInShop.isNotEmpty) {
      //   allInvoicesList.value = allInvoicesInShop;
      //   debugPrint(
      //       "all invoices list - ${allInvoicesList.value.length.toString()}");
      //
      //   AppUtils.snakBarSucessGetX(
      //       "Invoices Loading Status", "All Invoices Loaded Successfully", 1);
      // }
      if (allInvoicesList.isNotEmpty) {
        debugPrint(
            "all invoices list - ${allInvoicesList.value.length.toString()}");

        AppUtils.snakBarSucessGetX(
            "Invoices Loading Status", "All Invoices Loaded Successfully", 1);
      }
    } catch (error) {
      error.printError();
      error.printInfo();
      debugPrint(error.toString());
      AppUtils.snakBarErrorGetX("Products Loading Status",
          "All Invoices Loading Failure ${error.toString()}", 5);
    }
  }

  fetchAllExpenses() async {
    try {
      CollectionReference<Map<String, dynamic>> expenseCollectionReference =
          _expenseRepository.fetchAllExpenses();

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await expenseCollectionReference.get();

      // Loop through the documents to extract data
      final List<ExpenseModel> allExpensesModels = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        Map<String, dynamic> data = document.data();
        // debugPrint(" - ${document.id}");

        // Access your data here
        ExpenseModel newExpense = ExpenseModel(
            expenseAmount: data['expense-amount'],
            expenseCategory: data['expense-category'],
            expenseDate: data['expense-date'],
            expenseNote: data['expense-note'],
            expenseTitle: data['expense-title'],
            expenseID: document.id);

        allExpensesModels.add(newExpense);
      }
      if (allExpensesModels.isNotEmpty) {
        allExpensesList.value = allExpensesModels;
        debugPrint(
            "all expenses list - ${allExpensesList.value.length.toString()}");
        AppUtils.snakBarSucessGetX(
            "Expense Loading Status", "All Expenses Loaded Successfully", 1);
      }
    } catch (error) {
      debugPrint(error.toString());
      AppUtils.snakBarErrorGetX("Expenses Loading Status",
          "All Expenses Loading Failure ${error.toString()}", 5);
    }
  }
}
