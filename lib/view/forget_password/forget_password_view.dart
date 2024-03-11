import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/view_model/forget_password/forget_password_view_model.dart';

import '../../resources/colors/app_colors.dart';
import '../../resources/widgets_components/animated_log_groc_pos_splash_screen.dart';
import '../../resources/widgets_components/rounded_button.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final forgetPasswordViewModel = Get.put(ForgetPasswordViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Groc-POS Forget Password",
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
                width: 200,
                child: AnimatedLogo(),
              ),
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email';
                        }
                        return null;
                      },
                      controller: forgetPasswordViewModel.emailController.value,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: CustomAppColors.mainThemeColorBlueLogo,
                        ),
                        hintText: 'Email Where you want reset link!',
                        helperText: "Enter email e.g ahmen.imran@gmail.com",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => RoundButton(
                        loading: forgetPasswordViewModel
                            .roundedButtonLoadingStatus.value,
                        title: 'Reset Password',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            //  set state here is used to stop the circular progress indicator
                            forgetPasswordViewModel.performForgetPassword(
                              context,
                              forgetPasswordViewModel.emailController.value.text
                                  .toString(),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
