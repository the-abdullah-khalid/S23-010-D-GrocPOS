class ShopDatabaseFieldNames {
  //************************ RELATED TO SHOP COLLECTION ************************
  static const shopAddress = 'shop_address';
  static const shopID = 'shop_id';
  static const shopImageURL = 'shop_image_url';
  static const shopImageFile = 'shop_image_file';
  static const shopName = 'shop_name';
  static const shopEmail = 'shop_owner_email';
  static const shopOwnerName = 'shop_owner_name';
  static const shopOwnerPhone = 'shop_owner_phone';
  static const shopOwnerPassword = 'shop_owner_password';
  static const shopDeviceFCMToken = 'shop_device_fcm_token';
}

class SupplierDatabaseFieldNames {
  static const String collection = "suppliers";
  static const String supplierPhoneNo = 'supplier_phone_no';
  static const String supplierAddress = 'supplier_address';
  static const String supplierEmail = 'supplier_email';
  static const String supplierOf = 'supplier_of';
  static const String supplierName = 'supplier_name';
  static const String supplierShopName = 'supplier_shop_name';
  static const String supplierID = 'supplier_id';
}

class ProductDatabaseFieldNames {
  static const String productBarcode = 'product_barcode';
  static const String productBrand = 'product_brand';
  static const String productCategory = 'product_category';
  static const String productManufacturerName = 'product_manufacturer_name';
  static const String productMrp = 'product_mrp';
  static const String productName = 'product_name';
  static const String productPurchasePrice = 'product_purchase_price';
  static const String productStock = 'product_stock';
  static const String productUnit = 'product_unit';
  static const String productID = 'product_id';
  static const String expiryDate = 'expiry_date';
}

class ExpenseDatabaseFieldNames {
  static const String expenseAmount = 'expense-amount';
  static const String expenseCategory = 'expense-category';
  static const String expenseDate = 'expense-date';
  static const String expenseNote = 'expense-note';
  static const String expenseTitle = 'expense-title';
  static const String expenseID = 'expense_id';
}

class DatabaseCollectionNames {
  static const SHOPCOLLECTIONNAME = 'retail-shop-users';
  static const String SUPPLIERCOLLECTION = "suppliers";
  static const String PRODUCTSCOLLECTION = "products";
  static const String SHOPEXPENSES = "expenses";
  static const String INVOICES = "invoices";
  static const String PAYMENTDETAILS = 'payment_details';
  static const String LEDGEER = 'ledger';
  static const String LEDGER_PURCHASES = 'customer_purchases_ledger';
}

class DatabasePaymentCollectionName {
  static const String ACCOUNTNUMBER = "account_number";
  static const String PAYMENTMETHOD = "payment_method";
  static const String PAYMENTQRIMAGEURL = "payment_qr_image_url";
  static const String PAYMENTQRIMAGEIMAGE = "easy_pisa_qr_code_image";
}

class LedgerCustomerDatabaseFieldNames {
  static const String customerName = 'ledger-customer-name';
  static const String customerAddress = 'ledger-customer-address';
  static const String customerCNIC = 'ledger-customer-cnic';
  static const String customerPhoneNo = 'ledger-customer-phone-number';
  static const String customerTotalAmountDue =
      'ledger-customer-total-amount-due';
  static const String customerLedgerID = 'ledger_customer_id';
}

class InvoiceDatabaseFieldNames {
  static const String amountPaidByCustomer = 'amount-paid-by-customer';
  static const String billID = 'bill-id';
  static const String changeAmount = 'change-amount';
  static const String customerName = 'customer-name';
  static const String dateTime = 'date-time';
  static const String discountPercentage = 'discount-percentage';
  static const String grandTotal = 'grand-total';
  static const String productsList = 'products-list';
  static const String subTotal = 'sub-total';
}
