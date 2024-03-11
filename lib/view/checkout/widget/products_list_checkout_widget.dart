import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';

class ProductsListCheckOutWidget extends StatefulWidget {
  const ProductsListCheckOutWidget({
    super.key,
    required this.allProductsList,
  });

  final List<ProductModel> allProductsList;

  @override
  State<ProductsListCheckOutWidget> createState() =>
      _ProductsListCheckOutWidgetState();
}

class _ProductsListCheckOutWidgetState
    extends State<ProductsListCheckOutWidget> {
  List<ProductModel> foundedProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foundedProducts = widget.allProductsList;
  }

  void _runFilters(String enteredKeyword) {
    List<ProductModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.allProductsList;
    } else {
      results = widget.allProductsList
          .where((product) => product.productName
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundedProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextField(
          onChanged: (value) => _runFilters(value),
          decoration: const InputDecoration(
            labelText: "Search based on product name",
            suffixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          foundedProducts[index].productName,
                          style: GoogleFonts.getFont(
                            AppFontsNames.kBodyFont,
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                const SizedBox(width: 5),
                                Text(
                                  foundedProducts[index].productExpiryDate,
                                ),
                              ],
                            ),
                            Text(
                              foundedProducts[index].productCategory,
                            ),
                            Text(
                              "MRP : ${foundedProducts[index].productMrp}",
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: foundedProducts.length,
          ),
        ),
      ],
    );
  }
}
