import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/data/network/database_fields_name.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/widgets_components/rounded_button.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../../view_model/payment_details/jazz_cash_payment_details_view_model.dart';

class UploadJazzCashDetailsView extends StatefulWidget {
  const UploadJazzCashDetailsView({super.key});

  @override
  State<UploadJazzCashDetailsView> createState() =>
      _UploadJazzCashDetailsViewState();
}

class _UploadJazzCashDetailsViewState extends State<UploadJazzCashDetailsView> {
  final TextEditingController accountNumberDetails = TextEditingController();
  String _shopImageURL = '';
  File? _selectedImage;
  Uint8List? _image;
  bool isUploaded = false;
  void _setSelectedImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  pickImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_file != null) {
      return await _file.readAsBytes();
    }
  }

  _selectQRCodeFromGallery() async {
    if (accountNumberDetails.text.isEmpty) {
      AppUtils.errorDialog(context, "No Account Number is Entered",
          "No Account Number is entered. Please first enter the account number then select image from gallery");
      return;
    } else {
      Uint8List img = await pickImage();
      _image = img;
      setState(() {
        _image = img;
      });
    }
  }

  _uploadImageToDatabase() async {
    if (accountNumberDetails.text.isEmpty || _image == null) {
      AppUtils.errorDialog(context, "No Account Number is Entered",
          "No Account Number is entered. Please first enter the account number then select image from gallery");
      return;
    }

    setState(() {
      isUploaded = true;
    });
    dynamic paymentDetails = {
      DatabasePaymentCollectionName.ACCOUNTNUMBER:
          accountNumberDetails.text.trim().toString(),
      DatabasePaymentCollectionName.PAYMENTQRIMAGEIMAGE: _image,
      DatabasePaymentCollectionName.PAYMENTMETHOD: "jazz-cash"
    };
    bool status = await JazzCashPaymentDetailsViewModel()
        .uploadEasyPisaDetails(paymentDetails, context);

    debugPrint(" - $isUploaded");

    setState(() {
      isUploaded = !status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Payment Details Upload Here",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              Center(
                child: Text(
                  'Upload Jazz Cash Detail Here',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    AppFontsNames.kBodyFont,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff246bdd),
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: accountNumberDetails,
                decoration: const InputDecoration(
                  hintText: 'Jazz Cash Account Number',
                  helperText: "E.g :0333-123456789",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                title: "Select QR Code From Gallery",
                onTap: _selectQRCodeFromGallery,
              ),
              Container(
                child: _image != null
                    ? Column(
                        children: [
                          Image(
                              height: 200,
                              width: 250,
                              image: MemoryImage(_image!)),
                          Text(
                              "Jazz Cash QR Code for Account Number ${accountNumberDetails.text.trim()}")
                        ],
                      )
                    : const Column(
                        children: [
                          Image(
                            height: 200,
                            width: 250,
                            image: AssetImage(
                              "assets/images/please_upload_qr.jpeg",
                            ),
                          ),
                          Text("No QR Code Selected From Gallery"),
                        ],
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                loading: isUploaded,
                title: "Upload QR Code To System",
                onTap: _uploadImageToDatabase,
              ),
              // Image.network(
              //     "https://firebasestorage.googleapis.com/v0/b/groc-pos-app.appspot.com/o/payment_details_qr_codes%2FUiECmNyAAudZdxSLByat4hAqwHL2_easy-pisa.jpg?alt=media&token=3a6217a1-0ad3-4245-8009-5b9ec882c395")
            ],
          ),
        ),
      ),
    );
  }
}
