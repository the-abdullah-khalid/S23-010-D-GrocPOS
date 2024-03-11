import 'package:get/get.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/view_model/reports/reports_main_view_model.dart';

class ShowStockReportsViewModel extends GetxController {
  final reportsMainViewModelController = Get.find<ReportsMainViewModel>();

  List<ProductModel> fetchAllProductsList() {
    return reportsMainViewModelController.allProductsList.value;
  }
}
