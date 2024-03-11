import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';

class ShopModel {
  final String shopAddress;
  final String shopId;
  final String shopName;
  final String shopOwnerEmail;
  final String shopOwnerPhone;
  final String shopOwnerName;
  final String shopProfileImageUrl;

  ShopModel(
      {required this.shopAddress,
      required this.shopId,
      required this.shopName,
      required this.shopOwnerEmail,
      required this.shopOwnerPhone,
      required this.shopOwnerName,
      required this.shopProfileImageUrl});

  toJson() {
    return {
      "shop_address": shopAddress,
      "shop_id": shopId,
      "shop_name": shopName,
      "shop_owner_email": shopOwnerEmail,
      "shop_owner_phone": shopOwnerPhone,
      "shop_owner_name": shopOwnerName,
      "shop_profile_image_url": shopProfileImageUrl,
    };
  }

  factory ShopModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;

    debugPrint(data.toString());

    if (data == null) {
      return ShopModel(
          shopAddress: "",
          shopId: "",
          shopName: "",
          shopOwnerEmail: "",
          shopOwnerPhone: "",
          shopOwnerName: "",
          shopProfileImageUrl: "");
    }
    return ShopModel(
      shopAddress: data[ShopDatabaseFieldNames.shopAddress],
      shopId: data[ShopDatabaseFieldNames.shopID],
      shopName: data[ShopDatabaseFieldNames.shopName],
      shopOwnerEmail: data[ShopDatabaseFieldNames.shopEmail],
      shopOwnerName: data[ShopDatabaseFieldNames.shopOwnerName],
      shopOwnerPhone: data[ShopDatabaseFieldNames.shopOwnerPhone],
      shopProfileImageUrl: data[ShopDatabaseFieldNames.shopImageURL],
    );
  }
}
