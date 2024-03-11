import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/shop_model.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/view/alerts/alerts_main_view.dart';
import 'package:groc_pos_app/view/checkout/main_checkout_view.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/ledger_customer_checkout/ledger_customer_checkout_view.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/ledger_customer_checkout/sub_pages/add_new_purchase_in_ledger_view.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/ledger_customer_checkout/sub_pages/ledger_customer_cart_management_view.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/ledger_customer_checkout/sub_pages/open_ledger_registered_customer_checkout_product_scanning_view.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/ledger_customer_checkout/sub_pages/open_ledger_registered_customer_view.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/walk_in_customer_checkout/walk_in_customer_checkout_view.dart';
import 'package:groc_pos_app/view/dashboard/main_dashboard_view.dart';
import 'package:groc_pos_app/view/forget_password/forget_password_view.dart';
import 'package:groc_pos_app/view/ledger/manage_ledger_main_view.dart';
import 'package:groc_pos_app/view/ledger/subpages/add_new_customer_in_ledget_view.dart';
import 'package:groc_pos_app/view/ledger/subpages/ledger_customer_purchases/customer_purchases_list_main_view.dart';
import 'package:groc_pos_app/view/login/login_view.dart';
import 'package:groc_pos_app/view/manage_expenses/add_new_expense.dart';
import 'package:groc_pos_app/view/manage_expenses/edit_shop_expense.dart';
import 'package:groc_pos_app/view/manage_expenses/manage_expenses_main_view.dart';
import 'package:groc_pos_app/view/manage_products/add_new_product_view.dart';
import 'package:groc_pos_app/view/manage_products/edit_product_details_view.dart';
import 'package:groc_pos_app/view/manage_products/products_main_view.dart';
import 'package:groc_pos_app/view/manage_products/sub-view/custom_qr_code_generator_unpacked_items_view.dart';
import 'package:groc_pos_app/view/manage_recipts/manage_recipts_main_view.dart';
import 'package:groc_pos_app/view/manage_recipts/see_invoice_details.dart';
import 'package:groc_pos_app/view/manage_suppliers/add_suppliers_view.dart';
import 'package:groc_pos_app/view/manage_suppliers/edit_supplier_details_view.dart';
import 'package:groc_pos_app/view/manage_suppliers/suppliers_main_view.dart';
import 'package:groc_pos_app/view/payment_details_setting/payment_details_setting_view.dart';
import 'package:groc_pos_app/view/payment_details_setting/sub_pages/show_easy_pisa_details_view.dart';
import 'package:groc_pos_app/view/payment_details_setting/sub_pages/show_jazz_cash_details_view.dart';
import 'package:groc_pos_app/view/payment_details_setting/sub_pages/upload_easy_pisa_details_view.dart';
import 'package:groc_pos_app/view/payment_details_setting/sub_pages/upload_jazz_cash_details_view.dart';
import 'package:groc_pos_app/view/price_check/price_check_functionality_view.dart';
import 'package:groc_pos_app/view/price_check/price_check_main_view.dart';
import 'package:groc_pos_app/view/reports/report_main_view.dart';
import 'package:groc_pos_app/view/reports/sub_pages/show_all_products_which_are_about_to_expire_in_one_week_view.dart';
import 'package:groc_pos_app/view/reports/sub_pages/show_best_selling_products_view.dart';
import 'package:groc_pos_app/view/reports/sub_pages/show_daily_sales_view.dart';
import 'package:groc_pos_app/view/reports/sub_pages/show_monthly_sales_view.dart';
import 'package:groc_pos_app/view/reports/sub_pages/show_sales_vs_profit_view.dart';
import 'package:groc_pos_app/view/reports/sub_pages/show_stocks_reports_view.dart';
import 'package:groc_pos_app/view/signup/signup_view.dart';
import '../../view/checkout/sub_pages/cart_management_view/cart_management_view.dart';
import '../../view/reports/sub_pages/show_expired_products_view.dart';
import '../../view/shop_profile/manage_shop_profile_view.dart';
import '../../view/splash_screen/splash_screen_view.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.splashScreen,
          page: () => const SplashScreenView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.loginView,
          page: () => const LoginView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.signupView,
          page: () => const SignUpView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.forgetPasswordView,
          page: () => const ForgetPasswordView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.dashboardView,
          page: () => const MainDashboardView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.shopProfileView,
          page: () {
            debugPrint(
                " - ${(Get.arguments['shop_profile_data'] as ShopModel).shopName}");
            return ManageShopProfileView(
                data: Get.arguments['shop_profile_data']);
          },
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.productMainView,
          page: () => const ProductMainView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.addNewProductView,
          page: () => const AddNewProductView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.customQRCodeGenerationView,
          page: () => CustomQRCodeGenerator(
              data: Get.arguments["new_products_details"]),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.editProductDetailView,
          page: () =>
              EditProductDetailScreen(data: Get.arguments["product-details"]),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.manageExpensesView,
          page: () => const ManageExpensesView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.addNewExpenseView,
          page: () => const AddNewExpense(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.editExpenseView,
          page: () => EditExpenseView(data: Get.arguments["expense_details"]),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.manageSupplierView,
          page: () => const ManageSupplierMainView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.addNewSupplier,
          page: () => const AddNewSupplierView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.editSupplierDetails,
          page: () =>
              EditNewSupplierView(data: Get.arguments["supplier_details"]),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.managePaymentDetailSetting,
          page: () => const PaymentDetailsSettingView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.easyPisaUploadDetails,
          page: () => const UploadEasyPisaDetailsView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.jazzCashUploadDetails,
          page: () => const UploadJazzCashDetailsView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.easyPisaShowDetails,
          page: () => const ShowEasyPisaDetailsView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.jazzCashShowDetails,
          page: () => const ShowJazzCashDetailsView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.checkoutView,
          page: () => const CheckOutMainView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.walkInCustomerCheckOutView,
          page: () => const WalkInCustomerCheckOutView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.ledgerInCustomerCheckOutView,
          page: () => const LedgerCustomerCheckOutView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.ledgerView,
          page: () => const ManageLedgerMainView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.addCustomerInLedger,
          page: () => const AddNewCustomerLedgerView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.customerLedgerPurchasesView,
          page: () => CustomerPurchasesListMainView(
              data: Get.arguments["customer_details"]),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.cartManagementView,
          page: () => const CartManagementView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.priceCheckView,
          page: () => const PriceCheckMainView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.openPriceCheckFunctionality,
          page: () => const PriceCheckFunctionalityView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.openALedgerRegisteredCustomerCheckOutView,
          page: () => OpenLedgerRegisteredCustomerView(
              data: Get.arguments["customer_details"]),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.addNewPurchaseInTheLedgerOfCustomer,
          page: () => AddNewPurchaseInLedgerView(
              data: Get.arguments["customer_details"]),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.openLedgerCustomerCheckOutScanning,
          page: () => OpenLedgerRegisteredCustomerCheckOutProductScanningView(
            customerData: Get.arguments["customer_details"],
            purchaseData: Get.arguments["purchase_data"],
          ),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.ledgerCustomerCartManagementView,
          page: () => LedgerCustomerCartManagement(
            customerData: Get.arguments["customer_details"],
            purchaseData: Get.arguments["purchase_data"],
          ),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.receiptsView,
          page: () => const ManageReciptesMainView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.reportView,
          page: () => const ReportsMainView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.showDailySalesView,
          page: () => const ShowDailySalesView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.showMonthlySalesView,
          page: () => const ShowMonthlySalesView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.showExpiredProductsView,
          page: () => const ShowExpiredProductsView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.salesVsProfitView,
          page: () => const ShowSalesVsProfitView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.showStockReportsView,
          page: () => const ShowStocksReportsView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.showBestSellingProducts,
          page: () => const ShowBestSellingProductsView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.showAllProductsWhichAreAboutToExpireOneWeekView,
          page: () =>
              const ShowAllProuductsWhichAreAboutToExpireInOneWeekView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.alertsView,
          page: () => const AlertsMainView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.seeInvoiceDetails,
          page: () => SeeInvoiceDetails(
            invoiceData: Get.arguments["invoiceDetails"],
          ),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
      ];
}
