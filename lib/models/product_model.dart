import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';

class ProductModel {
  final String productBarcode;
  final String productBrand;
  final String productCategory;
  final String productId;
  final String productManufactureName;
  final double productMrp;
  final double productPurchasePrice;
  final String productName;
  final int productStock;
  final String productUnit;
  final String productExpiryDate;
  int productQuantityInCart = 1;

  ProductModel({
    required this.productBarcode,
    required this.productBrand,
    required this.productCategory,
    required this.productId,
    required this.productManufactureName,
    required this.productMrp,
    required this.productPurchasePrice,
    required this.productName,
    required this.productStock,
    required this.productUnit,
    required this.productExpiryDate,
  });

  toJson() {
    return {
      "product_barcode": productBarcode,
      "product_brand": productBrand,
      "product_category": productCategory,
      "product_id": productId,
      "product_manufacturer_name": productManufactureName,
      "product_mrp": productMrp,
      "product_purchase_price": productPurchasePrice,
      "product_name": productName,
      "product_stock": productStock,
      "product_unit": productUnit,
      "expiry_date": productExpiryDate,
    };
  }

  @override
  String toString() {
    return 'ProductModel{product_barcode: $productBarcode, product_brand: $productBrand, product_category: $productCategory, product_id: $productId, product_manufacture_name: $productManufactureName, product_mrp: $productMrp, product_purchase_price: $productPurchasePrice, product_name: $productName, product_stock: $productStock, product_unit: $productUnit, product_expiry:$productExpiryDate}';
  }

  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;

    debugPrint(data.toString());
    return ProductModel(
      productBarcode: data[ProductDatabaseFieldNames.productBarcode],
      productBrand: data[ProductDatabaseFieldNames.productBrand],
      productCategory: data[ProductDatabaseFieldNames.productCategory],
      productId: data[ProductDatabaseFieldNames.productID],
      productManufactureName:
          data[ProductDatabaseFieldNames.productManufacturerName],
      productMrp: data[ProductDatabaseFieldNames.productMrp],
      productPurchasePrice:
          data[ProductDatabaseFieldNames.productPurchasePrice],
      productName: data[ProductDatabaseFieldNames.productName],
      productStock: data[ProductDatabaseFieldNames.productStock],
      productUnit: data[ProductDatabaseFieldNames.productUnit],
      productExpiryDate: data[ProductDatabaseFieldNames.expiryDate],
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    // debugPrint("ProductModel.fromMap - ${data.toString()}");

    return ProductModel(
      productBarcode: data[ProductDatabaseFieldNames.productBarcode],
      productBrand: data[ProductDatabaseFieldNames.productBrand],
      productCategory: data[ProductDatabaseFieldNames.productCategory],
      productId: data[ProductDatabaseFieldNames.productID],
      productManufactureName:
          data[ProductDatabaseFieldNames.productManufacturerName],
      productMrp: data[ProductDatabaseFieldNames.productMrp],
      productPurchasePrice:
          data[ProductDatabaseFieldNames.productPurchasePrice],
      productName: data[ProductDatabaseFieldNames.productName],
      productStock: data[ProductDatabaseFieldNames.productStock],
      productUnit: data[ProductDatabaseFieldNames.productUnit],
      productExpiryDate: data[ProductDatabaseFieldNames.expiryDate],
    );
  }
}
