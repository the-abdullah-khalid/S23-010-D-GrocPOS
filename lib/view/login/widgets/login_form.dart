import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../resources/colors/app_colors.dart';
import '../../../utils/utils.dart';

class Login_Form extends StatefulWidget {
  const Login_Form({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  State<Login_Form> createState() => _Login_FormState();
}

class _Login_FormState extends State<Login_Form> {
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final passwordVisibilityController =
        Get.put(PasswordVisibilityController());
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: emailFocus,
            onFieldSubmitted: (value) {
              AppUtils.fieldFocusChange(context, emailFocus, passwordFocus);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Email';
              }
              return null;
            },
            controller: widget._emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: CustomAppColors.mainThemeColorBlueLogo,
              ),
              hintText: 'Email',
              helperText: "Enter email e.g ahmen.imran@gmail.com",
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => TextFormField(
              focusNode: passwordFocus,
              onFieldSubmitted: (value) {
                AppUtils.fieldFocusChange(context, passwordFocus, emailFocus);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Password';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              controller: widget._passwordController,
              obscureText:
                  passwordVisibilityController.passwordVisibilityStatus.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock,
                  color: CustomAppColors.mainThemeColorBlueLogo,
                ),
                suffixIcon: InkWell(
                    onTap: () {
                      passwordVisibilityController
                          .togglePasswordVisibilityStatus();
                    },
                    child: passwordVisibilityController
                            .passwordVisibilityStatus.value
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility)),
                hintText: 'Password',
                helperText: "Enter password",
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class PasswordVisibilityController extends GetxController {
  RxBool passwordVisibilityStatus = false.obs;

  void togglePasswordVisibilityStatus() {
    passwordVisibilityStatus.value = !passwordVisibilityStatus.value;
    debugPrint(" passworrd visibility - ${passwordVisibilityStatus.value}");
  }
}
