import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/utils/utils.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/widgets/checkout_functinality_drawer_widget.dart';

import 'image_classification_helper.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen(
      {super.key, required this.camera, required this.addProductToCart});

  final CameraDescription camera;
  final Function(String) addProductToCart;

  @override
  State<StatefulWidget> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late CameraController cameraController;
  late ImageClassificationHelper imageClassificationHelper;
  Map<String, double>? classification;
  bool _isProcessing = false;
  final modelThrsuholdSliderController =
      Get.find<ModelThrsuholdSliderController>();

  bool toggleFlash = false;
  // init camera
  initCamera() async {
    cameraController = CameraController(
        widget.camera, ResolutionPreset.ultraHigh,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420);
    cameraController.initialize().then((value) {
      cameraController.startImageStream(imageAnalysis);
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> imageAnalysis(CameraImage cameraImage) async {
    // if image is still analyze, skip this frame
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    classification =
        await imageClassificationHelper.inferenceCameraFrame(cameraImage);
    _isProcessing = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper.initHelper();
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController.value.isStreamingImages) {
          await cameraController.startImageStream(imageAnalysis);
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    imageClassificationHelper.close();
    super.dispose();
  }

  Widget cameraWidget(context) {
    var camera = cameraController.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }

  bool isBusy = false;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    List<Widget> list = [];

    list.add(
      SizedBox(
        child: (!cameraController.value.isInitialized)
            ? Container()
            : cameraWidget(context),
      ),
    );
    list.add(Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Text(
                "Model Top 3 Inferences Tap To Add",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  AppFontsNames.kBodyFont,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            if (classification != null && !isBusy)
              ...(classification!.entries.toList()
                    ..sort(
                      (a, b) => a.value.compareTo(b.value),
                    ))
                  .reversed
                  .take(3)
                  .map(
                (e) {
                  if (e.value >
                      modelThrsuholdSliderController
                          .currentClassificationModelThurshold.value) {
                    Future.delayed(Duration.zero, () {
                      // isBusy = true;
                      widget.addProductToCart(e.key);
                    });
                  }
                  return InkWell(
                    onTap: () {
                      widget.addProductToCart(e.key.toString());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(e.key),
                              const Spacer(),
                              Text(e.value.toStringAsFixed(2))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            FloatingActionButton(
              heroTag: "tag: 'unique_tag_for_hero_of_the floating_action_btm',",
              onPressed: () {
                if (toggleFlash) {
                  cameraController.setFlashMode(FlashMode.torch);
                  toggleFlash = !toggleFlash;
                  setState(() {});
                } else {
                  cameraController.setFlashMode(FlashMode.off);
                  toggleFlash = !toggleFlash;
                  setState(() {});
                }
                debugPrint(" - ${toggleFlash}");
              },
              child: Icon(toggleFlash ? Icons.flash_on : Icons.flash_off),
            )
          ],
        ),
      ),
    ));

    return Stack(
      children: list,
    );
  }
}
