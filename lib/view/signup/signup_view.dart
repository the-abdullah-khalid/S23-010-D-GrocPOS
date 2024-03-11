import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/notification_services/notification_services.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/view/signup/widgets/signup_form_widget.dart';
import 'package:groc_pos_app/view_model/signup/signup_view_model.dart';

import '../../data/network/database_fields_name.dart';
import '../../resources/widgets_components/rounded_button.dart';
import '../../resources/widgets_components/sliding_logo_animation_auth_screens.dart';
import '../../utils/utils.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
// TEXT FORM FIELD ALL CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shopOwnerNameController =
      TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddress = TextEditingController();
  final TextEditingController _shopPhoneNo = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // PROFILE PICTURE RELATED VARIABLES
  File? _selectedImage;
  void _setSelectedImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  NotificationServices notificationServices = NotificationServices();
  String deviceFCMFirebaseToken = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value) {
      debugPrint("My Device Token - ${value}");
      deviceFCMFirebaseToken = value;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //disposing all the text field controllers
    _emailController.dispose();
    _passwordController.dispose();
    _shopOwnerNameController.dispose();
    _shopNameController.dispose();
    _shopAddress.dispose();
    _shopPhoneNo.dispose();
    _confirmPasswordController.dispose();
  }

  void _performSignUp() {
    bool goBack = false;

    if (_selectedImage == null) {
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
      dynamic userData = {
        ShopDatabaseFieldNames.shopOwnerName:
            _shopOwnerNameController.text.toString(),
        ShopDatabaseFieldNames.shopName: _shopNameController.text.toString(),
        ShopDatabaseFieldNames.shopAddress: _shopAddress.text.toString(),
        ShopDatabaseFieldNames.shopEmail: _emailController.text.toString(),
        ShopDatabaseFieldNames.shopOwnerPassword:
            _passwordController.text.toString(),
        ShopDatabaseFieldNames.shopOwnerPhone: _shopPhoneNo.text.toString(),
        ShopDatabaseFieldNames.shopImageFile: _selectedImage,
        ShopDatabaseFieldNames.shopDeviceFCMToken:
            deviceFCMFirebaseToken.toString()
      };

      if (kDebugMode) {
        print(userData.toString());
      }

      signupViewModel.signupNewUser(userData, context);
    }
  }

  final signupViewModel = Get.put(SignUpViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // code of the appbar of the view
        appBar: AppBar(
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          title: Center(
            child: Text(
              "Groc-POS Signup",
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
        resizeToAvoidBottomInset: true,
        //code of the body of the view
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                // sliding animation of the logo
                const SlidingLogoAnimationAuthScreens(
                  width: 200,
                  height: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                // Main title heading of app
                Text(
                  'GROC-POS APP',
                  style: GoogleFonts.getFont(
                    AppFontsNames.kBodyFont,
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff246bdd),
                      letterSpacing: .5,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // signup-form starts here
                SignUpForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  nameController: _shopOwnerNameController,
                  shopNameController: _shopNameController,
                  shopAddress: _shopAddress,
                  shopPhoneNo: _shopPhoneNo,
                  confirmPasswordController: _confirmPasswordController,
                  onPickedImage: _setSelectedImage,
                ),

                const SizedBox(
                  height: 25,
                ),
                //Submit Button
                Obx(
                  () => RoundButton(
                    loading: signupViewModel.roundedButtonLoadingStatus.value,
                    title: 'Sign Up - Register Your Shop',
                    onTap: _performSignUp,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RouteName.loginView);
                      },
                      child: const Text("Login"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
