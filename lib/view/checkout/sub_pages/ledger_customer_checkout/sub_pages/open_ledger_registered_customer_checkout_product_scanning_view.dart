import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/ledger_customer_model.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/constants/checkout_functionalities_enum.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/bar_code_scanning/bar_code_functionality_widget.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/classification_model_scanning/classification_model_checkout_functionality_widget.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/live_feed_object_detection/live_feed_object_detection_functionality_widget.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/static_image_capture_object_detection_functionality/static_image_capture_object_detection_functionality_widget.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/widgets/checkout_functinality_drawer_widget.dart';
import 'package:groc_pos_app/view_model/checkout/ledger_customer_checkout/ledger_scanned_products_controller.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';
import 'package:uuid/uuid.dart';
import 'package:badges/badges.dart' as badges;

class OpenLedgerRegisteredCustomerCheckOutProductScanningView
    extends StatefulWidget {
  OpenLedgerRegisteredCustomerCheckOutProductScanningView(
      {super.key, required this.customerData, required this.purchaseData});
  dynamic customerData;
  dynamic purchaseData;

  @override
  State<OpenLedgerRegisteredCustomerCheckOutProductScanningView>
      createState() =>
          _OpenLedgerRegisteredCustomerCheckOutProductScanningViewState();
}

class _OpenLedgerRegisteredCustomerCheckOutProductScanningViewState
    extends State<OpenLedgerRegisteredCustomerCheckOutProductScanningView> {
  List<ProductModel> allProductsInTheShop = [];
  late MainCheckOutViewModel checkOutViewModelController;
  DrawerOptionsController drawerOptionsController =
      Get.put(DrawerOptionsController());
  String currentSelectedFunctionality = '';
  LedgerScannedProductsController scannedProductsController =
      Get.put(LedgerScannedProductsController());

  _fetchAllProductsList() {
    checkOutViewModelController = Get.find<MainCheckOutViewModel>();
    allProductsInTheShop = checkOutViewModelController.allProductsList.value;
    debugPrint(
        "_fetchAllProductsList in shop length- ${allProductsInTheShop.length}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAllProductsList();
  }

  @override
  Widget build(BuildContext context) {
    //--- set the customer data after the widget tree is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.customerData != null || widget.purchaseData != null) {
      } else {
        scannedProductsController.setLedgerCustomerData(
            widget.customerData as LedgerCustomerModel, widget.purchaseData);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Ledger Customer Checkout",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
        actions: [
          Obx(() {
            return InkWell(
              onTap: () {
                if (scannedProductsController.allScannedProductsList.isEmpty) {
                  AppUtils.errorDialog(context, "Cart is Empty",
                      "Please Scan Some Products then go to cart management");
                } else {
                  drawerOptionsController.resetFunctionalityToDefault();
                  Get.toNamed(RouteName.ledgerCustomerCartManagementView,
                      arguments: {
                        'customer_details':
                            (widget.customerData) as LedgerCustomerModel,
                        'purchase_data': widget.purchaseData,
                      })?.then((value) {
                    scannedProductsController.resetCartVariables();
                  });
                }
              },
              child: Center(
                child: badges.Badge(
                  badgeContent: Text(
                    scannedProductsController.allScannedProductsList.length
                        .toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(seconds: 1),
                    colorChangeAnimationDuration: Duration(seconds: 1),
                    loopAnimation: false,
                    curve: Curves.fastOutSlowIn,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: Colors.red,
                    padding: const EdgeInsets.all(5),
                    borderRadius: BorderRadius.circular(4),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.shopping_cart),
                ),
              ),
            );
          }),
          const SizedBox(width: 20.0)
        ],
      ),
      drawer: const CheckOutFunctionalityDrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Obx(
                () {
                  final onFunctionality =
                      drawerOptionsController.selectedFunctionalityName.value;

                  if (onFunctionality
                          .compareTo(Functionality.barCode.toString()) ==
                      0) {
                    // set the bar code functionality widget here

                    return BarCodeFunctionalityWidget(checkOutAs: "ledger");
                  } else if (onFunctionality
                          .compareTo(Functionality.classification.toString()) ==
                      0) {
                    // set the bar code functionality widget here

                    return ClassificationModelCheckoutFunctionalityWidget(
                        checkOutAs: "ledger");
                  } else if (onFunctionality.compareTo(Functionality
                          .staticImageObjectDetection
                          .toString()) ==
                      0) {
                    // set the bar code functionality widget here

                    return StaticImageCaptureObjectDetectionFunctionalityWidget(
                        checkOutAs: "ledger");
                    return const Center(
                      child: Text("No Functionality Selected Yet"),
                    );
                  } else if (onFunctionality.compareTo(
                          Functionality.objectDetection.toString()) ==
                      0) {
                    // set the bar code functionality widget here
                    return LiveFeedObjectDetectionFunctionalityWidget(
                      checkOutAs: "ledger",
                    );
                  } else {
                    return const Center(
                      child: Text("No Functionality Selected Yet"),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "All Scanned Products",
                style: GoogleFonts.getFont(
                  AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Obx(
                () {
                  if (scannedProductsController
                      .allScannedProductsList.value.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "No Product has been scanned yet",
                          style: GoogleFonts.getFont(
                            AppFontsNames.kBodyFont,
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey(scannedProductsController
                                .allScannedProductsList.value[index].productId
                                .toString()),
                            onDismissed: (direction) {
                              scannedProductsController
                                  .removeScannedProductFromCart(
                                      scannedProductsController
                                          .allScannedProductsList.value[index],
                                      index);
                            },
                            child: Card(
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month),
                                            const SizedBox(width: 5),
                                            Text(
                                              scannedProductsController
                                                  .allScannedProductsList
                                                  .value[index]
                                                  .productExpiryDate
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          scannedProductsController
                                              .allScannedProductsList
                                              .value[index]
                                              .productCategory
                                              .toString(),
                                        ),
                                        Text(
                                          "MRP : ${scannedProductsController.allScannedProductsList.value[index].productMrp}",
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: scannedProductsController
                            .allScannedProductsList.value.length,
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: Uuid().v4().toString(),
        onPressed: () {
          scannedProductsController.clearScannedItemsFromCart();
        },
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}
