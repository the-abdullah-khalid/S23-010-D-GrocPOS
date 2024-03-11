import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/expense_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/constants/product_categories_list.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/manage_expenses/edit_expense_view_model.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class EditExpenseView extends StatefulWidget {
  dynamic data;
  EditExpenseView({super.key, required this.data});

  @override
  State<EditExpenseView> createState() => _EditExpenseViewState();
}

class _EditExpenseViewState extends State<EditExpenseView> {
  String dropdownSupplierOfValue = kProductCategoryList[0];
  final _formKey = GlobalKey<FormState>();
  bool isProgressSpinnerActive = false;
  final TextEditingController expenseTitleController = TextEditingController();
  final TextEditingController expenseAmountController = TextEditingController();
  final TextEditingController expenseNoteController = TextEditingController();
  DateTime? expenseDate;
  int counter = 0;
  ExpenseModel? _expenseModel;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    expenseNoteController.dispose();
    expenseAmountController.dispose();
    expenseTitleController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadExpenseModel();
  }

  _loadExpenseModel() {
    _expenseModel = widget.data;
    expenseTitleController.text = _expenseModel!.expenseTitle;
    expenseAmountController.text = _expenseModel!.expenseAmount;
    expenseNoteController.text = _expenseModel!.expenseNote;
    expenseDate = DateFormat("MM/dd/yyyy").parse(_expenseModel!.expenseDate);
    dropdownSupplierOfValue = _expenseModel!.expenseCategory;
  }

  void setDropDownSupplierOfValue(String value) {
    debugPrint(value);
    dropdownSupplierOfValue = value;
    counter++;
  }

  _performEditNewExpense() async {
    setState(() {
      isProgressSpinnerActive = true;
    });

    bool isFormCorrectlyFilled = true;
    if (expenseDate == null) {
      AppUtils.errorDialog(
          context, "Add expense Error", "Please add the expense date");
      setState(() {
        isProgressSpinnerActive = false;
      });
      isFormCorrectlyFilled = false;
    }

    if (!_formKey.currentState!.validate()) {
      AppUtils.errorDialog(context, "Add expense Error",
          "Please fill the form correctly inorder to add the expense");
      setState(() {
        isProgressSpinnerActive = false;
      });
      isFormCorrectlyFilled = false;
    }

    if (!isFormCorrectlyFilled) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      final expenseDetails = {
        'expense-title': expenseTitleController.text.trim().toString(),
        'expense-amount': expenseAmountController.text.trim().toString(),
        'expense-note': expenseNoteController.text.trim().toString(),
        'expense-category': dropdownSupplierOfValue.toString(),
        'expense-date': formatter.format(expenseDate!),
        'old_expense_id': _expenseModel!.expenseID
      };

      debugPrint('sending expense');
      debugPrint(expenseDetails.toString());
      bool status = await EditExpenseViewModel()
          .editExpenseDetails(expenseDetails, context);

      if (status) {
        setState(() {
          isProgressSpinnerActive = false;
        });
        Get.back(result: "true");
      } else {
        Future.delayed(Duration.zero, () {
          AppUtils.errorDialog(
              context, "Expense Cannot be added", "Something went wrong");
        });
        setState(() {
          isProgressSpinnerActive = false;
        });
      }
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month - 1, now.day - 1);
    final lastDate = now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      expenseDate = pickedDate;
    });
  }

  FocusNode expenseTitleNode = FocusNode();
  FocusNode expenseAmountNode = FocusNode();
  FocusNode expenseNoteNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          title: Center(
            child: Text(
              "Add New Expense",
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Add New Expense",
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // expense name
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Expense Name';
                          }
                          return null;
                        },
                        controller: expenseTitleController,
                        decoration: const InputDecoration(
                          hintText: 'Expense Title',
                          helperText: "Buying of lays",
                        ),
                        keyboardType: TextInputType.text,
                        focusNode: expenseTitleNode,
                        onFieldSubmitted: (value) {
                          AppUtils.fieldFocusChange(
                              context, expenseTitleNode, expenseAmountNode);
                        },
                      ),

                      // expense amount
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Expense Amount';
                          }
                          return null;
                        },
                        controller: expenseAmountController,
                        decoration: const InputDecoration(
                          hintText: 'Expense Amount',
                          helperText: "Eg: 100PKR",
                        ),
                        keyboardType: TextInputType.number,
                        focusNode: expenseAmountNode,
                        onFieldSubmitted: (value) {
                          AppUtils.fieldFocusChange(
                              context, expenseAmountNode, expenseNoteNode);
                        },
                      ),

                      // expense note
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Expense Note';
                          }
                          return null;
                        },
                        controller: expenseNoteController,
                        decoration: const InputDecoration(
                          hintText: 'Expense Note',
                          helperText:
                              "Any specific note for the specific expense",
                        ),
                        keyboardType: TextInputType.text,
                        focusNode: expenseNoteNode,
                        onFieldSubmitted: (value) {
                          AppUtils.fieldFocusChange(
                              context, expenseNoteNode, expenseTitleNode);
                        },
                      ),

                      //expense date
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Expense Category'),
                          SizedBox(
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                                // Step 3.
                                value: dropdownSupplierOfValue,
                                // Step 4.
                                items: kProductCategoryList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                                // Step 5.
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownSupplierOfValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Expense Date'),
                          Text(expenseDate == null
                              ? 'No Date Selected'
                              : formatter.format(expenseDate!)),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                RoundButton(
                  loading: isProgressSpinnerActive,
                  title: 'Update Expense To System',
                  onTap: _performEditNewExpense,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
