import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/static_image_capture_object_detection_functionality/helping_widgets/static_object_detection_functionality.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/widgets/checkout_functinality_drawer_widget.dart';
import 'package:groc_pos_app/view_model/checkout/ledger_customer_checkout/ledger_scanned_products_controller.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';
import 'package:groc_pos_app/view_model/checkout/scanned_products_controller/scanned_products_controller.dart';
import 'package:image_picker/image_picker.dart';

List<Map<String, dynamic>> staticImageObjectDetectionPredictionLableList = [];

class StaticImageCaptureObjectDetectionFunctionalityWidget
    extends StatefulWidget {
  StaticImageCaptureObjectDetectionFunctionalityWidget(
      {super.key, required this.checkOutAs});
  final String checkOutAs;

  @override
  State<StaticImageCaptureObjectDetectionFunctionalityWidget> createState() =>
      _StaticImageCaptureObjectDetectionFunctionalityWidgetState();
}

class _StaticImageCaptureObjectDetectionFunctionalityWidgetState
    extends State<StaticImageCaptureObjectDetectionFunctionalityWidget> {
  final imagePicker = ImagePicker();
  StaticImageObjectDetection? objectDetection;
  bool imageProcessingStarted = true;
  Uint8List? image;
  late final scannedProductsController;
  final checkOutViewModelController = Get.find<MainCheckOutViewModel>();
  final modelThrsuholdSliderController =
      Get.find<ModelThrsuholdSliderController>();

  _openProductDetectionModel() async {
    setState(() {
      staticImageObjectDetectionPredictionLableList = [];
    });
    try {
      final result = await imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (result != null) {
        // log(result.toString());
        image = objectDetection!.analyseImage(result.path);
        setState(() {});
        AppUtils.checkoutBeepSound();
        _extractLabels();
      }
    } catch (error) {
      Future.delayed(Duration.zero, () {
        AppUtils.flushBarErrorMessage(
            "Some thing went wrong ${error.toString()}", context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    objectDetection = StaticImageObjectDetection();

    if (widget.checkOutAs.compareTo("walk-in") == 0) {
      scannedProductsController = Get.find<ScannedProductsController>();
    } else {
      scannedProductsController = Get.find<LedgerScannedProductsController>();
    }
  }

  _extractLabels() {
    for (Map<String, dynamic> object
        in staticImageObjectDetectionPredictionLableList) {
      String productID = object["label"].toString();
      _addProductsToCart(productID);
    }
  }

  _addProductsToCart(String productIDLabelByModel) {
    debugPrint('Currently scanned Item : $productIDLabelByModel');
    List<String> productIDTokens = productIDLabelByModel.split('-');
    debugPrint("Current Scanned Token ${productIDTokens.toString()}");
    debugPrint("Current Scanned Token ${productIDTokens[0].toString()}");

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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Static Image Object Detection",
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
            Center(
              child: (image != null)
                  ? Image.memory(image!)
                  : const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text("Please Capture Image Image To Process Future")
                        ],
                      ),
                    ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  image = null;
                  staticImageObjectDetectionPredictionLableList = [];
                });
              },
              child: const Text("Clear Processing"),
            ),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
              title: "Open the Product Detector Model",
              onTap: _openProductDetectionModel,
            ),
          ],
        ),
      ),
    );
  }
}
