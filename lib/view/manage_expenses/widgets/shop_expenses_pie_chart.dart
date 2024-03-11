import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/pie_chart_colors.dart';
import 'package:groc_pos_app/resources/constants/product_categories_colors_list.dart';
import 'package:groc_pos_app/resources/constants/product_categories_list.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/indication_pie_chart.dart';

import '../../../view_model/manage_expenses/pie_chart_controller.dart';

class ShopExpensesPieChart extends StatefulWidget {
  const ShopExpensesPieChart({super.key});

  @override
  State<StatefulWidget> createState() => _ShopExpensesPieChartState();
}

class _ShopExpensesPieChartState extends State<ShopExpensesPieChart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pieChartViewModel.fetchAllExpensesData();
  }

  final pieChartViewModel = Get.put(PieChartViewModel());
  double totalExpenseSum = 0;

  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (pieChartViewModel.allExpensesList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Please Wait Loading the data.... / Or Not Expenses has been added yet",
                style: GoogleFonts.getFont(
                  AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return AspectRatio(
          aspectRatio: 1.3,
          child: Column(
            children: [
              Obx(
                () => Text(
                  "Total Expenses ${pieChartViewModel.totalExpense.value.toString()} PKR",
                  style: GoogleFonts.getFont(AppFontsNames.kBodyFont,
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                  kProductCategoryList.length == kProductCategoryList.length
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0;
                                i < kProductCategoryList.length;
                                i++) ...[
                              Indicator(
                                color: kproductCategoriesColorList[i],
                                text: kProductCategoryList[i],
                                isSquare: true,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ]
                          ],
                        )
                      : const Text("Some Thing Went Wrong..."),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    });
  }

  List<PieChartSectionData> showingSections() {
    //make an empty list to categorize all the product categories
    final List<Map<String, dynamic>> pieChartSectionData = [];

    //create a new map that will have combined expenditure per category
    for (int index = 0; index < kProductCategoryList.length; index++) {
      pieChartSectionData.add({
        "expense-category": kProductCategoryList[index],
        "total-category-amount": 0.0,
      });
    }

    // logic to collect the expenditure in to different categorizes buckets
    for (int index = 0;
        index < pieChartViewModel.allExpensesList.value.length;
        index++) {
      //find category
      final expenseCategory =
          pieChartViewModel.allExpensesList.value[index]["expense-category"];
      final expenseCategoryIndex =
          kProductCategoryList.indexOf(expenseCategory.toString());

      pieChartSectionData[expenseCategoryIndex]["total-category-amount"] +=
          double.parse(
              pieChartViewModel.allExpensesList.value[index]["expense-amount"]);
    }

    // finding  the total sum
    totalExpenseSum = 0;
    for (var cat in pieChartSectionData) {
      // print(cat["total-category-amount"]);
      totalExpenseSum += cat["total-category-amount"];
    }
    pieChartViewModel.setTotalExpenses(totalExpenseSum);

    return pieChartSectionData.asMap().entries.map((category) {
      int index = category.key;
      Map<String, dynamic> data = category.value;
      // print('Index: $index, Data: $data');

      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: kproductCategoriesColorList[
            kProductCategoryList.indexOf(data["expense-category"])],
        value: data["total-category-amount"],
        // title: '${((data["total-category-amount"] / totalExpenseSum) * 100)}%',
        title:
            '${((data['total-category-amount'] / totalExpenseSum) * 100).toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.mainTextColor1,
          shadows: shadows,
        ),
      );
    }).toList();
  }
}
