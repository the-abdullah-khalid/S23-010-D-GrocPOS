import 'dart:io';

import 'package:flutter/material.dart';

import '../../../resources/colors/app_colors.dart';
import '../../../utils/utils.dart';
import '../../signup/widgets/shop_profile_image_picker.dart';

class ManageProfileDetailsForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController shopNameController;
  final TextEditingController shopAddress;
  final TextEditingController shopPhoneNo;
  String shopImageURL = '';

  final void Function(File pickedImage) onPickedImage;

  ManageProfileDetailsForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.shopNameController,
    required this.shopAddress,
    required this.shopPhoneNo,
    required this.onPickedImage,
    required this.shopImageURL,
  });

  @override
  State<ManageProfileDetailsForm> createState() =>
      _ManageProfileDetailsFormState();
}

class _ManageProfileDetailsFormState extends State<ManageProfileDetailsForm> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  FocusNode nameFocus = FocusNode();
  FocusNode shopNameFocus = FocusNode();
  FocusNode shopAddressFocus = FocusNode();
  FocusNode shopPhoneNoFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          ShopProfileImagePicker(
            imagePath: widget.shopImageURL,
            onPickedImage: widget.onPickedImage,
          ),
          const SizedBox(
            height: 10,
          ),
          // enter name
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Name';
              }
              return null;
            },
            controller: widget.nameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: CustomAppColors.mainThemeColorBlueLogo,
              ),
              hintText: 'Name',
              helperText: "Enter your name e.g Ali Khan",
            ),
            keyboardType: TextInputType.text,
            focusNode: nameFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(context, nameFocus, shopNameFocus);
            },
          ),

          //enter shop name
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Shop Name';
              }
              return null;
            },
            focusNode: shopNameFocus,
            controller: widget.shopNameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.shop,
                color: CustomAppColors.mainThemeColorBlueLogo,
              ),
              hintText: 'Shop Name',
              helperText: "Enter Shop Name e.g Ahmed Khan General Store",
            ),
            keyboardType: TextInputType.text,
            autofocus: false,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(
                  context, shopNameFocus, shopAddressFocus);
            },
          ),

          //enter shop name
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Shop Address';
              }
              return null;
            },
            controller: widget.shopAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.location_city,
                color: CustomAppColors.mainThemeColorBlueLogo,
              ),
              hintText: 'Shop Address',
              helperText: "Enter Shop Address e.g Shop No#12,Gali-2,RWP",
            ),
            keyboardType: TextInputType.text,
            focusNode: shopAddressFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(
                  context, shopAddressFocus, shopPhoneNoFocus);
            },
          ),

          //enter phone number
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Phone No #';
              }
              if (value!.length != 11) {
                return 'Phone Number should be 11 digits';
              }
              return null;
            },
            controller: widget.shopPhoneNo,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: CustomAppColors.mainThemeColorBlueLogo,
              ),
              hintText: 'Phone No #',
              helperText: "Enter Phone No # e.g 03331234567",
            ),
            keyboardType: TextInputType.phone,
            focusNode: shopPhoneNoFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(context, shopPhoneNoFocus, nameFocus);
            },
          ),
        ],
      ),
    );
  }
}
