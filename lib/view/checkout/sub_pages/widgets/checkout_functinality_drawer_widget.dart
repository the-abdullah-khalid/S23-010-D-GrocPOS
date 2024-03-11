import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/colors/app_colors.dart';
import 'package:groc_pos_app/resources/constants/checkout_functionalities_enum.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';

class CheckOutFunctionalityDrawerWidget extends StatefulWidget {
  const CheckOutFunctionalityDrawerWidget({super.key});

  @override
  State<CheckOutFunctionalityDrawerWidget> createState() =>
      _CheckOutFunctionalityDrawerWidgetState();
}

class _CheckOutFunctionalityDrawerWidgetState
    extends State<CheckOutFunctionalityDrawerWidget> {
  late DrawerOptionsController drawerOptionsController;
  ModelThrsuholdSliderController modelThrsuholdSliderController =
      Get.put(ModelThrsuholdSliderController());

  _getDrawerFunctionalities() {
    drawerOptionsController = Get.find<DrawerOptionsController>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDrawerFunctionalities();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [
                  CustomAppColors.mainThemeColorBlueLogo,
                  Color(0xff5089e4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                "Checkout Functionality Selection Menu",
                style: GoogleFonts.getFont(
                  AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Obx(() {
            return Column(
              children: [
                SwitchListTile(
                  value: drawerOptionsController
                      .drawerOptions.value[Functionality.barCode]!,
                  onChanged: (isChecked) {
                    drawerOptionsController.setFunctionality(
                        Functionality.barCode, isChecked);
                  },
                  title: const Text(
                      "Use Bar Code Functionality To Process Checkout"),
                ),
                SwitchListTile(
                  value: drawerOptionsController
                      .drawerOptions.value[Functionality.objectDetection]!,
                  onChanged: (isChecked) {
                    drawerOptionsController.setFunctionality(
                        Functionality.objectDetection, isChecked);
                  },
                  title: const Text(
                      "Use Object Detection Functionality To Process Checkout"),
                ),
                SwitchListTile(
                  value: drawerOptionsController
                      .drawerOptions.value[Functionality.classification]!,
                  onChanged: (isChecked) {
                    drawerOptionsController.setFunctionality(
                        Functionality.classification, isChecked);
                  },
                  title: const Text(
                      "Use Classification Model Functionality To Process Checkout"),
                ),
                SwitchListTile(
                  value: drawerOptionsController.drawerOptions
                      .value[Functionality.staticImageObjectDetection]!,
                  onChanged: (isChecked) {
                    drawerOptionsController.setFunctionality(
                        Functionality.staticImageObjectDetection, isChecked);
                  },
                  title: const Text(
                      "Use Static Image Object Detection Model Model Functionality To Process Checkout"),
                ),
                const Divider(),
                Column(
                  children: [
                    Obx(
                      () => Text(
                          "Current Classification Model Thrushold ${modelThrsuholdSliderController.currentClassificationModelThurshold.value}: ${modelThrsuholdSliderController.currentClassificationModelThurshold.value * 100}"),
                    ),
                    Slider(
                      min: 0,
                      max: 1,
                      value: modelThrsuholdSliderController
                          .currentClassificationModelThurshold.value,
                      label:
                          '${modelThrsuholdSliderController.currentClassificationModelThurshold.value}',
                      onChanged: (value) {
                        setState(() {
                          modelThrsuholdSliderController
                              .currentClassificationModelThurshold
                              .value = value.toPrecision(2);
                        });
                      },
                    ),
                    Obx(
                      () => Text(
                          "Current Object Detection Model Thrushold ${modelThrsuholdSliderController.currentObjectDetectionModelThurshold.value}: ${modelThrsuholdSliderController.currentObjectDetectionModelThurshold.value * 100}"),
                    ),
                    Slider(
                      min: 0,
                      max: 1,
                      value: modelThrsuholdSliderController
                          .currentObjectDetectionModelThurshold.value,
                      label:
                          '${modelThrsuholdSliderController.currentObjectDetectionModelThurshold.value}',
                      onChanged: (value) {
                        setState(
                          () {
                            modelThrsuholdSliderController
                                .currentObjectDetectionModelThurshold
                                .value = value.toPrecision(2);
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            );
          })
        ],
      ),
    );
  }
}

class DrawerOptionsController extends GetxController {
  final drawerOptions = {
    Functionality.barCode: true,
    Functionality.manually: false,
    Functionality.classification: false,
    Functionality.objectDetection: false,
    Functionality.staticImageObjectDetection: false,
  }.obs;

  Rx<String> selectedFunctionalityName = (Functionality.barCode.toString()).obs;
  void setFunctionalitys(Map<Functionality, bool> chosenFunctionality) {
    drawerOptions.value = chosenFunctionality;
  }

  void setFunctionality(Functionality functionality, bool isActive) {
    Map<Functionality, bool> functionalities = {
      Functionality.barCode: false,
      Functionality.manually: false,
      Functionality.classification: false,
      Functionality.objectDetection: false,
      Functionality.staticImageObjectDetection: false,
    };
    functionalities[functionality] = isActive;
    selectedFunctionalityName.value = functionality.toString();
    drawerOptions.value = functionalities;
  }

  String whichFunctionalityIsON() {
    try {
      Functionality trueFunctionalities = drawerOptions.value.keys
          .where((key) => drawerOptions.value[key] == true)
          .toList()[0];
      debugPrint(trueFunctionalities.toString());
      return trueFunctionalities.toString();
    } catch (error) {
      return "no functionality selected";
    }
  }

  resetFunctionalityToDefault() {
    selectedFunctionalityName.value = Functionality.barCode.toString();
  }
}

class ModelThrsuholdSliderController extends GetxController {
  int maxValue = 90;
  int minValue = 50;

  RxDouble currentClassificationModelThurshold = 0.85.obs;
  RxDouble currentObjectDetectionModelThurshold = 0.80.obs;

  updateClassificationThurshold(double updateThurshold) {
    currentClassificationModelThurshold.value = updateThurshold;
  }

  updateObjectDetectionThurshold(double updateThurshold) {
    currentClassificationModelThurshold.value = updateThurshold;
  }
}
