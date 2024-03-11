class RouteName {
  // related to authentications
  static const String splashScreen = "/";
  static const String loginView = "/login_view";
  static const String signupView = "/signup_view";
  static const String forgetPasswordView = "/forgetPassword_view";

  // related to dashboard
  static const String dashboardView = "/dashboard_view";
  static const String shopProfileView = '/shop_profile_view';

  // main dashboard features cards
  static const String productMainView = '/product_main_screen';
  static const String checkoutView = '/checkout_screen';
  static const String productView = '/product_main_menu_screen';
  static const String reportView = '/report_screen';
  static const String ledgerView = '/ledger_screen';
  static const String alertsView = '/alerts_screen';
  static const String inventoryView = '/inventory_screen';
  static const String receiptsView = '/receipts_screen';
  static const String priceCheckView = '/price_check_screen';
  static const String manageSupplierView = '/manage_supplier_screen';
  static const String manageExpensesView = '/manage_expenses_screen';
  static const String managePaymentDetailSetting =
      '/manage_payment_details_screen';

  // sub views of manage products
  static const String addNewProductView = '/add_new_product_screen';
  static const String editProductDetailView = '/edit_product_detail_screen';
  static const String customQRCodeGenerationView =
      '/custom_qr_code_generator_Screen';

  // sub views of manage expenses
  static const String addNewExpenseView = '/add_new_expense';
  static const String editExpenseView = '/edit_expense';

  // sub views of suppliers
  static const String addNewSupplier = '/add_new_supplier_screen';
  static const String editSupplierDetails = '/edit_supplier_product_screen';

  // payment settings sub pages
  static const String easyPisaUploadDetails = "/upload_easy_pisa_details";
  static const String jazzCashUploadDetails = "/upload_jazz_cash_details";
  static const String easyPisaShowDetails = "/show_easy_pisa_details";
  static const String jazzCashShowDetails = "/show_jazz_cash_details";

  // checkout sub pages
  static const String walkInCustomerCheckOutView =
      '/walk_in_customer_checkout_view';
  static const String ledgerInCustomerCheckOutView =
      '/ledger_in_customer_checkout_view';
  static const String cartManagementView = '/cart_management_page';
  static const String openALedgerRegisteredCustomerCheckOutView =
      '/open_ledger_registered_customer_view';
  static const String addNewPurchaseInTheLedgerOfCustomer =
      '/add_new_purchase_in_ledger_customer';
  static const String openLedgerCustomerCheckOutScanning =
      '/open_ledger_customer_checkout_scanning';

  static const String ledgerCustomerCartManagementView =
      '/ledger_customer_cart_management';

  // ledger view sub pages
  static const addCustomerInLedger = "/add_new_customer_in_the_ledger";
  static const customerLedgerPurchasesView = "/customer_ledger_purchases_view";
  static const openPriceCheckFunctionality = '/open_price_check_functionality';

  //---> shop reports sub views
  static const showDailySalesView = "/show_daily_sales_view";
  static const showMonthlySalesView = "/show_monthly_sales_view";
  static const showExpiredProductsView = "/show_expired_products_view";
  static const salesVsProfitView = "/show_sales_vs_profit_view";
  static const showStockReportsView = "/show_stock_reports_view";
  static const showBestSellingProducts = "/show_best_selling_products";
  static const showAllProductsWhichAreAboutToExpireOneWeekView =
      "/show_all_products_which_are_about_to_expire_in_one_week_view";

  static const seeInvoiceDetails = "/see_invoice_details";
}
