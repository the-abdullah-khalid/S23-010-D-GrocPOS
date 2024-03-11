class ExpenseModel {
  final String expenseAmount;
  final String expenseCategory;
  final String expenseDate;
  final String expenseNote;
  final String expenseTitle;
  final String expenseID;

  ExpenseModel({
    required this.expenseAmount,
    required this.expenseCategory,
    required this.expenseDate,
    required this.expenseNote,
    required this.expenseTitle,
    required this.expenseID,
  });

  toJson() {
    return {
      "expenseAmount": expenseAmount,
      "expenseCategory": expenseCategory,
      "expenseDate": expenseDate,
      "expenseNote": expenseNote,
      "expenseTitle": expenseTitle,
      "expenseID": expenseID,
    };
  }

  @override
  String toString() {
    return 'ExpenseModel{expenseAmount: $expenseAmount, expenseCategory: $expenseCategory, expenseDate: $expenseDate, expenseNote: $expenseNote, expenseTitle: $expenseTitle, expenseID: $expenseID}';
  }
}
