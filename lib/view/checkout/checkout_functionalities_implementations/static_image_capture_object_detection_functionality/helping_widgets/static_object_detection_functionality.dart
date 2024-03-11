import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:groc_pos_app/resources/app_urls/models_related_files_path.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/static_image_capture_object_detection_functionality/static_image_capture_object_detection_functionality_widget.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class StaticImageObjectDetection {
  static const String _modelPath =
      ModelRelatedFilesPath.objectDetectionModelPath;
  static const String _labelPath =
      ModelRelatedFilesPath.objectDetectionModelLabels;

  Interpreter? _interpreter;
  List<String>? _labels;

  StaticImageObjectDetection() {
    _loadModel();
    _loadLabels();
    log('Done.');
  }

  Future<void> _loadModel() async {
    log('Loading interpreter options...');
    final interpreterOptions = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      interpreterOptions.addDelegate(XNNPackDelegate());
    }

    // Use Metal Delegate
    if (Platform.isIOS) {
      interpreterOptions.addDelegate(GpuDelegate());
    }

    log('Loading interpreter...');
    _interpreter =
        await Interpreter.fromAsset(_modelPath, options: interpreterOptions);
  }

  Future<void> _loadLabels() async {
    log('Loading labels...');
    final labelsRaw = await rootBundle.loadString(_labelPath);
    _labels = labelsRaw.split('\n');
  }

  Uint8List analyseImage(String imagePath) {
    staticImageObjectDetectionPredictionLableList = [];
    log('Analysing image...');
    // Reading image bytes from file
    final imageData = File(imagePath).readAsBytesSync();

    // Decoding image
    final image = img.decodeImage(imageData);

    // Resizing image fpr model, [300, 300]
    final imageInput = img.copyResize(
      image!,
      width: 320,
      height: 320,
    );

    // Creating matrix representation, [300, 300, 3]
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    final output = _runInference(imageMatrix);

    log('Processing outputs...');
    // Location
    final locationsRaw = output.elementAt(1).first as List<List<double>>;
    final locations = locationsRaw.map((list) {
      return list.map((value) => (value * 300).toInt()).toList();
    }).toList();
    log('Locations: $locations');

    // Classes
    final classesRaw = output.last.first as List<double>;
    final classes = classesRaw.map((value) => value.toInt()).toList();

    // Scores
    final scores = output.first.first as List<double>;

    log('Scores: $scores');

    // Number of detections
    // Number of detections
    final numberOfDetectionsRaw = output.elementAt(2).first as double;
    final numberOfDetections = numberOfDetectionsRaw.toInt();
    log('Number of detections: $numberOfDetections');

    log('Classifying detected objects...');
    final List<String> classication = [];
    for (var i = 0; i < numberOfDetections; i++) {
      classication.add(_labels![classes[i]]);
      debugPrint("${_labels![classes[i]]} --> ${scores[i]}");
    }

    log('Outlining objects...');
    for (var i = 0; i < numberOfDetections; i++) {
      if (scores[i] > 0.6) {
        // Rectangle drawing
        img.drawRect(
          imageInput,
          x1: locations[i][1],
          y1: locations[i][0],
          x2: locations[i][3],
          y2: locations[i][2],
          color: img.ColorRgb8(255, 0, 0),
          thickness: 3,
        );

        // Label drawing
        img.drawString(
          imageInput,
          '${classication[i]} ${scores[i]}',
          font: img.arial14,
          x: locations[i][1] + 1,
          y: locations[i][0] + 1,
          color: img.ColorRgb8(255, 0, 0),
        );

        staticImageObjectDetectionPredictionLableList
            .add({'label': classication[i], 'score': scores[i]});
      }
    }

    log('Done.');

    return img.encodeJpg(imageInput);
  }

  List<List<Object>> _runInference(
    List<List<List<num>>> imageMatrix,
  ) {
    log('Running inference...');

    // Set input tensor [1, 300, 300, 3]
    final input = [imageMatrix];

    // Set output tensor
    // Locations: [1, 10, 4]
    // Classes: [1, 10],
    // Scores: [1, 10],
    // Number of detections: [1]
    // final output = {
    //   0: [List<List<num>>.filled(10, List<num>.filled(4, 0))],
    //   1: [List<num>.filled(10, 0)],
    //   2: [List<num>.filled(10, 0)],
    //   3: [0.0],
    // };

    final output = {
      0: [List<double>.filled(25, 0)], //score
      1: [List<List<num>>.filled(25, List<num>.filled(4, 0))], //location
      2: [0.0], //no detections
      3: [List<double>.filled(25, 0)], //category
    };

    _interpreter!.runForMultipleInputs([input], output);
    return output.values.toList();
  }
}
