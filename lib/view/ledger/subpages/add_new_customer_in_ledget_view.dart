import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/ledger/add_customer_in_ledget_view_model.dart';

import '../../../resources/colors/app_colors.dart';
import '../../../resources/fonts/app_fonts_names.dart';

class AddNewCustomerLedgerView extends StatefulWidget {
  const AddNewCustomerLedgerView({super.key});

  @override
  State<AddNewCustomerLedgerView> createState() =>
      _AddNewCustomerLedgerViewState();
}

class _AddNewCustomerLedgerViewState extends State<AddNewCustomerLedgerView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();
  final TextEditingController customerCNINController = TextEditingController();
  final TextEditingController customerAddressController =
      TextEditingController();
  bool isProgressSpinnerActive = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    customerAddressController.dispose();
    customerNameController.dispose();
    customerCNINController.dispose();
    customerPhoneController.dispose();
  }

  FocusNode customerNameNode = FocusNode();
  FocusNode customerPhoneNode = FocusNode();
  FocusNode customerCNICNode = FocusNode();
  FocusNode customerAddressNode = FocusNode();

  _performAddNewCustomerToLedger() async {
    setState(() {
      isProgressSpinnerActive = true;
    });
    bool isFormCorrectlyFilled = true;
    if (!_formKey.currentState!.validate()) {
      AppUtils.errorDialog(context, "Add Customer Error",
          "Please fill the form correctly inorder to add the customer to the ledger");
      setState(() {
        isProgressSpinnerActive = false;
      });
      isFormCorrectlyFilled = false;
    }

    if (!isFormCorrectlyFilled) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> ledgerNewCustomerDetails = {
        'ledger-customer-name': customerNameController.text.trim().toString(),
        'ledger-customer-address':
            customerAddressController.text.trim().toString(),
        'ledger-customer-cnic': customerCNINController.text.trim().toString(),
        'ledger-customer-phone-number':
            customerPhoneController.text.trim().toString(),
        'ledger-customer-total-amount-due': "0",
      };

      debugPrint('sending ledger data');
      debugPrint(ledgerNewCustomerDetails.toString());
      bool status = await AddCustomerInLedgerViewModel()
          .addNewCustomerInLedger(context, ledgerNewCustomerDetails);

      if (status) {
        setState(() {
          isProgressSpinnerActive = false;
        });
        Get.back(result: "true");
      } else {
        Future.delayed(Duration.zero, () {
          AppUtils.errorDialog(
              context, "New Customer Cannot be added", "Something went wrong");
        });
        setState(() {
          isProgressSpinnerActive = false;
        });
      }
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
                "Add New Customer",
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
                    // customer name
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Customer Name';
                        }
                        return null;
                      },
                      controller: customerNameController,
                      decoration: const InputDecoration(
                        hintText: 'Customer Name',
                        helperText: "Buying of lays",
                      ),
                      keyboardType: TextInputType.text,
                      focusNode: customerNameNode,
                      onFieldSubmitted: (value) {
                        AppUtils.fieldFocusChange(
                            context, customerNameNode, customerPhoneNode);
                      },
                    ),

                    // customer phone
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Customer Phone Number';
                        }
                        return null;
                      },
                      controller: customerPhoneController,
                      decoration: const InputDecoration(
                        hintText: 'Customer Phone Number',
                        helperText: "Eg: 03331111111",
                      ),
                      keyboardType: TextInputType.number,
                      focusNode: customerPhoneNode,
                      onFieldSubmitted: (value) {
                        AppUtils.fieldFocusChange(
                          context,
                          customerPhoneNode,
                          customerCNICNode,
                        );
                      },
                    ),

                    // customer cnic
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Customer CNIC';
                        }
                        return null;
                      },
                      controller: customerCNINController,
                      decoration: const InputDecoration(
                        hintText: 'Customer CNIC',
                        helperText: "37405-123456789",
                      ),
                      keyboardType: TextInputType.number,
                      focusNode: customerCNICNode,
                      onFieldSubmitted: (value) {
                        AppUtils.fieldFocusChange(
                            context, customerCNICNode, customerAddressNode);
                      },
                    ),

                    //expense date
                    const SizedBox(
                      height: 10,
                    ),
                    // customer address
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Customer Address';
                        }
                        return null;
                      },
                      controller: customerAddressController,
                      decoration: const InputDecoration(
                        hintText: 'Customer Address',
                        helperText:
                            "House No 33-A,Abid Road, Rawalpindi Cantt,RWP",
                      ),
                      keyboardType: TextInputType.text,
                      focusNode: customerAddressNode,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundButton(
                      loading: isProgressSpinnerActive,
                      title: 'Add Customer To Ledger',
                      onTap: _performAddNewCustomerToLedger,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
