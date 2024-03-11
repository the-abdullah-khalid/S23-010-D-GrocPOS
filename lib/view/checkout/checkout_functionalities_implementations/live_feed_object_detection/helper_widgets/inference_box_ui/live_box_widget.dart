import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/widgets/checkout_functinality_drawer_widget.dart';
import 'package:groc_pos_app/view_model/checkout/ledger_customer_checkout/ledger_scanned_products_controller.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';
import 'package:groc_pos_app/view_model/checkout/scanned_products_controller/scanned_products_controller.dart';
import '../model_unpacking/live_recognition_model.dart';

/// Individual bounding box
class BoxWidget extends StatefulWidget {
  final Recognition result;

  const BoxWidget({super.key, required this.result, required this.checkOutAs});

  final String checkOutAs;

  @override
  State<BoxWidget> createState() => _BoxWidgetState();
}

class _BoxWidgetState extends State<BoxWidget> {
  late final scannedProductsController;

  scanProducts(Recognition box) {
    debugPrint(" label- ${box.label}");
    debugPrint(" label- ${box.score}");

    final checkOutViewModelController = Get.find<MainCheckOutViewModel>();

    //extract bar code from the label
    List<String> modelLabelProductTokens = box.label.split("-");

    for (ProductModel product
        in checkOutViewModelController.allProductsList.value) {
      if (product.productBarcode.compareTo(modelLabelProductTokens[0]) == 0) {
        debugPrint("adding ${product.productBarcode.toString()}");

        bool data =
            scannedProductsController.addNewProductInTheCartViaBarCode(product);
        print("data - ${data.toString()}");
      }
    }
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
    // Color for bounding box
    Color color = Colors.primaries[(widget.result.label.length +
            widget.result.label.codeUnitAt(0) +
            widget.result.id) %
        Colors.primaries.length];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.result != null) {
        scanProducts(widget.result);
      }
    });

    return Positioned(
      left: widget.result.renderLocation.left,
      top: widget.result.renderLocation.top,
      width: widget.result.renderLocation.width,
      height: widget.result.renderLocation.height,
      child: Container(
        width: widget.result.renderLocation.width,
        height: widget.result.renderLocation.height,
        decoration: BoxDecoration(
            border: Border.all(color: color, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        child: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Container(
              color: color,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.result.label),
                  Text(" ${widget.result.score.toStringAsFixed(2)}"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
