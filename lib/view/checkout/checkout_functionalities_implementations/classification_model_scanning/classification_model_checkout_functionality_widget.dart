import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/main.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/classification_model_scanning/helping_widgets/live_camera_screen.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/widgets/checkout_functinality_drawer_widget.dart';
import 'package:groc_pos_app/view_model/checkout/ledger_customer_checkout/ledger_scanned_products_controller.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';
import 'package:groc_pos_app/view_model/checkout/scanned_products_controller/scanned_products_controller.dart';

class ClassificationModelCheckoutFunctionalityWidget extends StatefulWidget {
  ClassificationModelCheckoutFunctionalityWidget(
      {super.key, required this.checkOutAs});
  final String checkOutAs;

  @override
  State<ClassificationModelCheckoutFunctionalityWidget> createState() =>
      _ClassificationModelCheckoutFunctionalityWidgetState();
}

class _ClassificationModelCheckoutFunctionalityWidgetState
    extends State<ClassificationModelCheckoutFunctionalityWidget> {
  late CameraDescription cameraDescription;
  late final scannedProductsController;
  final checkOutViewModelController = Get.find<MainCheckOutViewModel>();
  final modelThrsuholdSliderController =
      Get.find<ModelThrsuholdSliderController>();

  initializeCamera() {
    cameraDescription = CAMERAS_LIST_OF_DEVICE.first;
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    initializeCamera();
    if (widget.checkOutAs.compareTo("walk-in") == 0) {
      scannedProductsController = Get.find<ScannedProductsController>();
    } else {
      scannedProductsController = Get.find<LedgerScannedProductsController>();
    }
  }

  _addProductsToCart(String productIDLabelByModel) {
    debugPrint('Currently scanned Item : $productIDLabelByModel');
    List<String> productIDTokens = productIDLabelByModel.split('-');
    for (ProductModel product
        in checkOutViewModelController.allProductsList.value) {
      if (productIDTokens[0].compareTo(product.productBarcode) == 0) {
        scannedProductsController.addNewProductInTheCartViaBarCode(product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Obx(
            () => Text(
              "Classification Model Scanning\nModel Thurshold: ${modelThrsuholdSliderController.currentClassificationModelThurshold.value}",
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 500,
            width: double.infinity,
            child: Card(
              child: CameraScreen(
                addProductToCart: _addProductsToCart,
                camera: cameraDescription,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
