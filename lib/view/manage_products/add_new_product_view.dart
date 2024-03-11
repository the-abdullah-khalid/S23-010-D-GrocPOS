import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/constants/product_categories_list.dart';
import 'package:groc_pos_app/resources/constants/products_unit_list.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/manage_products/add_products_view_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

class AddNewProductView extends StatefulWidget {
  const AddNewProductView({super.key});

  @override
  State<AddNewProductView> createState() => _AddNewProductViewState();
}

class _AddNewProductViewState extends State<AddNewProductView> {
  bool isProgressSpinnerActive = false;
  String barCodeScannerResult = "";
  String dropdownCategoryValue = kProductCategoryList[0];
  String dropdownUnitValue = kUnitsList[0];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productBrandController = TextEditingController();
  final TextEditingController productManufactureController =
      TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController mrpRetailPriceController =
      TextEditingController();
  final TextEditingController barCodeController = TextEditingController();

  final TextEditingController productCategoryController =
      TextEditingController();

  DateTime? productExpiryDate;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mrpRetailPriceController.dispose();
    barCodeController.dispose();
    productBrandController.dispose();
    productCategoryController.dispose();
    productManufactureController.dispose();
    productNameController.dispose();
    purchasePriceController.dispose();
  }

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
      productExpiryDate = pickedDate;
    });
  }

  _performAddNewProduct() async {
    setState(() {
      isProgressSpinnerActive = true;
    });

    bool isFormCorrectlyFilled = true;
    if (productExpiryDate == null) {
      AppUtils.errorDialog(
          context, "Add Product Error", "Please add the expiry date");
      setState(() {
        isProgressSpinnerActive = false;
      });
      isFormCorrectlyFilled = false;
    }

    if (!_formKey.currentState!.validate()) {
      AppUtils.errorDialog(context, "Add Product Error",
          "Please fill the form correctly inorder to add the product");
      setState(() {
        isProgressSpinnerActive = false;
      });
      isFormCorrectlyFilled = false;
    }

    if (!isFormCorrectlyFilled) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      final productDetails = {
        'product_name': productNameController.text.toString(),
        'product_category': dropdownCategoryValue.toString(),
        'product_brand': productBrandController.text.toString(),
        'product_manufacturer_name':
            productManufactureController.text.toString(),
        'product_stock': stockController.text.toString(),
        'product_unit': dropdownUnitValue.toString(),
        'product_mrp': mrpRetailPriceController.text.toString(),
        'product_purchase_price': purchasePriceController.text.toString(),
        'product_barcode': barCodeController.text.toString(),
        'product_id':
            '${barCodeController.text.trim().toString()}:${productNameController.text.trim().toString()}',
        'expiry_date': formatter.format(productExpiryDate!),
      };
      debugPrint(productDetails.toString());
      bool status = await AddProductViewModel()
          .addProductDetails(context, productDetails);

      if (status) {
        setState(() {
          isProgressSpinnerActive = false;
        });
        Get.back();
      } else {
        AppUtils.errorDialog(
            context, "Product Cannot be added", "Something went wrong");
        setState(() {
          isProgressSpinnerActive = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          title: Center(
            child: Text(
              "Groc-POS Add Product",
              style: GoogleFonts.getFont(AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
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
                  'Add Product',
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
                            return 'Enter Product Name';
                          }
                          return null;
                        },
                        controller: productNameController,
                        decoration: const InputDecoration(
                          hintText: 'Product Name',
                          helperText: "Milk pack 1liter",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                              width: 220,
                              child: Text(
                                "Product Category ",
                                style: TextStyle(fontSize: 16),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              // Step 3.
                              value: dropdownCategoryValue,
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
                                  dropdownCategoryValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Brand';
                          }
                          return null;
                        },
                        controller: productBrandController,
                        decoration: const InputDecoration(
                          hintText: 'Product Brand',
                          helperText: "National",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Manufacture Name';
                          }

                          return null;
                        },
                        controller: productManufactureController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Manufacture Name',
                          helperText: "E.g Syed Industries",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Stock';
                                }
                                return null;
                              },
                              controller: stockController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Stock',
                                helperText: "E.g 150",
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                                // Step 3.
                                value: dropdownUnitValue,
                                // Step 4.
                                items: kUnitsList.map<DropdownMenuItem<String>>(
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
                                    dropdownUnitValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Purchase Price';
                                }
                                return null;
                              },
                              controller: purchasePriceController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Purchase Price',
                                helperText: "E.g 150pkr",
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter MRP';
                                }
                                return null;
                              },
                              controller: mrpRetailPriceController,
                              decoration: const InputDecoration(
                                hintText: 'Enter MRP Retail Price',
                                helperText: "E.g 250PKR",
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 280,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Barcode';
                                }
                                return null;
                              },
                              controller: barCodeController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Product Bar Code',
                                helperText: "E.g 123456789",
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            height: 25,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: CustomAppColors.mainThemeColorBlueLogo,
                              ),
                              onPressed: () async {
                                String barcodeScanRes =
                                    await FlutterBarcodeScanner.scanBarcode(
                                        "RED",
                                        "Go Add Product",
                                        true,
                                        ScanMode.BARCODE);

                                barCodeScannerResult = barcodeScanRes;
                                barCodeController.text = barCodeScannerResult;
                                debugPrint(
                                    "bar code value :$barCodeScannerResult");
                              },
                              child: const Icon(Icons.barcode_reader),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          var uuid = const Uuid();
                          barCodeController.text = uuid.v4();
                          barCodeController.text = barCodeController.text
                              .replaceAll(RegExp('-'), '');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "In case of unpacked items you can generate a custom bar code",
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code),
                        onPressed: () {
                          if (barCodeController.text.isEmpty) {
                            AppUtils.errorDialog(
                                context,
                                'No Bar Code Generated For Generating QR Code',
                                'Inorder to generate a bar code click on the above text');
                          } else {
                            Get.toNamed(
                              RouteName.customQRCodeGenerationView,
                              arguments: {
                                "new_products_details": {
                                  'product_name':
                                      productNameController.text.toString(),
                                  'product_barcode':
                                      barCodeController.text.toString(),
                                }
                              },
                            );
                          }
                        },
                        label: const Text(
                            "Generate Custom QR Code for unpacked item"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Expiry Date'),
                          Text(productExpiryDate == null
                              ? 'No Date Selected'
                              : formatter.format(productExpiryDate!)),
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
                  loading: isProgressSpinnerActive,
                  title: 'Add Product To System',
                  onTap: _performAddNewProduct,
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
