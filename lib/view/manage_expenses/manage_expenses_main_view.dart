import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';
import 'package:groc_pos_app/models/expense_model.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/resources/widgets_components/no_data_message_widget.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view/manage_expenses/widgets/shop_expenses_pie_chart.dart';
import 'package:groc_pos_app/view_model/manage_expenses/pie_chart_controller.dart';
import '../../resources/colors/app_colors.dart';
import '../../view_model/manage_expenses/manage_expenses_view_model.dart';

class ManageExpensesView extends StatefulWidget {
  const ManageExpensesView({super.key});

  @override
  State<ManageExpensesView> createState() => _ManageExpensesViewState();
}

class _ManageExpensesViewState extends State<ManageExpensesView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>>?
      _expenseCollectionReferenceStream;

  final List<dynamic> allShopExpensesList = [];
  _addNewExpense() async {
    print("Hello");
    final result = await Get.toNamed(RouteName.addNewExpenseView);
    if (result != null) {
      debugPrint(" back from add expense- ");
      final controller = Get.find<PieChartViewModel>();
      controller.fetchAllExpensesData();
    }
  }

  _loadAllExpenses() {
    debugPrint("load all expenses");
    _expenseCollectionReferenceStream =
        ManageExpenseViewModel().fetchAllExpenses();

    if (_expenseCollectionReferenceStream == const Stream.empty()) {
      AppUtils.errorDialog(context, "Something went wrong while fetching",
          "Please try again something went wrong while fetching the products details");
      return;
    } else {
      debugPrint(_expenseCollectionReferenceStream.toString());
    }
  }

  _performEditExpense(ExpenseModel editedExpense) async {
    if (editedExpense == null) {
      AppUtils.errorDialog(
          context, "Expense Edit", "Something went wrong please try again");
      return;
    } else {
      bool result = await Get.toNamed(RouteName.editExpenseView,
          arguments: {'expense_details': editedExpense});
      if (result != null) {
        final controller = Get.find<PieChartViewModel>();
        controller.fetchAllExpensesData();
      }
    }
  }

  _performDeleteExpense(ExpenseModel deleteExpense) async {
    if (deleteExpense == null) {
      AppUtils.errorDialog(
          context, "Product Delete", "Something went wrong please try again");
      return;
    } else {
      final expenseDetails = {
        "expense_amount": deleteExpense.expenseAmount,
        "expense_category": deleteExpense.expenseCategory,
        "expense_date": deleteExpense.expenseDate,
        "expense_note": deleteExpense.expenseNote,
        "expense_title": deleteExpense.expenseTitle,
        "expense_id": deleteExpense.expenseID,
      };
      bool status =
          await ManageExpenseViewModel().removeExpense(expenseDetails, context);
      if (status) {
        final controller = Get.find<PieChartViewModel>();
        controller.fetchAllExpensesData();
      } else {
        Future.delayed(Duration.zero, () {
          AppUtils.errorDialog(context, "Product Delete Failure",
              "Something went wrong please try again");
        });
        return;
      }
    }
  }

  bool showPieChart = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  showPieChart = !showPieChart;
                });
              },
              icon: const Icon(Icons.bar_chart),
            ),
          ],
          title: Center(
            child: Text(
              "Manage Store Expenses",
              style: GoogleFonts.getFont(AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Text(
              "Shop Expenses",
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff246bdd),
                  letterSpacing: .5,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Card(
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: ShopExpensesPieChart(),
                ),
              ),
            ),
            Text(
              "All Shop Expenses",
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: .5,
                ),
              ),
            ),
            StreamBuilder(
              stream: _expenseCollectionReferenceStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  AppUtils.flushBarErrorMessage(
                      "Some Error While Fetching Data", context);
                  return const Text('Some Error While Fetching Data');
                }
                // print(snapshot.data!.docs.length.toString());
                if (snapshot.connectionState == ConnectionState.done) {
                  AppUtils.snakBar("All Expenses Loaded", context);
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const NoDataMessageWidget(dataOf: "Expenses");
                }

                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];

                      // debugPrint(snapshot.data!.docs[index].data().toString());
                      // debugPrint(snapshot.data!.docs[index].id.toString());

                      return Dismissible(
                        key: ValueKey(
                            snapshot.data!.docs[index].reference.toString()),
                        onDismissed: (direction) {
                          ExpenseModel expenseModel = ExpenseModel(
                              expenseAmount: snapshot
                                  .data!
                                  .docs[index]
                                      [ExpenseDatabaseFieldNames.expenseAmount]
                                  .toString(),
                              expenseCategory:
                                  snapshot.data!.docs[index][ExpenseDatabaseFieldNames.expenseCategory]
                                      .toString(),
                              expenseDate: snapshot
                                  .data!
                                  .docs[index]
                                      [ExpenseDatabaseFieldNames.expenseDate]
                                  .toString(),
                              expenseNote: snapshot
                                  .data!
                                  .docs[index]
                                      [ExpenseDatabaseFieldNames.expenseNote]
                                  .toString(),
                              expenseTitle: snapshot
                                  .data!
                                  .docs[index]
                                      [ExpenseDatabaseFieldNames.expenseTitle]
                                  .toString(),
                              expenseID: snapshot.data!.docs[index].id.toString());

                          debugPrint(" diminshed tilte - $expenseModel");
                          _performDeleteExpense(expenseModel);
                        },
                        child: InkWell(
                          onTap: () {
                            ExpenseModel expenseModel = ExpenseModel(
                                expenseAmount:
                                    snapshot.data!.docs[index][ExpenseDatabaseFieldNames.expenseAmount]
                                        .toString(),
                                expenseCategory:
                                    snapshot.data!.docs[index][ExpenseDatabaseFieldNames.expenseCategory]
                                        .toString(),
                                expenseDate: snapshot
                                    .data!
                                    .docs[index]
                                        [ExpenseDatabaseFieldNames.expenseDate]
                                    .toString(),
                                expenseNote: snapshot
                                    .data!
                                    .docs[index]
                                        [ExpenseDatabaseFieldNames.expenseNote]
                                    .toString(),
                                expenseTitle: snapshot
                                    .data!
                                    .docs[index]
                                        [ExpenseDatabaseFieldNames.expenseTitle]
                                    .toString(),
                                expenseID:
                                    snapshot.data!.docs[index].id.toString());

                            debugPrint(" diminshed tilte - $expenseModel");
                            _performEditExpense(expenseModel);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot
                                          .data!
                                          .docs[index][ExpenseDatabaseFieldNames
                                              .expenseTitle]
                                          .toString(),
                                      style: GoogleFonts.getFont(
                                        AppFontsNames.kBodyFont,
                                        textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text("Expense Amount:"),
                                            Text(
                                              snapshot.data!.docs[index][
                                                  ExpenseDatabaseFieldNames
                                                      .expenseAmount],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text("Date: "),
                                            Text(
                                              snapshot.data!.docs[index][
                                                  ExpenseDatabaseFieldNames
                                                      .expenseDate],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text("Expense Category: "),
                                            Text(
                                              snapshot.data!.docs[index][
                                                  ExpenseDatabaseFieldNames
                                                      .expenseCategory],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text("Expense Note: "),
                                            Text(
                                              snapshot.data!.docs[index][
                                                  ExpenseDatabaseFieldNames
                                                      .expenseNote],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  ),
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: _addNewExpense,
        ),
      ),
    );
  }
}
