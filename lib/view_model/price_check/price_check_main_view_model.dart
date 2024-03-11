import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/product_model.dart';

import '../../repository/product_repository.dart';

class PriceCheckMainViewModel extends GetxController {
  final ProductRepository _productRepository = ProductRepository();
  Rx<List<ProductModel>> allProductsList = Rx<List<ProductModel>>([]);

  fetchAllProducts() async {
    try {
      CollectionReference<Map<String, dynamic>> productsCollectionReference =
          _productRepository.fetchAllProducts();

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await productsCollectionReference.get();

      // Loop through the documents to extract data
      final List<ProductModel> allProductsModels = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        Map<String, dynamic> data = document.data();
        debugPrint(" - ${data}");

        // Access your data here
        ProductModel newProduct = ProductModel(
            productBarcode: data["product_barcode"],
            productBrand: data["product_brand"],
            productCategory: data["product_category"],
            productId: data["product_id"],
            productManufactureName: data["product_manufacturer_name"],
            productMrp: double.parse(data["product_mrp"]),
            productPurchasePrice: double.parse(data["product_purchase_price"]),
            productName: data["product_name"],
            productStock: int.parse(data["product_stock"]),
            productUnit: data["product_unit"],
            productExpiryDate: data["expiry_date"]);
        allProductsModels.add(newProduct);
      }
      if (allProductsModels.isNotEmpty) {
        allProductsList.value = allProductsModels;
        debugPrint(
            "all products list - ${allProductsList.value.length.toString()}");
      }
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }
}
