import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/models/invoice_model.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';

class SeeInvoiceDetails extends StatefulWidget {
  SeeInvoiceDetails({super.key, required this.invoiceData});
  dynamic invoiceData;

  @override
  State<SeeInvoiceDetails> createState() => _SeeInvoiceDetailsState();
}

class _SeeInvoiceDetailsState extends State<SeeInvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    InvoiceModel invoiceModel = (widget.invoiceData) as InvoiceModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Cart",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Invoice Details",
                style: GoogleFonts.getFont(
                  AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Customer Name :${invoiceModel.customerName}",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Customer Type ${invoiceModel.customerType}",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Discount Percentage ${invoiceModel.discountPercentage}",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Sub Total ${invoiceModel.subTotal}",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Grand Total ${invoiceModel.grandTotal}",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Inovice ID: ${invoiceModel.billID}",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Date Time ${invoiceModel.invoiceDateTime}",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Products Purchase",
                style: GoogleFonts.getFont(
                  AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Center(
                child: Card(
                  child: SizedBox(
                    height: 600,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Text(
                                  invoiceModel.productList[index].productName
                                      .toString(),
                                  style: GoogleFonts.getFont(
                                    AppFontsNames.kBodyFont,
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Price MRP: ${invoiceModel.productList[index].productMrp.toString()} PKR'),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Product Quantity: ${invoiceModel.productList[index].productQuantityInCart.toString()} PKR'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: invoiceModel.productList.length,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
