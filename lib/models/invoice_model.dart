import 'package:groc_pos_app/models/product_model.dart';

class InvoiceModel {
  final double amountPaidByCustomer;
  final String billID;
  final double changeAmount;
  final String customerName;
  final String customerType;
  final DateTime invoiceDateTime;
  final double discountPercentage;
  final double grandTotal;
  final List<ProductModel> productList;
  final double subTotal;

  InvoiceModel(
      this.amountPaidByCustomer,
      this.billID,
      this.changeAmount,
      this.customerName,
      this.customerType,
      this.invoiceDateTime,
      this.discountPercentage,
      this.grandTotal,
      this.productList,
      this.subTotal);

  @override
  String toString() {
    return 'InvoiceModel{amountPaidByCustomer: $amountPaidByCustomer, billID: $billID, changeAmount: $changeAmount, customerName: $customerName, customerType: $customerType, invoiceDateTime: $invoiceDateTime, discountPercentage: $discountPercentage, grandTotal: $grandTotal, productList: $productList, subTotal: $subTotal}';
  }
}
