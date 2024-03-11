import 'dart:async';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/models/product_model.dart';
import 'package:groc_pos_app/view/checkout/sub_pages/widgets/checkout_functinality_drawer_widget.dart';
import 'package:groc_pos_app/view_model/checkout/main_check_out_view_model.dart';
import 'package:groc_pos_app/view_model/checkout/scanned_products_controller/scanned_products_controller.dart';

import 'inference_box_ui/live_box_widget.dart';
import 'inference_box_ui/live_stats_widget.dart';
import 'model_unpacking/live_detector_service.dart';
import 'model_unpacking/live_recognition_model.dart';
import 'model_unpacking/live_screen_parms.dart';

/// [liveDetectorWidget] sends each frame for inference
class liveDetectorWidget extends StatefulWidget {
  /// Constructor
  const liveDetectorWidget({super.key, required this.checkOutAs});
  final String checkOutAs;

  @override
  State<liveDetectorWidget> createState() => _liveDetectorWidgetState();
}

class _liveDetectorWidgetState extends State<liveDetectorWidget>
    with WidgetsBindingObserver {
  final modelThrsuholdSliderController =
      Get.find<ModelThrsuholdSliderController>();
  bool toggleFlash = false;

  /// List of available cameras
  late List<CameraDescription> cameras;

  /// Controller
  CameraController? _cameraController;

  // use only when initialized, so - not null
  get _controller => _cameraController;

  /// Object Detector is running on a background [Isolate]. This is nullable
  /// because acquiring a [Detector] is an asynchronous operation. This
  /// value is `null` until the detector is initialized.
  Detector? _detector;
  StreamSubscription? _subscription;

  /// Results to draw bounding boxes
  List<Recognition>? results;

  /// Realtime stats
  Map<String, String>? stats;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initStateAsync();
  }

  void _initStateAsync() {
    // initialize preview and CameraImage stream
    _initializeCamera();
    // Spawn a new isolate
    Detector.start().then((instance) {
      setState(() {
        _detector = instance;
        _subscription = instance.resultsStream.stream.listen((values) {
          setState(() {
            results = values['recognitions'];
            stats = values['stats'];
          });
        });
      });
    });
  }

  /// Initializes the camera by setting [_cameraController]
  void _initializeCamera() async {
    cameras = await availableCameras();
    // cameras[0] for back-camera
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    )..initialize().then((_) async {
        await _controller.startImageStream(onLatestImageAvailable);
        setState(() {});

        /// previewSize is size of each image frame captured by controller
        ///
        /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
        ScreenParams.previewSize = _controller.value.previewSize!;
      });
  }

  @override
  Widget build(BuildContext context) {
    // Return empty container while the camera is not initialized
    if (_cameraController == null || !_controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    var aspect = 1 / _controller.value.aspectRatio;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: aspect,
          child: CameraPreview(_controller),
        ),
        // Stats
        _statsWidget(),
        // Bounding boxes
        AspectRatio(
          aspectRatio: aspect,
          child: _boundingBoxes(),
        ),
        FloatingActionButton(
          heroTag:
              "unique hero tag of floating action button for the live object detection",
          onPressed: () {
            if (toggleFlash) {
              _cameraController?.setFlashMode(FlashMode.torch);
              toggleFlash = !toggleFlash;
              setState(() {});
            } else {
              _cameraController?.setFlashMode(FlashMode.off);
              toggleFlash = !toggleFlash;
              setState(() {});
            }
            debugPrint(" - $toggleFlash");
          },
          child: Icon(toggleFlash ? Icons.flash_on : Icons.flash_off),
        )
      ],
    );
  }

  Widget _statsWidget() => (stats != null)
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white.withAlpha(150),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: stats!.entries
                    .map((e) => StatsWidget(e.key, e.value))
                    .toList(),
              ),
            ),
          ),
        )
      : const SizedBox.shrink();

  /// Returns Stack of bounding boxes
  Widget _boundingBoxes() {
    if (results == null) {
      return const SizedBox.shrink();
    }

    // if (results != null) {
    //   results!.map((box) {
    //     if (box.score >
    //         modelThrsuholdSliderController
    //             .currentObjectDetectionModelThurshold.value) {
    //       debugPrint("threscheck- ${box.score}");
    //     }
    //   });
    // }

    return Stack(
        children: results!.map((box) {
      if (box.score >
          modelThrsuholdSliderController
              .currentObjectDetectionModelThurshold.value) {
        return BoxWidget(result: box, checkOutAs: widget.checkOutAs);
      } else {
        return const SizedBox.shrink();
      }
    }).toList());
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void onLatestImageAvailable(CameraImage cameraImage) async {
    _detector?.processFrame(cameraImage);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        _cameraController?.stopImageStream();
        _detector?.stop();
        _subscription?.cancel();
        break;
      case AppLifecycleState.resumed:
        _initStateAsync();
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _detector?.stop();
    _subscription?.cancel();
    super.dispose();
  }
}
