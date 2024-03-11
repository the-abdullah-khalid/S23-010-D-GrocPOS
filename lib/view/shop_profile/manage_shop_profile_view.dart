import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view/shop_profile/widgets/manage_shop_profile_details_form.dart';
import 'package:groc_pos_app/view_model/shop_profile/manage_shop_profile_view_model.dart';

import '../../data/network/database_fields_name.dart';
import '../../models/shop_model.dart';
import '../../resources/colors/app_colors.dart';
import '../../resources/widgets_components/rounded_button.dart';
import '../../utils/utils.dart';

class ManageShopProfileView extends StatefulWidget {
  dynamic data;

  ManageShopProfileView({super.key, required this.data});

  @override
  State<ManageShopProfileView> createState() => _ManageShopProfileViewState();
}

class _ManageShopProfileViewState extends State<ManageShopProfileView> {
  ShopModel? _shopModel;
  bool isContentLoaded = true;
  bool? isProfileUpdated;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopOwnerNameController =
      TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddress = TextEditingController();
  final TextEditingController _shopPhoneNo = TextEditingController();

  final manageShopProfileViewModel = Get.put(ManageShopProfileViewModel());
  String _shopImageURL = '';
  File? _selectedImage;

  void _setSelectedImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  void loadUserProfile() {
    if (widget.data == null) {
      isContentLoaded = true;
    } else {
      setState(() {
        debugPrint(" profile screen- ${widget.data}");

        _shopModel = widget.data;

        debugPrint(_shopModel!.shopOwnerName.toString());

        _shopOwnerNameController.text = _shopModel!.shopOwnerName;
        _shopNameController.text = _shopModel!.shopName;
        _shopAddress.text = _shopModel!.shopAddress;
        _shopPhoneNo.text = _shopModel!.shopOwnerPhone;
        _shopImageURL = _shopModel!.shopProfileImageUrl;
      });
    }
  }

  void updateShopProfileDetails() {
    bool goBack = false;

    if (_selectedImage == null && _shopImageURL.isEmpty) {
      AppUtils.errorDialog(
        context,
        'No Image Uploaded',
        'Please Enter your shop picture',
      );
      goBack = true;
    }

    if (!_formKey.currentState!.validate()) {
      AppUtils.errorDialog(
        context,
        'Form Not Filled Properly',
        'Please fill the form as directed',
      );
      goBack = true;
    }
    if (goBack) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (kDebugMode) {
        print("form signup clicked");
      }
      // making a map of all the data from the front end side
      Map<String, dynamic> userData = {
        ShopDatabaseFieldNames.shopOwnerName:
            _shopOwnerNameController.text.toString(),
        ShopDatabaseFieldNames.shopName: _shopNameController.text.toString(),
        ShopDatabaseFieldNames.shopAddress: _shopAddress.text.toString(),
        ShopDatabaseFieldNames.shopOwnerPhone: _shopPhoneNo.text.toString(),
        ShopDatabaseFieldNames.shopImageFile: _selectedImage,
        'reference_to_uploaded_image': _shopImageURL,
      };

      manageShopProfileViewModel
          .updateUserProfileDetails(userData, context)
          .then(
            (value) => Get.back(result: "true"),
          );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("init state called");
    loadUserProfile();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _shopPhoneNo.dispose();
    _shopAddress.dispose();
    _shopNameController.dispose();
    _shopOwnerNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;
    if (isContentLoaded) {
      content = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                'Shop Profile Page',
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
              const SizedBox(
                height: 20,
              ),
              ManageProfileDetailsForm(
                formKey: _formKey,
                nameController: _shopOwnerNameController,
                shopNameController: _shopNameController,
                shopAddress: _shopAddress,
                shopPhoneNo: _shopPhoneNo,
                onPickedImage: _setSelectedImage,
                shopImageURL: _shopImageURL,
              ),
              const SizedBox(
                height: 30,
              ),
              Obx(
                () => RoundButton(
                  loading: manageShopProfileViewModel.buttonStatus.value,
                  title: 'Update Shop Details',
                  onTap: updateShopProfileDetails,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      content = Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: CustomAppColors.mainThemeColorBlueLogo,
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'Please Wait !! Loading the content',
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Groc-POS Manage Profile",
            style: GoogleFonts.getFont(
              AppFontsNames.kBodyFont,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: content,
    );
  }
}
