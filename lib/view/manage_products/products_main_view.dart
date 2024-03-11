import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/resources/widgets_components/no_data_message_widget.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view_model/manage_products/products_main_view_model.dart';

import '../../data/network/database_fields_name.dart';
import '../../resources/colors/app_colors.dart';

class ProductMainView extends StatefulWidget {
  const ProductMainView({super.key});

  @override
  State<ProductMainView> createState() => _ProductMainViewState();
}

class _ProductMainViewState extends State<ProductMainView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>>?
      _productsCollectionReferenceStream;
  void _loadAllProducts() {
    debugPrint("load all products");
    _productsCollectionReferenceStream =
        ProductsMainViewModel().fetchAllProducts();

    if (_productsCollectionReferenceStream == const Stream.empty()) {
      AppUtils.errorDialog(context, "Something went wrong while fetching",
          "Please try again something went wrong while fetching the products details");
      return;
    } else {
      debugPrint(_productsCollectionReferenceStream.toString());
    }
  }

  _performAddNewProductDetails() {
    // Navigator.pushNamed(context, RouteName.addNewProductScreen);
    Get.toNamed(RouteName.addNewProductView);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAllProducts();
  }

  _performEditProductDetails(ProductModel productModel) {
    if (productModel == null) {
      AppUtils.errorDialog(
          context, "Product Edit", "Something went wrong please try again");
      return;
    } else {
      // Navigator.pushNamed(context, RouteName.editProductDetailScreen,
      //     arguments: {'product-details': productModel});
      Get.toNamed(
        RouteName.editProductDetailView,
        arguments: {
          'product-details': productModel,
        },
      );
    }
  }

  _performDeleteProduct(ProductModel deleteProduct) async {
    if (deleteProduct == null) {
      AppUtils.errorDialog(
          context, "Product Delete", "Something went wrong please try again");
      return;
    } else {
      final productDetails = {
        'product_name': deleteProduct.productName,
        'product_category': deleteProduct.productCategory,
        'product_brand': deleteProduct.productBrand,
        'product_manufacturer_name': deleteProduct.productManufactureName,
        'product_stock': deleteProduct.productStock,
        'product_unit': deleteProduct.productUnit,
        'product_mrp': deleteProduct.productMrp,
        'product_purchase_price': deleteProduct.productPurchasePrice,
        'product_barcode': deleteProduct.productBarcode,
        'product_id': deleteProduct.productId,
      };
      bool status =
          await ProductsMainViewModel().removeProduct(productDetails, context);
      if (!status) {
        Future.delayed(Duration.zero, () {
          AppUtils.errorDialog(context, "Product Delete Failure",
              "Something went wrong please try again");
        });
        return;
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
            "Groc-POS All Products",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _productsCollectionReferenceStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                AppUtils.flushBarErrorMessage(
                    "Some Error While Fetching Data", context);
                return const Text('Some Error While Fetching Data');
              }
              print(snapshot.data!.docs.length.toString());

              if (snapshot.data!.docs.isEmpty) {
                return const NoDataMessageWidget(dataOf: "Products");
              }

              return Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];

                  debugPrint(snapshot.data!.docs[index].reference.toString());
                  return Dismissible(
                    key: ValueKey(
                      snapshot.data!.docs[index].reference.toString(),
                    ),
                    onDismissed: (direction) {
                      ProductModel productModel = ProductModel(
                          productBarcode:
                              data[ProductDatabaseFieldNames.productBarcode],
                          productBrand:
                              data[ProductDatabaseFieldNames.productBrand],
                          productCategory:
                              data[ProductDatabaseFieldNames.productCategory],
                          productId: data[ProductDatabaseFieldNames.productID],
                          productManufactureName: data[ProductDatabaseFieldNames
                              .productManufacturerName],
                          productMrp: double.parse(
                              data[ProductDatabaseFieldNames.productMrp]),
                          productPurchasePrice: double.parse(data[
                              ProductDatabaseFieldNames.productPurchasePrice]),
                          productName:
                              data[ProductDatabaseFieldNames.productName],
                          productStock: int.parse(
                              data[ProductDatabaseFieldNames.productStock]),
                          productUnit:
                              data[ProductDatabaseFieldNames.productUnit],
                          productExpiryDate:
                              data[ProductDatabaseFieldNames.expiryDate]);
                      debugPrint(productModel.toString());

                      _performDeleteProduct(productModel);
                    },
                    child: InkWell(
                      onTap: () {
                        ProductModel productModel = ProductModel(
                            productBarcode:
                                data[ProductDatabaseFieldNames.productBarcode],
                            productBrand:
                                data[ProductDatabaseFieldNames.productBrand],
                            productCategory:
                                data[ProductDatabaseFieldNames.productCategory],
                            productId:
                                data[ProductDatabaseFieldNames.productID],
                            productManufactureName: data[
                                ProductDatabaseFieldNames
                                    .productManufacturerName],
                            productMrp: double.parse(
                                data[ProductDatabaseFieldNames.productMrp]),
                            productPurchasePrice: double.parse(data[
                                ProductDatabaseFieldNames
                                    .productPurchasePrice]),
                            productName:
                                data[ProductDatabaseFieldNames.productName],
                            productStock: int.parse(
                                data[ProductDatabaseFieldNames.productStock]),
                            productUnit:
                                data[ProductDatabaseFieldNames.productUnit],
                            productExpiryDate:
                                data[ProductDatabaseFieldNames.expiryDate]);
                        debugPrint(productModel.toString());

                        _performEditProductDetails(productModel);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            children: [
                              Text(
                                snapshot
                                    .data!
                                    .docs[index]
                                        [ProductDatabaseFieldNames.productName]
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
                                        snapshot
                                            .data!
                                            .docs[index][
                                                ProductDatabaseFieldNames
                                                    .expiryDate]
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    snapshot
                                        .data!
                                        .docs[index][ProductDatabaseFieldNames
                                            .productCategory]
                                        .toString(),
                                  ),
                                  Text(
                                    "MRP : ${snapshot.data!.docs[index][ProductDatabaseFieldNames.productMrp]}",
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        onPressed: _performAddNewProductDetails,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
