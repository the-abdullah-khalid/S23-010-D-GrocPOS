import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:groc_pos_app/view_model/checkout/ledger_customer_checkout/ledger_scanned_products_controller.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';
import 'package:groc_pos_app/view_model/checkout/scanned_products_controller/scanned_products_controller.dart';

class BarCodeFunctionalityWidget extends StatefulWidget {
  BarCodeFunctionalityWidget({super.key, required this.checkOutAs});
  final String checkOutAs;

  @override
  State<BarCodeFunctionalityWidget> createState() =>
      _BarCodeFunctionalityWidgetState();
}

class _BarCodeFunctionalityWidgetState
    extends State<BarCodeFunctionalityWidget> {
  StreamSubscription<String>? barcodeStreamSubscription;
  List<String> scanBarcodeQRCodeValue = [];
  bool toggleBarCodeScanner = true;
  ScanMode currentScannedMode = ScanMode.BARCODE;
  late final scannedProductsController;
  final checkOutViewModelController = Get.find<MainCheckOutViewModel>();
  final player = AudioPlayer();

  _addNewScannedProduct(String barCode) {
    for (ProductModel product
        in checkOutViewModelController.allProductsList.value) {
      if (barCode.compareTo(product.productBarcode) == 0) {
        debugPrint(" _addNewScannedProduct- ${barCode}");
        scannedProductsController.addNewProductInTheCartViaBarCode(product);
        player.play(AssetSource('audio/scanner_aduio.wav'));
        print(scannedProductsController.allScannedProductsList.value.length);
      }
    }
  }

  _toggleScanner() {
    print("toogle");
    if (currentScannedMode == ScanMode.BARCODE) {
      currentScannedMode = ScanMode.QR;
      toggleBarCodeScanner = false;
    } else if (currentScannedMode == ScanMode.QR) {
      currentScannedMode = ScanMode.BARCODE;
      toggleBarCodeScanner = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.checkOutAs.compareTo("walk-in") == 0) {
      scannedProductsController = Get.find<ScannedProductsController>();
    } else {
      scannedProductsController = Get.find<LedgerScannedProductsController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Center(
            child: Text(
              "Barcode Scanner",
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              String closeButtonText = toggleBarCodeScanner
                  ? "Close Bar-Code Scanner"
                  : "Close QR-Code Scanner";

              // scan multiple products on the go
              FlutterBarcodeScanner.getBarcodeStreamReceiver(
                      "#ff6666", closeButtonText, false, currentScannedMode)
                  ?.listen((barcode) {
                if (barcode == "-1") {
                  debugPrint("=========== Not valid =====================");
                } else {
                  debugPrint(
                      " ****************************************************************** - ${barcode}");

                  _addNewScannedProduct(barcode);
                }
              });
            },
            icon: const Icon(Icons.barcode_reader),
            label: Text(
              toggleBarCodeScanner
                  ? "Open Bar-Code Scanner"
                  : "Open QR-Code Scanner",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => Text(
                'Total Products Scanned : ${scannedProductsController.allScannedProductsList.value.length}'),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton.icon(
            onPressed: _toggleScanner,
            icon: const Icon(Icons.toggle_on),
            label: Text(toggleBarCodeScanner
                ? "Switch to QR code Scanner (unpacked)"
                : "Switch to Barcode Scanner (packed)"),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
