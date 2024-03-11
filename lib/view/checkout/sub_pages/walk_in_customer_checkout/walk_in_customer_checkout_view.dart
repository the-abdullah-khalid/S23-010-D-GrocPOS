import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/main.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/colors/pie_chart_colors.dart';
import 'package:groc_pos_app/resources/constants/checkout_functionalities_enum.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/bar_code_scanning/bar_code_functionality_widget.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/classification_model_scanning/classification_model_checkout_functionality_widget.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/live_feed_object_detection/live_feed_object_detection_functionality_widget.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/widgets/checkout_functinality_drawer_widget.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';
import 'package:groc_pos_app/view_model/checkout/scanned_products_controller/scanned_products_controller.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:badges/badges.dart' as badges;

import '../../checkout_functionalities_implementations/static_image_capture_object_detection_functionality/static_image_capture_object_detection_functionality_widget.dart';
import '../../widget/products_list_checkout_widget.dart';

class WalkInCustomerCheckOutView extends StatefulWidget {
  const WalkInCustomerCheckOutView({super.key});

  @override
  State<WalkInCustomerCheckOutView> createState() =>
      _WalkInCustomerCheckOutViewState();
}

class _WalkInCustomerCheckOutViewState
    extends State<WalkInCustomerCheckOutView> {
  List<ProductModel> allProductsInTheShop = [];
  late MainCheckOutViewModel checkOutViewModelController;
  DrawerOptionsController drawerOptionsController =
      Get.put(DrawerOptionsController());
  String currentSelectedFunctionality = '';
  ScannedProductsController scannedProductsController =
      Get.put(ScannedProductsController());

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Walk In Customer Checkout",
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
                  Get.toNamed(RouteName.cartManagementView)?.then((value) {
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

                    return BarCodeFunctionalityWidget(
                      checkOutAs: "walk-in",
                    );
                  } else if (onFunctionality
                          .compareTo(Functionality.classification.toString()) ==
                      0) {
                    // set the bar code functionality widget here

                    return ClassificationModelCheckoutFunctionalityWidget(
                      checkOutAs: "walk-in",
                    );
                  } else if (onFunctionality.compareTo(Functionality
                          .staticImageObjectDetection
                          .toString()) ==
                      0) {
                    // set the bar code functionality widget here

                    return StaticImageCaptureObjectDetectionFunctionalityWidget(
                      checkOutAs: "walk-in",
                    );
                  } else if (onFunctionality.compareTo(
                          Functionality.objectDetection.toString()) ==
                      0) {
                    // set the bar code functionality widget here
                    return LiveFeedObjectDetectionFunctionalityWidget(
                      checkOutAs: "walk-in",
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
