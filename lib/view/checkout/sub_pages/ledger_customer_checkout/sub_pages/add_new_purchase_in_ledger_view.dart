import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/ledger_customer_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class AddNewPurchaseInLedgerView extends StatefulWidget {
  AddNewPurchaseInLedgerView({super.key, required this.data});
  dynamic data;

  @override
  State<AddNewPurchaseInLedgerView> createState() =>
      _AddNewPurchaseInLedgerViewState();
}

class _AddNewPurchaseInLedgerViewState
    extends State<AddNewPurchaseInLedgerView> {
  final TextEditingController purchaseTitle = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? purchaseDueDate;
  bool isProgressSpinnerActive = false;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month - 1, now.day - 1);
    final lastDate = DateTime(now.year + 10, now.month + 10, now.day + 10);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      purchaseDueDate = pickedDate;
    });
  }

  _moveToLedgerCheckOutScreen() {
    bool isFormCorrectlyFilled = true;

    if (purchaseDueDate == null) {
      AppUtils.errorDialog(
          context, "Add purchase Error", "Please add the expense date");
      setState(() {
        isProgressSpinnerActive = false;
      });
      isFormCorrectlyFilled = false;
    }
    if (!_formKey.currentState!.validate()) {
      AppUtils.errorDialog(context, "Add purchase Error",
          "Please fill the form correctly inorder to add the purchase");
      setState(() {
        isProgressSpinnerActive = false;
      });
      isFormCorrectlyFilled = false;
    }

    if (!isFormCorrectlyFilled) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      final newPurchaseData = {
        'purchase_title': purchaseTitle.text.trim().toString(),
        'purchase_due_date': formatter.format(purchaseDueDate!),
        'date_of_purchase': formatter.format(DateTime.now()),
      };

      isFormCorrectlyFilled = false;
      Get.toNamed(RouteName.openLedgerCustomerCheckOutScanning, arguments: {
        'customer_details': (widget.data) as LedgerCustomerModel,
        'purchase_data': newPurchaseData,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Groc-POS Shop Ledger",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                "Registered Customer Data",
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
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          (widget.data as LedgerCustomerModel)
                              .customerName
                              .toString(),
                          style: GoogleFonts.getFont(
                            AppFontsNames.kBodyFont,
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text("Phone No#: "),
                                Text(
                                  (widget.data as LedgerCustomerModel)
                                      .customerPhoneNUmber,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("CNIC: "),
                            Text(
                              (widget.data as LedgerCustomerModel).customerCNIC,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Customer Address:\n${(widget.data as LedgerCustomerModel).customerAddress.toString()}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            AppFontsNames.kBodyFont,
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Amount Due: ${double.parse(((widget.data as LedgerCustomerModel).customerTotalAmountDue)).abs().toString()} PKR",
                          style: GoogleFonts.getFont(
                            AppFontsNames.kBodyFont,
                            textStyle: TextStyle(
                              color: double.parse(((widget.data
                                                  as LedgerCustomerModel)
                                              .customerTotalAmountDue))
                                          .abs() >
                                      0
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Add A New Purchase Detail",
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
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Purchase Name';
                        }
                        return null;
                      },
                      controller: purchaseTitle,
                      decoration: const InputDecoration(
                        hintText: 'Purchase Title',
                        helperText: "Buying of lays",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Due Date'),
                        Text(purchaseDueDate == null
                            ? 'No Date Selected'
                            : formatter.format(purchaseDueDate!)),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: "Open Product Scanning",
                  onTap: _moveToLedgerCheckOutScreen)
            ],
          ),
        ),
      ),
    );
  }
}
