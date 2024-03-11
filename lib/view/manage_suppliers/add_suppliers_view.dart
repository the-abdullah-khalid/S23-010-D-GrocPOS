import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/manage_suppliers/add_supplier_view_model.dart';

import '../../resources/constants/supplier_categories_list.dart';

class AddNewSupplierView extends StatefulWidget {
  const AddNewSupplierView({super.key});

  @override
  State<AddNewSupplierView> createState() => _AddNewSupplierViewState();
}

class _AddNewSupplierViewState extends State<AddNewSupplierView> {
  bool isNewSupplierAddedProgressIndicator = false;

  Future<void> performAddNewSupplier() async {
    setState(() {
      isNewSupplierAddedProgressIndicator = true;
    });
    //if inputs are not filled properly
    if (!_formKey.currentState!.validate()) {
      AppUtils.errorDialog(context, 'Add New Supplier Error',
          'Please fill the form correctly inorder to add a new supplier');

      setState(() {
        isNewSupplierAddedProgressIndicator = false;
      });
      return;
    } else if (_formKey.currentState!.validate()) {
      final supplierDetails = {
        'supplier_phone_no': supplierPhoneNo.text.trim().toString(),
        'supplier_of': dropdownSupplierOfValue.trim()..toString(),
        'supplier_email': supplierEmail.text.trim()..toString(),
        'supplier_name': supplierName.text.trim()..toString(),
        'supplier_shop_name': supplierShopName.text.trim().toString(),
        'supplier_address': supplierAddress.text.trim().toString(),
      };

      // debugPrint(supplierDetails.toString());
      bool isSupplierAdded = await AddNewSupplierViewModel()
          .addNewSupplier(context, supplierDetails);

      if (isSupplierAdded) {
        setState(() {
          isNewSupplierAddedProgressIndicator = false;
        });
        Future.delayed(Duration.zero, () {
          AppUtils.flushBarSucessMessage("New Supplier is added", context);
        });
        Get.back();
      } else {
        Future.delayed(Duration.zero, () {
          AppUtils.errorDialog(
              context, "Supplier Cannot be added", "Something went wrong");
        });
        setState(() {
          isNewSupplierAddedProgressIndicator = false;
        });
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController supplierPhoneNo = TextEditingController();
  final TextEditingController supplierAddress = TextEditingController();
  final TextEditingController supplierEmail = TextEditingController();
  final TextEditingController supplierOf = TextEditingController();
  final TextEditingController supplierName = TextEditingController();
  final TextEditingController supplierShopName = TextEditingController();
  String dropdownSupplierOfValue = kSupplierOfList[0];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    supplierPhoneNo.dispose();
    supplierAddress.dispose();
    supplierEmail.dispose();
    supplierOf.dispose();
    supplierName.dispose();
    supplierShopName.dispose();
  }

  void setDropDownSupplierOfValue(String value) {
    debugPrint(value);
    dropdownSupplierOfValue = value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          title: Center(
            child: Text(
              "Groc-POS Add Supplier",
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
                  'Add New Supplier',
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
                const SizedBox(
                  height: 20,
                ),
                AddNewSupplierForm(
                  formKey: _formKey,
                  supplierPhoneNo: supplierPhoneNo,
                  supplierAddress: supplierAddress,
                  supplierEmail: supplierEmail,
                  supplierOf: supplierOf,
                  supplierName: supplierName,
                  supplierShopName: supplierShopName,
                  dropDownSupplierOfValue: setDropDownSupplierOfValue,
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundButton(
                  loading: isNewSupplierAddedProgressIndicator,
                  title: 'Add New Supplier To System',
                  onTap: performAddNewSupplier,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddNewSupplierForm extends StatefulWidget {
  String dropdownSupplierOfValue = kSupplierOfList[0];
  final formKey;
  final TextEditingController supplierPhoneNo;
  final TextEditingController supplierAddress;
  final TextEditingController supplierEmail;
  final TextEditingController supplierOf;
  final TextEditingController supplierName;
  final TextEditingController supplierShopName;
  final Function(String) dropDownSupplierOfValue;

  final FocusNode supplierNameFocus = FocusNode();
  final FocusNode supplierShopNameFocus = FocusNode();
  final FocusNode supplierEmailFocus = FocusNode();
  final FocusNode supplierPhoneNoFocus = FocusNode();
  final FocusNode supplierAddressFocus = FocusNode();
  final FocusNode supplierOfFoucus = FocusNode();

  AddNewSupplierForm(
      {super.key,
      required this.formKey,
      required this.supplierPhoneNo,
      required this.supplierAddress,
      required this.supplierEmail,
      required this.supplierOf,
      required this.supplierName,
      required this.supplierShopName,
      required this.dropDownSupplierOfValue});

  @override
  State<AddNewSupplierForm> createState() => _AddNewSupplierFormState();
}

class _AddNewSupplierFormState extends State<AddNewSupplierForm> {
  String initialDropDownValue = kSupplierOfList[0];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          //supplier name
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Supplier Name Name';
              }
              return null;
            },
            controller: widget.supplierName,
            decoration: const InputDecoration(
              hintText: 'Supplier Name',
              helperText: "Khasif Ahmed",
            ),
            keyboardType: TextInputType.text,
            focusNode: widget.supplierNameFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(
                context,
                widget.supplierNameFocus,
                widget.supplierEmailFocus,
              );
            },
          ),

          // supplier email
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Supplier Email';
              }
              return null;
            },
            controller: widget.supplierEmail,
            decoration: const InputDecoration(
              hintText: 'Enter Supplier Email',
              helperText: "kashif@gmail.com",
            ),
            keyboardType: TextInputType.text,
            focusNode: widget.supplierEmailFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(
                context,
                widget.supplierEmailFocus,
                widget.supplierAddressFocus,
              );
            },
          ),

          //supplier address
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Supplier Address';
              }

              return null;
            },
            controller: widget.supplierAddress,
            decoration: const InputDecoration(
              hintText: 'Enter Supplier Address',
              helperText: "E.g Rawalpindi",
            ),
            keyboardType: TextInputType.text,
            focusNode: widget.supplierAddressFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(
                context,
                widget.supplierAddressFocus,
                widget.supplierPhoneNoFocus,
              );
            },
          ),

          //supplier phone no
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Supplier Phone No';
              }

              return null;
            },
            controller: widget.supplierPhoneNo,
            decoration: const InputDecoration(
              hintText: 'Enter Supplier Phone No',
              helperText: "E.g +9212345678",
            ),
            keyboardType: TextInputType.number,
            focusNode: widget.supplierPhoneNoFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(
                context,
                widget.supplierPhoneNoFocus,
                widget.supplierShopNameFocus,
              );
            },
          ),

          //-->supplier shop name
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Supplier Shop Name';
              }

              return null;
            },
            controller: widget.supplierShopName,
            decoration: const InputDecoration(
              hintText: 'Enter Supplier Shop Name',
              helperText: "E.g Ali Traders",
            ),
            keyboardType: TextInputType.text,
            focusNode: widget.supplierShopNameFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(
                context,
                widget.supplierShopNameFocus,
                widget.supplierNameFocus,
              );
            },
          ),
          Row(
            children: [
              const SizedBox(
                width: 200,
                child: Text(
                  'Supplier of',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButton<String>(
                  // Step 3.
                  value: initialDropDownValue,
                  // Step 4.
                  items: kSupplierOfList
                      .map<DropdownMenuItem<String>>((String value) {
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
                      initialDropDownValue = newValue!;
                      widget.dropDownSupplierOfValue(newValue!);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
