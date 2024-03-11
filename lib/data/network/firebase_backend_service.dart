import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/ledger_customer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_fields_name.dart';

class FirebaseApiService {
  final _auth = FirebaseAuth.instance;

  late dynamic _response;

  //-------- sign-up functionality ---------------------------------------------
  dynamic signUp(Map<String, dynamic> signUpData) async {
    try {
      //perform the firebase signup of the user
      final userCredentials = await _auth
          .createUserWithEmailAndPassword(
            email: signUpData[ShopDatabaseFieldNames.shopEmail],
            password: signUpData[ShopDatabaseFieldNames.shopOwnerPassword],
          )
          .timeout(
            const Duration(
              seconds: 5,
            ),
          );
      if (kDebugMode) {
        print('user credentials after create  : $userCredentials');
      }

      //storing the shop image in the firebase storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('shop_images')
          .child('${userCredentials.user!.uid}.jpg');
      await storageRef
          .putFile(signUpData[ShopDatabaseFieldNames.shopImageFile]!)
          .timeout(
            const Duration(
              seconds: 5,
            ),
          );
      // downloading the URL
      final imageUrl = await storageRef.getDownloadURL();
      print('image url is $imageUrl');

      // now saving the entire document of the user signup details
      FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(userCredentials.user!.uid)
          .set(
        {
          ShopDatabaseFieldNames.shopAddress:
              signUpData[ShopDatabaseFieldNames.shopAddress],
          ShopDatabaseFieldNames.shopID: userCredentials.user!.uid,
          ShopDatabaseFieldNames.shopName:
              signUpData[ShopDatabaseFieldNames.shopName],
          ShopDatabaseFieldNames.shopEmail:
              signUpData[ShopDatabaseFieldNames.shopEmail],
          ShopDatabaseFieldNames.shopOwnerName:
              signUpData[ShopDatabaseFieldNames.shopOwnerName],
          ShopDatabaseFieldNames.shopOwnerPhone:
              signUpData[ShopDatabaseFieldNames.shopOwnerPhone],
          ShopDatabaseFieldNames.shopImageURL: imageUrl,
          ShopDatabaseFieldNames.shopDeviceFCMToken:
              signUpData[ShopDatabaseFieldNames.shopDeviceFCMToken],
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  //--------------------- login functionality ----------------------------------
  dynamic login(String emailID, String password, String fcmDeviceToken) async {
    try {
      _response = await _auth.signInWithEmailAndPassword(
          email: emailID, password: password);

      User? currentLongedInUser = _auth.currentUser;
      var documentSnapShot = await FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentLongedInUser?.uid)
          .update({
        ShopDatabaseFieldNames.shopDeviceFCMToken: fcmDeviceToken,
      });

      return _response;
    } catch (error) {
      debugPrint('error from the firebase ***************');
      rethrow;
    }
  }

  //-------------------- check user session (for already logged in user --------
  dynamic checkUserSession() {
    try {
      final currentLoggedInUser = _auth.currentUser;
      debugPrint(currentLoggedInUser.toString());
      return currentLoggedInUser;
    } catch (error) {
      rethrow;
    }
  }

  //------- forget password functionality --------------------------------------
  dynamic forgetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  // ----------- sign-out / logout functionality -------------------------------
  void logout() {
    try {
      _auth.signOut();
    } catch (error) {
      rethrow;
    }
  }

  //----------- Fetch Shop Details ---------------------------------------------
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchShopDetailsApi() async {
    try {
      User? currentLongedInUser = _auth.currentUser;
      var documentSnapShot = await FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentLongedInUser?.uid)
          .get();
      // debugPrint(documentSnapShot.toString());
      return documentSnapShot;
    } catch (error) {
      rethrow;
    }
  }

  // ------------- Update Profile Details --------------------------------------
  Future<dynamic> updateProfileDetails(
      Map<String, dynamic> updatedProfileData) async {
    try {
      final userCredentials =
          _auth.currentUser; //storing the shop image in the firebase storage

      if (updatedProfileData['shop_image_file'] == null) {
        //this means that user has selected no to change the profile picture
        dynamic _response = FirebaseFirestore.instance
            .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
            .doc(userCredentials!.uid)
            .update({
          ShopDatabaseFieldNames.shopAddress:
              updatedProfileData[ShopDatabaseFieldNames.shopAddress],
          ShopDatabaseFieldNames.shopID: userCredentials!.uid,
          ShopDatabaseFieldNames.shopName:
              updatedProfileData[ShopDatabaseFieldNames.shopName],
          ShopDatabaseFieldNames.shopOwnerName:
              updatedProfileData[ShopDatabaseFieldNames.shopOwnerName],
          ShopDatabaseFieldNames.shopOwnerPhone:
              updatedProfileData[ShopDatabaseFieldNames.shopOwnerPhone],
          ShopDatabaseFieldNames.shopImageURL:
              updatedProfileData['reference_to_uploaded_image'],
        });
        return _response;
      } else {
        debugPrint(userCredentials.toString());
        final referenceImageUpload = FirebaseStorage.instance
            .refFromURL(updatedProfileData['reference_to_uploaded_image']);
        var imageURLNew = '';
        if (updatedProfileData[ShopDatabaseFieldNames.shopImageFile] != null) {
          referenceImageUpload.putFile(
              updatedProfileData[ShopDatabaseFieldNames.shopImageFile]!);
          imageURLNew = await referenceImageUpload.getDownloadURL();
        }

        dynamic _response = FirebaseFirestore.instance
            .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
            .doc(userCredentials!.uid)
            .update({
          ShopDatabaseFieldNames.shopAddress:
              updatedProfileData[ShopDatabaseFieldNames.shopAddress],
          ShopDatabaseFieldNames.shopID: userCredentials!.uid,
          ShopDatabaseFieldNames.shopName:
              updatedProfileData[ShopDatabaseFieldNames.shopName],
          ShopDatabaseFieldNames.shopOwnerName:
              updatedProfileData[ShopDatabaseFieldNames.shopOwnerName],
          ShopDatabaseFieldNames.shopOwnerPhone:
              updatedProfileData[ShopDatabaseFieldNames.shopOwnerPhone],
          ShopDatabaseFieldNames.shopImageURL: imageURLNew
        });
        return _response;
      }
    } catch (error) {
      rethrow;
    }
  }

  //-------- fetch all suppliers of the particular shop ------------------------
  CollectionReference<Map<String, dynamic>> fetchAllShopSuppliers() {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //now getting the reference of the child collection :supplier
      final supplierCollectionRef = parentDocumentRef
          .collection(DatabaseCollectionNames.SUPPLIERCOLLECTION);
      return supplierCollectionRef;
    } catch (error) {
      rethrow;
    }
  }

  // ------------------- add a new supplier of the shop ------------------------
  Future<bool> addNewSupplier(Map<String, dynamic> updatedProfileData) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      // getting reference to parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      // String newSupplierID =
      //     "${updatedProfileData[SupplierDatabaseFieldNames.supplierName]}:${updatedProfileData[SupplierDatabaseFieldNames.supplierEmail]}";

      await parentDocumentRef
          .collection(DatabaseCollectionNames.SUPPLIERCOLLECTION)
          .doc()
          .set(updatedProfileData);

      // await supplierNestedDocRef.set(updatedProfileData);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  //-------------------- update supplier details -------------------------------
  Future<bool> updateSupplierDetails(
      Map<String, dynamic> updatedSupplierDetails) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      // getting reference to parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      String supplierId = updatedSupplierDetails['supplier_id'];
      debugPrint(supplierId);

      await parentDocumentRef
          .collection(DatabaseCollectionNames.SUPPLIERCOLLECTION)
          .doc(supplierId)
          .update(updatedSupplierDetails);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  // -------- add new product --------------------------------------------------
  Future<bool> addNewProduct(Map<String, dynamic> newProductDetails) async {
    try {
      debugPrint(ProductDatabaseFieldNames.productID);
      User? currentUser = FirebaseAuth.instance.currentUser;
      //get the shop collection reference
      final shopCollectionParentReference = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      final productsCollectedNestedReference = shopCollectionParentReference
          .collection(DatabaseCollectionNames.PRODUCTSCOLLECTION)
          .doc(newProductDetails[ProductDatabaseFieldNames.productID]);
      await productsCollectedNestedReference.set(newProductDetails);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  //-------- fetch all products of the shop ------------------------------------
  CollectionReference<Map<String, dynamic>> fetchAllProductDetails() {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //now getting the reference of the child collection :supplier
      final productCollectionReference = parentDocumentRef
          .collection(DatabaseCollectionNames.PRODUCTSCOLLECTION);
      return productCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  // -------------------- edit product details ---------------------------------
  Future<bool> editProductDetails(
      Map<String, dynamic> editedProductDetails) async {
    try {
      //get the current firebase user
      User? currentUser = FirebaseAuth.instance.currentUser;
      //get the new product id
      String newProductDetailsDocumentID =
          editedProductDetails[ProductDatabaseFieldNames.productID];
      //get the old product id
      String oldProductDetailsDocumentID =
          editedProductDetails['old_productID'];

      //get the shop collection reference
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //first delete old one
      final oldDocumnetSnapShot = await parentDocumentRef
          .collection(DatabaseCollectionNames.PRODUCTSCOLLECTION)
          .doc(oldProductDetailsDocumentID)
          .delete();

      //now insert the new document of the product details
      //create the new document with update product-id
      final newEditedProductDetailsDocumentID = parentDocumentRef
          .collection(DatabaseCollectionNames.PRODUCTSCOLLECTION)
          .doc(newProductDetailsDocumentID);
      //insert the data in the newly created document
      Map<String, dynamic> editedProductDetailsDocument = {
        ...editedProductDetails
      };
      editedProductDetailsDocument.remove('old_productID');
      await newEditedProductDetailsDocumentID.set(editedProductDetailsDocument);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  //------------- delete-product -----------------------------------------------
  Future<bool> deleteProduct(Map<String, dynamic> deleteProduct) async {
    try {
      //get the current firebase user
      User? currentUser = FirebaseAuth.instance.currentUser;
      //get the new product id
      String productID = deleteProduct[ProductDatabaseFieldNames.productID];

      debugPrint(productID);

      //get the shop collection reference
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //first delete old one
      final oldDocumnetSnapShot = await parentDocumentRef
          .collection(DatabaseCollectionNames.PRODUCTSCOLLECTION)
          .doc(productID)
          .delete();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  //---------- add new shop expense --------------------------------------------
  Future<bool> addNewExpense(Map<String, dynamic> newExpenseData) async {
    try {
      debugPrint("revived in firebase");
      debugPrint(newExpenseData.toString());
      User? currentUser = FirebaseAuth.instance.currentUser;
      // getting reference to parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      await parentDocumentRef
          .collection(DatabaseCollectionNames.SHOPEXPENSES)
          .doc()
          .set(newExpenseData);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  //-------------- fetch all expenses ------------------------------------------
  CollectionReference<Map<String, dynamic>> fetchAllExpenses() {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //now getting the reference of the child collection :supplier
      final expenseCollectionReference =
          parentDocumentRef.collection(DatabaseCollectionNames.SHOPEXPENSES);
      return expenseCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  //----------- register the purchase in database ------------------------------
  Future<bool> registerPurchase(List<Map<String, dynamic>> updatedStocksDetails,
      Map<String, dynamic> invoiceDetails) async {
    try {
      bool status1 = await decreaseStocksAfterPurchase(updatedStocksDetails);
      bool status2 = false;
      if (status1) {
        status2 = await addNewInvoice(invoiceDetails);
      }

      return status2 && status1;
    } catch (error) {
      debugPrint("registerPurchase - ${error.toString()}");

      rethrow;
    }
  }

  Future<bool> decreaseStocksAfterPurchase(
      List<Map<String, dynamic>> updatedStocksDetails) async {
    try {
      debugPrint("updatedStockDetails - ${updatedStocksDetails.toString()}");

      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      final productsCollectionRef = parentDocumentRef
          .collection(DatabaseCollectionNames.PRODUCTSCOLLECTION);

      for (Map<String, dynamic> details in updatedStocksDetails) {
        debugPrint(details.toString());
        await productsCollectionRef
            .doc(details[ProductDatabaseFieldNames.productID].toString())
            .update({
          ProductDatabaseFieldNames.productStock:
              details[ProductDatabaseFieldNames.productStock].toString()
        });
      }
      return true;
    } catch (error) {
      debugPrint("decreaseStocksAfterPurchase - ${error}");

      debugPrint("rethrow from updateStock");
      rethrow;
    }
  }

  Future<bool> addNewInvoice(Map<String, dynamic> invoiceDetails) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      await parentDocumentRef
          .collection(DatabaseCollectionNames.INVOICES)
          .doc(invoiceDetails['bill-id'])
          .set(invoiceDetails);

      return true;
    } catch (error) {
      debugPrint("registerPurchase - ${error.toString()}");

      debugPrint("rethrow from addinvoice");
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> fetchAllInvoices() {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      final parentDocumetRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      final invoiceCollectionReference =
          parentDocumetRef.collection(DatabaseCollectionNames.INVOICES);
      return invoiceCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> fetchAllExpenseDetails() {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //now getting the reference of the child collection :supplier
      final expenseCollectionReference =
          parentDocumentRef.collection(DatabaseCollectionNames.SHOPEXPENSES);
      return expenseCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  //------------- delete-expense -----------------------------------------------
  Future<bool> deleteExpense(Map<String, dynamic> deleteExpense) async {
    try {
      //get the current firebase user
      User? currentUser = FirebaseAuth.instance.currentUser;
      //get the new product id
      String expenseID = deleteExpense[ExpenseDatabaseFieldNames.expenseID];

      debugPrint(expenseID);

      //get the shop collection reference
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //first delete old one
      final oldDocumnetSnapShot = await parentDocumentRef
          .collection(DatabaseCollectionNames.SHOPEXPENSES)
          .doc(expenseID)
          .delete();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  // -------------------- edit expense details ---------------------------------
  Future<bool> editExpenseDetails(
      Map<String, dynamic> editedProductDetails) async {
    try {
      //get the current firebase user
      User? currentUser = FirebaseAuth.instance.currentUser;

      String expenseDocumentID = editedProductDetails["old_expense_id"];

      // //get the shop collection reference
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      final documnetSnapShot = await parentDocumentRef
          .collection(DatabaseCollectionNames.SHOPEXPENSES)
          .doc(expenseDocumentID);

      documnetSnapShot.update(editedProductDetails);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteSupplierDetails(
      Map<String, dynamic> deletedSupplierDetails) async {
    try {
      //get the current firebase user
      User? currentUser = FirebaseAuth.instance.currentUser;
      //get the new product id
      String supplierID =
          deletedSupplierDetails[SupplierDatabaseFieldNames.supplierID];

      debugPrint(supplierID);

      //get the shop collection reference
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //first delete old one
      final documnetSnapShot = await parentDocumentRef
          .collection(DatabaseCollectionNames.SUPPLIERCOLLECTION)
          .doc(supplierID)
          .delete();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  dynamic uploadPaymentDetails(Map<String, dynamic> paymentDetails) async {
    try {
      //get the current user
      final userCredentials = _auth.currentUser;
      if (kDebugMode) {
        print('user credentials after create  : $userCredentials');
      }

      // get the storage reference for uploading the file
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('payment_details_qr_codes')
          .child(
              '${userCredentials!.uid}_${paymentDetails["payment_method"]}.jpg');
      await storageRef
          .putData(paymentDetails["easy_pisa_qr_code_image"])
          .timeout(
            const Duration(
              seconds: 5,
            ),
          );

      // downloading the URL
      final imageUrl = await storageRef.getDownloadURL();

      //entries the details also in the firestore
      final paymentDetailsDoc = {
        DatabasePaymentCollectionName.ACCOUNTNUMBER:
            paymentDetails[DatabasePaymentCollectionName.ACCOUNTNUMBER],
        DatabasePaymentCollectionName.PAYMENTMETHOD:
            paymentDetails[DatabasePaymentCollectionName.PAYMENTMETHOD],
        DatabasePaymentCollectionName.PAYMENTQRIMAGEURL: imageUrl
      };

      //getting the shop collection reference
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(userCredentials!.uid);

      await parentDocumentRef
          .collection(DatabaseCollectionNames.PAYMENTDETAILS)
          .doc(paymentDetailsDoc[DatabasePaymentCollectionName.PAYMENTMETHOD])
          .set(paymentDetailsDoc);

      print('image url is $imageUrl');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          '${DatabasePaymentCollectionName.PAYMENTMETHOD}_${DatabasePaymentCollectionName.PAYMENTQRIMAGEURL}',
          imageUrl);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  // Map<String, dynamic>> fetchPaymentDetails(
  //     String paymentDetailName) async {
  //   Map<String, dynamic> data = {};
  //   try {
  //     final userCredentials = _auth.currentUser;
  //     if (kDebugMode) {
  //       print('user credentials after create  : $userCredentials');
  //     }
  //     //getting the shop collection reference
  //     final parentDocumentRef = FirebaseFirestore.instance
  //         .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
  //         .doc(
  //           userCredentials!.uid,
  //         );
  //
  //     final documentReference = parentDocumentRef
  //         .collection(DatabaseCollectionNames.PAYMENTDETAILS)
  //         .doc(paymentDetailName);
  //
  //     DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
  //         await documentReference.get();
  //
  //     // Check if the document exists
  //     if (documentSnapshot.exists) {
  //       // Access the data of the document
  //       data = documentSnapshot.data()!;
  //       print('Document data: $data');
  //       return data;
  //     } else {
  //       print('Document with ID $paymentDetailName  not exist.');
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  //   return null;
  // }

  // Future<Map<String, dynamic>?> fetchPaymentDetails(
  //     String paymentDetailName) async {
  //   try {
  //     final userCredentials = _auth.currentUser;
  //     //getting the shop collection reference
  //     final parentDocumentRef = FirebaseFirestore.instance
  //         .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
  //         .doc(
  //           userCredentials!.uid,
  //         );
  //
  //     final documentReference = parentDocumentRef
  //         .collection(DatabaseCollectionNames.PAYMENTDETAILS)
  //         .doc(paymentDetailName);
  //
  //     DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
  //         await documentReference.get();
  //
  //     if (documentSnapshot.exists) {
  //       // Access the data of the document
  //       Map<String, dynamic> data = documentSnapshot.data()!;
  //       print('Document data: $data');
  //       return data;
  //     } else {
  //       print('Document with ID $paymentDetailName  not exist.');
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  //   return null;
  // }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchPaymentDetails(
      String paymentDetailName) async {
    try {
      final userCredentials = _auth.currentUser;
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(
            userCredentials!.uid,
          );
      final documentReference = parentDocumentRef
          .collection(DatabaseCollectionNames.PAYMENTDETAILS)
          .doc(paymentDetailName);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await documentReference.get();
      return documentSnapshot;
    } catch (error) {
      rethrow;
    }
  }

  // --------- ledger related calls --------------------------------------------
  //---------- add new customer in the ledger --------------------------------------------
  Future<bool> addNewCustomerInLedger(
      Map<String, dynamic> newCustomerDataInLedger) async {
    try {
      debugPrint("revived in firebase");
      debugPrint(newCustomerDataInLedger.toString());
      User? currentUser = FirebaseAuth.instance.currentUser;
      // getting reference to parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      CollectionReference ledgerCollectionReference =
          parentDocumentRef.collection(DatabaseCollectionNames.LEDGEER);

      DocumentReference newCustomerDocumentReference =
          ledgerCollectionReference.doc();
      newCustomerDocumentReference.set(newCustomerDataInLedger);

      // newCustomerDocumentReference
      //     .collection(DatabaseCollectionNames.LEDGER_PURCHASES);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  //-------------- fetch all ladger data ------------------------------------------
  CollectionReference<Map<String, dynamic>> fetchAllLedgerData() {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //now getting the reference of the child collection :supplier
      final ledgerCollectionReference =
          parentDocumentRef.collection(DatabaseCollectionNames.LEDGEER);
      return ledgerCollectionReference;
    } catch (error) {
      rethrow;
    }
  }

  //------------- delete-expense -----------------------------------------------
  Future<bool> deleteLedgerCustomer(
      Map<String, dynamic> deleteCustomerDetails) async {
    try {
      //get the current firebase user
      User? currentUser = FirebaseAuth.instance.currentUser;
      //get the new product id
      String customerLedgerID = deleteCustomerDetails[
          LedgerCustomerDatabaseFieldNames.customerLedgerID];

      debugPrint(customerLedgerID);

      //get the shop collection reference
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //first delete old one
      final oldDocumnetSnapShot = await parentDocumentRef
          .collection(DatabaseCollectionNames.LEDGEER)
          .doc(customerLedgerID)
          .delete();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  //--------------- register a purchase of customer in the ledger --------------
  Future<bool> registerPurchaseInLedger(
    List<Map<String, dynamic>> updatedStocks,
    Map<String, dynamic> invoiceDetails,
    Map<String, dynamic> purchaseDataForLedger,
    LedgerCustomerModel customerData,
  ) async {
    try {
      bool status1 = await decreaseStocksAfterPurchase(updatedStocks);
      bool status2 = false;
      bool status3 = false;
      if (status1) {
        status2 = await addNewInvoice(invoiceDetails);
        if (status2) {
          status3 =
              await addNewPurchaseInLedger(purchaseDataForLedger, customerData);
        }
      }

      return status2 && status1 && status3;
    } catch (error) {
      debugPrint("registerPurchase - ${error.toString()}");

      rethrow;
    }
  }

  // add new purchase in the ledger
  Future<bool> addNewPurchaseInLedger(
      Map<String, dynamic> purchaseDataForLedger,
      LedgerCustomerModel ledgerCustomerModel) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      DocumentReference customerDocumentReference = await parentDocumentRef
          .collection(DatabaseCollectionNames.LEDGEER)
          .doc(ledgerCustomerModel.customerID);

      double newAmountDue = 0;
      DocumentSnapshot customerDocumentSnapshot =
          await customerDocumentReference.get();

      if (customerDocumentSnapshot.exists) {
        // Access data from the document
        Map<String, dynamic> customerData =
            customerDocumentSnapshot.data() as Map<String, dynamic>;
        print('Customer Data: $customerData');
        debugPrint(
            " ledger- ${double.parse(customerData['ledger-customer-total-amount-due'].toString())}");

        newAmountDue =
            double.parse(customerData['ledger-customer-total-amount-due']);
      } else {
        print('Document does not exist');
      }

      debugPrint("new purchase data - ${purchaseDataForLedger.toString()}");

      newAmountDue += purchaseDataForLedger['grand_total_purchase'];
      debugPrint("new amount due - ${newAmountDue}");

      customerDocumentReference.update({
        'ledger-customer-total-amount-due': newAmountDue.toString(),
      });

      await customerDocumentReference
          .collection(DatabaseCollectionNames.LEDGER_PURCHASES)
          .doc()
          .set(purchaseDataForLedger);

      return true;
    } catch (error) {
      debugPrint("registerPurchase - ${error.toString()}");

      debugPrint("rethrow from addinvoice");
      rethrow;
    }
  }

  // fetch all the ledger purchases of the customer
  // -------------- fetch all ladger data ------------------------------------------
  CollectionReference<Map<String, dynamic>> fetchAllLedgerCustomerPurchases(
      String customerID) {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      //now getting the reference of the child collection :supplier
      DocumentReference customerDocumentReference = parentDocumentRef
          .collection(DatabaseCollectionNames.LEDGEER)
          .doc(customerID);

      return customerDocumentReference
          .collection(DatabaseCollectionNames.LEDGER_PURCHASES);
    } catch (error) {
      rethrow;
    }
  }

  //-----------------close a ledger purchase record ----------------------------
  Future<bool> closeAPurchaseRecordInLedger(
      Map<String, dynamic> closePurchaseData) async {
    try {
      debugPrint(
          "closeAPurchaseRecordInLedger - ${closePurchaseData.toString()}");

      User? currentUser = FirebaseAuth.instance.currentUser;
      //getting the reference to the parent collection
      final parentShopDocumentRef = FirebaseFirestore.instance
          .collection(DatabaseCollectionNames.SHOPCOLLECTIONNAME)
          .doc(currentUser!.uid);

      final ledgerDocumentRef =
          parentShopDocumentRef.collection(DatabaseCollectionNames.LEDGEER);

      LedgerCustomerModel customerData =
          (closePurchaseData['ledger_customer_data'] as LedgerCustomerModel);

      debugPrint(((double.parse(customerData.customerTotalAmountDue).abs()) -
              (closePurchaseData['amount_paid_by_customer_for_ledger_close']))
          .toString());

      final customerLedgerDocumentRef =
          ledgerDocumentRef.doc(customerData.customerID);
      // make changes in the customer-purchase collection and change amount to be paid. grand total, purchase done->true
      final customerPruchasesInLedgerColeectionRef = customerLedgerDocumentRef
          .collection(DatabaseCollectionNames.LEDGER_PURCHASES);
      customerPruchasesInLedgerColeectionRef
          .doc(closePurchaseData['purhcase_id'])
          .update({
        'amount_to_be_paid': 0,
        'amount_paid_by_customer':
            closePurchaseData['amount_paid_by_customer_for_ledger_close'] -
                closePurchaseData['change_amount'],
        'grand_total_purchase': double.parse(
                closePurchaseData['entire_purchase_data_snapshot']
                        ['grand_total_purchase']
                    .toString())
            .abs(),
        'purchase_done': true,
        'date_of_payment': closePurchaseData['date_of_payment'].toString(),
      });

      debugPrint(
          "OLD ledger-customer-total-amount-due :${double.parse(customerData.customerTotalAmountDue).abs()}");
      debugPrint(
          "OLD current_purchase_grand_total :${closePurchaseData['current_purchase_grand_total']}");

      // make changes in the customer of ledger total ledger amount -
      await customerLedgerDocumentRef.update({
        'ledger-customer-total-amount-due':
            (double.parse(customerData.customerTotalAmountDue).abs() -
                    (double.parse(
                            closePurchaseData['current_purchase_grand_total']
                                .toString())
                        .abs()))
                .abs()
                .toString()
      });

      // make changes in the invoice
      final invoiceCollectionRef =
          parentShopDocumentRef.collection(DatabaseCollectionNames.INVOICES);
      await invoiceCollectionRef
          .doc(closePurchaseData['entire_purchase_data_snapshot']
              ['invoice_data']['bill-id'])
          .update({
        'amount-paid-by-customer':
            closePurchaseData['amount_paid_by_customer_for_ledger_close'],
        'grand-total': double.parse(
                closePurchaseData['entire_purchase_data_snapshot']
                        ['grand_total_purchase']
                    .toString())
            .abs(),
        'change-amount': closePurchaseData['change_amount'],
      });

      // get the new updated invoice
      Map<String, dynamic> newUpdatedInvoice = {};
      DocumentSnapshot<Map<String, dynamic>> invoiceDocumentSnapshot =
          await invoiceCollectionRef
              .doc(closePurchaseData['entire_purchase_data_snapshot']
                  ['invoice_data']['bill-id'])
              .get();
      if (invoiceDocumentSnapshot.exists) {
        // Convert the document data to a map
        newUpdatedInvoice = invoiceDocumentSnapshot.data()!;

        customerLedgerDocumentRef
            .collection(DatabaseCollectionNames.LEDGER_PURCHASES);
        customerPruchasesInLedgerColeectionRef
            .doc(closePurchaseData['purhcase_id'])
            .update({
          'invoice_data': newUpdatedInvoice,
        });
      } else {
        // Document does not exist
      }
      return true;
    } catch (error) {
      debugPrint("closeAPurchaseRecordInLedger - ${error.toString()}");
      rethrow;
    }
  }
}
