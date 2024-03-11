import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view/signup/widgets/shop_profile_image_picker.dart';

class SignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController shopNameController;
  final TextEditingController shopAddress;
  final TextEditingController shopPhoneNo;
  final TextEditingController confirmPasswordController;

  final void Function(File pickedImage) onPickedImage;

  SignUpForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.shopNameController,
    required this.shopAddress,
    required this.shopPhoneNo,
    required this.confirmPasswordController,
    required this.onPickedImage,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode shopNameFocus = FocusNode();
  FocusNode shopAddressFocus = FocusNode();
  FocusNode shopPhoneNoFocus = FocusNode();
  FocusNode confirmFocus = FocusNode();

  final signupPasswordVisibilityController =
      Get.put(SignUpPasswordVisibilityController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          ShopProfileImagePicker(
            imagePath: '',
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
              AppUtils.fieldFocusChange(context, shopPhoneNoFocus, emailFocus);
            },
          ),

          //enter email
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Email';
              }
              return null;
            },
            controller: widget.emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: CustomAppColors.mainThemeColorBlueLogo,
              ),
              hintText: 'Email',
              helperText: "Enter email e.g ahmen.imran@gmail.com",
            ),
            keyboardType: TextInputType.emailAddress,
            focusNode: emailFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(context, emailFocus, passwordFocus);
            },
          ),

          //enter password
          Obx(
            () => TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Password';
                }
                if (value!.length < 6) {
                  return 'Length of password should be at-least 6 characters';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              focusNode: passwordFocus,
              controller: widget.passwordController,
              obscureText: signupPasswordVisibilityController
                  .passwordVisibilityStatus.value,
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    signupPasswordVisibilityController
                        .togglePasswordVisibilityStatus();
                  },
                  child: Icon(signupPasswordVisibilityController
                          .passwordVisibilityStatus.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: CustomAppColors.mainThemeColorBlueLogo,
                ),
                hintText: 'Password',
                helperText: "Enter password should be at-least 6 characters",
              ),
              onFieldSubmitted: (value) {
                AppUtils.fieldFocusChange(context, passwordFocus, confirmFocus);
              },
            ),
          ),

          //enter password
          Obx(
            () => TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Confirm Password';
                }
                if (value.length < 6) {
                  return 'Length of password should be at-least 6 characters';
                }

                if (value.toString() !=
                    widget.passwordController.text.toString()) {
                  return "Your confirm password don't match with password";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              controller: widget.confirmPasswordController,
              obscureText: signupPasswordVisibilityController
                  .confirmPasswordVisibilityStatus.value,
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    signupPasswordVisibilityController
                        .toggleConfirmPasswordVisibilityStatus();
                  },
                  child: Icon(signupPasswordVisibilityController
                          .confirmPasswordVisibilityStatus.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: CustomAppColors.mainThemeColorBlueLogo,
                ),
                hintText: 'Confirm Password',
                helperText: "Confirm your password",
              ),
              focusNode: confirmFocus,
              onFieldSubmitted: (value) {
                AppUtils.fieldFocusChange(context, confirmFocus, nameFocus);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpPasswordVisibilityController extends GetxController {
  RxBool passwordVisibilityStatus = false.obs;
  RxBool confirmPasswordVisibilityStatus = false.obs;

  void togglePasswordVisibilityStatus() {
    passwordVisibilityStatus.value = !passwordVisibilityStatus.value;
    debugPrint(" passworrd visibility - ${passwordVisibilityStatus.value}");
  }

  void toggleConfirmPasswordVisibilityStatus() {
    confirmPasswordVisibilityStatus.value =
        !confirmPasswordVisibilityStatus.value;
    debugPrint(
        " confrim passworrd visibility - ${confirmPasswordVisibilityStatus.value}");
  }
}
