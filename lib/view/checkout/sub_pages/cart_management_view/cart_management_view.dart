import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/resources/widgets_components/no_data_message_widget.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/checkout/cart_management_controller/cart_view_model.dart';
import 'package:groc_pos_app/view_model/checkout/scanned_products_controller/scanned_products_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../payment_details_setting/sub_pages/show_easy_pisa_details_view.dart';

class CartManagementView extends StatefulWidget {
  const CartManagementView({super.key});

  @override
  State<CartManagementView> createState() => _CartManagementViewState();
}

class _CartManagementViewState extends State<CartManagementView> {
  final scannedProductsController = Get.find<ScannedProductsController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scannedProductsController.computeSubTotal();
    });
  }

  bool checkOutLoader = false;
  _finalizeBill() async {
    setState(() {
      checkOutLoader = true;
    });
    List<Map<String, dynamic>> updatesForDatabase = [];
    if (scannedProductsController.amountPaidCustomer.value <
        scannedProductsController.grandTotal.value) {
      AppUtils.errorDialog(context, "Amount Paid is less than grand total",
          "Kindly ask customer pay proper amount");
      setState(() {
        checkOutLoader = false;
      });
      return;
    } else {
      List<String> productIDs = [];
      List<int> quantities = [];

      for (ProductModel cartItem
          in scannedProductsController.allScannedProductsList) {
        productIDs.add(cartItem.productId);
        quantities.add(cartItem.productQuantityInCart);
      }

      for (int index = 0; index < productIDs.length; index++) {
        int currentStock = scannedProductsController
            .allScannedProductsList[index].productStock;
        int newUpdatedStock = currentStock - quantities[index];

        updatesForDatabase.add({
          ProductDatabaseFieldNames.productID: productIDs[index],
          ProductDatabaseFieldNames.productStock: newUpdatedStock,
        });
      }

      debugPrint(" updatesForDatabase- ${updatesForDatabase}");

      //---------- creating invoice data -----------------------------------------
      const uuid = Uuid();
      String invoiceID = uuid.v4();
      Map<String, dynamic> newInvoice = {
        'date-time': DateTime.now(),
        'customer-name': "Walk In Customer",
        'customer-type': 'Walk In Customer',
        'paymentMethod': scannedProductsController.paymentMethod.value,
        'bill-id': invoiceID,
        'discount-percentage': scannedProductsController.discountAmount.value,
        'sub-total': scannedProductsController.subTotal.value,
        'grand-total': scannedProductsController.grandTotal.value,
        'amount-paid-by-customer':
            scannedProductsController.amountPaidCustomer.value,
        'change-amount': scannedProductsController.changeForCustomer.value
      };

      List<Object> allCartProducts = [];
      for (ProductModel cartItem
          in scannedProductsController.allScannedProductsList) {
        for (int productCounter = 1;
            productCounter <= cartItem.productQuantityInCart;
            productCounter++) {
          Map<String, dynamic> object = cartItem.toJson();
          allCartProducts.add(object);
          print(object);
        }
      }
      newInvoice['products-list'] = allCartProducts;

      bool status = await CartViewModel()
          .registerPurchase(updatesForDatabase, newInvoice, context);

      if (status) {
        AppUtils.flushBarSucessMessage("Checkout Successful", context);

        setState(() {
          checkOutLoader = false;
        });

        return AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: "Check Sucessfull",
          desc: "New purchase is now added. see invoices to see more",
          btnOkOnPress: () {
            Get.until((route) => Get.currentRoute == RouteName.checkoutView);
          },
        )..show();
      } else {
        setState(() {
          checkOutLoader = false;
        });
        Future.delayed(Duration.zero, () {
          AppUtils.flushBarErrorMessage("Checkout Failure", context);
          AppUtils.errorDialog(
              context, "Checkout Failure", "Something went wrong");
        });
      }
    }
  }

  _handleEasyPisaPaymentMethod() async {
    scannedProductsController.paymentMethod.value = 'easy pisa';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? imageURl = prefs.getString('easy_pisa_qr_code_image_url');
    final String? imageURl = prefs.getString('easy-paisa_payment_qr_image_url');

    debugPrint(imageURl);
    if (imageURl == null || imageURl.isEmpty) {
      Future.delayed(Duration.zero, () {
        return AppUtils.errorDialog(context, "Easy Pisa Details are Not Set",
            "Please First Go to Payment Settings options and set easy pisa details");
      });
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Card(
                child: Image(
              image: NetworkImage(imageURl.toString()),
            ));
          });
    }
  }

  _handleJazzCashPaymentMethod() async {
    scannedProductsController.paymentMethod.value = 'jazz cash';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? imageURl = prefs.getString('jazz-cash_payment_qr_image_url');
    final String? imageURl = prefs.getString('jazz-cash_payment_qr_image_url');
    debugPrint(imageURl);
    if (imageURl == null) {
      Future.delayed(Duration.zero, () {
        return AppUtils.errorDialog(context, "Jazz Cash Details are Not Set",
            "Please First Go to Payment Settings options and set Jazz Cash details");
      });
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Card(
                child: Image(
              image: NetworkImage(imageURl.toString()),
            ));
          });
    }
  }

  _handleCashPaymentMethod() {
    scannedProductsController.paymentMethod.value = 'Cash Payment';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Cart",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.until((route) => Get.currentRoute == RouteName.checkoutView);
            },
            icon: const Icon(
              Icons.remove_shopping_cart,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Products in the Cart",
                style: GoogleFonts.getFont(
                  AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() {
                if (scannedProductsController
                    .allScannedProductsList.value.isEmpty) {
                  return const NoDataMessageWidget(
                      dataOf: "Cart",
                      message: "No Products in the cart. Cart is empty");
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                children: [
                                  Text(
                                    scannedProductsController
                                        .allScannedProductsList
                                        .value[index]
                                        .productName
                                        .toString(),
                                    style: GoogleFonts.getFont(
                                      AppFontsNames.kBodyFont,
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Price MRP: ${scannedProductsController.allScannedProductsList.value[index].productMrp.toString()} PKR'),
                                      IconButton(
                                        onPressed: () {
                                          scannedProductsController
                                              .removeScannedProductFromCart(
                                                  scannedProductsController
                                                      .allScannedProductsList
                                                      .value[index],
                                                  index);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                        () => Text(
                                            'Qty : ${scannedProductsController.allScannedProductsList.value[index].productQuantityInCart.toString()} ${scannedProductsController.allScannedProductsList.value[index].productUnit}'),
                                      ),
                                      Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: CustomAppColors
                                              .mainThemeColorBlueLogo,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                child: const Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                                onTap: () {
                                                  if (scannedProductsController
                                                          .allScannedProductsList
                                                          .value[index]
                                                          .productQuantityInCart >
                                                      1) {
                                                    scannedProductsController
                                                        .decreaseProductCartQuantity(
                                                            index);
                                                    scannedProductsController
                                                        .computeSubTotal();
                                                  }
                                                },
                                              ),
                                              Text(
                                                scannedProductsController
                                                    .allScannedProductsList
                                                    .value[index]
                                                    .productQuantityInCart
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              InkWell(
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                                onTap: () {
                                                  scannedProductsController
                                                      .increaseProductCartQuantity(
                                                          index);
                                                  scannedProductsController
                                                      .computeSubTotal();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: scannedProductsController
                            .allScannedProductsList.length,
                      ),
                    ),
                  );
                }
              }),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: _handleEasyPisaPaymentMethod,
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image(
                                  image:
                                      AssetImage("assets/logos/easy-pisa.png"),
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Easy Pisa \nDetails",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )),
                    InkWell(
                        onTap: _handleJazzCashPaymentMethod,
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/logos/jazz-cash-logo.png"),
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Jazz Cash \nDetails",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )),
                    InkWell(
                        onTap: _handleCashPaymentMethod,
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/logos/cash-payment.png"),
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Pay With Cash",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller:
                      scannedProductsController.discountFieldController.value,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      label: Text("Offer Discount"),
                      hintText: "e.g Discount is 5%"),
                  onChanged: (value) {
                    scannedProductsController.calculateSubTotal();
                  },
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: scannedProductsController
                        .amountPaidByCustomerController.value,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        label: Text("Amount Paid"), hintText: "e.g 25000"),
                    onChanged: (value) {
                      scannedProductsController.calculateSubTotal();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sub Total"),
                        Obx(
                          () => Text(
                            "${scannedProductsController.subTotal.value}",
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Discount Amount  %"),
                        Obx(() => Text(
                            "${scannedProductsController.discountAmount.value}"))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Grand Total "),
                        Obx(() => Text(
                              "${scannedProductsController.grandTotal.value}",
                              style: TextStyle(
                                color: (scannedProductsController
                                            .amountPaidCustomer.value >=
                                        scannedProductsController
                                            .grandTotal.value)
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Amount Paid By Customer "),
                        Obx(() => Text(
                            "${scannedProductsController.amountPaidCustomer.value}"))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Change Amount "),
                        Obx(() => Text(
                            "${scannedProductsController.changeForCustomer}")),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Payment Method"),
                        Obx(() =>
                            Text("${scannedProductsController.paymentMethod}"))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RoundButton(
                      onTap: _finalizeBill,
                      title: "Finalize Bill",
                      loading: checkOutLoader,
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
