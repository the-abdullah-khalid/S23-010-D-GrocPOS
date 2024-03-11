import 'package:get/get.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';

final kFeatureCategoryList = [
  {
    'title': 'checkout',
    'icon': 'assets/icons/checkout.png',
    'routeName': RouteName.checkoutView
  },
  {
    'title': 'products',
    'icon': 'assets/icons/products.png',
    'routeName': RouteName.productMainView
  },
  {
    'title': 'reports',
    'icon': 'assets/icons/report.png',
    'routeName': RouteName.reportView
  },
  {
    'title': 'ledger',
    'icon': 'assets/icons/ledger.png',
    'routeName': RouteName.ledgerView
  },
  // {
  //   'title': 'alerts',
  //   'icon': 'assets/icons/alerts.png',
  //   'routeName': RouteName.alertsView
  // },
  {
    'title': 'expenses',
    'icon': 'assets/icons/inventory.png',
    'routeName': RouteName.manageExpensesView
  },
  {
    'title': 'recipts',
    'icon': 'assets/icons/recipts.png',
    'routeName': RouteName.receiptsView
  },
  {
    'title': "price_check",
    'icon': 'assets/icons/pricecheck.png',
    'routeName': RouteName.priceCheckView
  },
  {
    'title': "suppliers",
    'icon': 'assets/icons/packages.png',
    'routeName': RouteName.manageSupplierView
  },
  {
    'title': "payment_settings",
    'icon': 'assets/icons/payment_settings.png',
    'routeName': RouteName.managePaymentDetailSetting
  },
];
