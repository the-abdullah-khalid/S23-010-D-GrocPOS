import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/notification_services/notification_services.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';
import 'package:groc_pos_app/view/login/widgets/login_form.dart';
import 'package:groc_pos_app/view_model/login/login_view_model.dart';

import '../../resources/colors/app_colors.dart';
import '../../resources/fonts/app_fonts_names.dart';
import '../../resources/widgets_components/rounded_button.dart';
import '../../resources/widgets_components/sliding_logo_animation_auth_screens.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final loginViewModel = Get.put(LoginViewModel());

  NotificationServices notificationServices = NotificationServices();
  String deviceFCMToken = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.getDeviceToken().then((value) {
      debugPrint("My Device Token - ${value}");
      deviceFCMToken = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          title: Center(
            child: Text(
              "Groc-POS Login",
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SlidingLogoAnimationAuthScreens(height: 200, width: 200),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'GROC-POS APP',
                  style: GoogleFonts.getFont(
                    AppFontsNames.kBodyFont,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff246bdd),
                      letterSpacing: .5,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Login_Form(
                  formKey: _formKey,
                  emailController: loginViewModel.emailController.value,
                  passwordController: loginViewModel.passwordController.value,
                ),
                Obx(
                  () => RoundButton(
                    loading: loginViewModel.roundButtonProgressIndicator.value,
                    title: 'Login',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        loginViewModel.handleLogin(context, deviceFCMToken);
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(RouteName.forgetPasswordView);
                    },
                    child: const Text("Forget Password?"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RouteName.signupView);
                      },
                      child: const Text("Sign up"),
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
