class LedgerCustomerModel {
  final String customerName;
  final String customerCNIC;
  final String customerPhoneNUmber;
  final String customerTotalAmountDue;
  final String customerAddress;
  final String customerID;

  LedgerCustomerModel({
    required this.customerName,
    required this.customerCNIC,
    required this.customerPhoneNUmber,
    required this.customerTotalAmountDue,
    required this.customerAddress,
    required this.customerID,
  });

  toJson() {
    return {
      "customerName": customerName,
      "customerCNIC": customerCNIC,
      "customerPhoneNUmber": customerPhoneNUmber,
      "customerTotalAmountDue": customerTotalAmountDue,
      "customerAddress": customerAddress,
      "customerID": customerID,
    };
  }
}
