import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../resources/colors/app_colors.dart';

class CustomQRCodeGenerator extends StatefulWidget {
  dynamic data;
  CustomQRCodeGenerator({super.key, required this.data});

  @override
  State<CustomQRCodeGenerator> createState() => _CustomQRCodeGeneratorState();
}

class _CustomQRCodeGeneratorState extends State<CustomQRCodeGenerator> {
  final TextEditingController _barcodeController =
      TextEditingController(text: '');
  final TextEditingController _productNameController =
      TextEditingController(text: '');

  String data = '';
  final GlobalKey _qrkey = GlobalKey();
  bool dirExists = false;
  dynamic externalDir = '/storage/emulated/0/Download/Qr_code';

  //************* stoarge permission *******************************************

  Future<void> requestStoragePermission() async {
    // Check if the storage permission is already granted
    var status = await Permission.storage.status;

    if (status.isGranted) {
      // Permission is already granted
      print("Storage permission is already granted.");
    } else {
      // Request storage permission
      var result = await Permission.storage.request();

      if (result.isGranted) {
        // Permission is granted
        print("Storage permission has been granted.");
      } else {
        // Permission is denied
        print("Storage permission has been denied.");
      }
    }
  }
  //****************************************************************************

  Future<void> _captureAndSavePng() async {
    try {
      await requestStoragePermission();
      RenderRepaintBoundary boundary =
          _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      //Drawing White Background because Qr Code is Black
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      //Check for duplicate file name to avoid Override
      String fileName = 'qr_code';
      int i = 1;
      while (await File('$externalDir/$fileName.png').exists()) {
        fileName = '${_productNameController.value.text.trim()}_qr_code_$i';
        i++;
      }

      // Check if Directory Path exists or not
      dirExists = await File(externalDir).exists();
      //if not then create the path
      if (!dirExists) {
        await Directory(externalDir).create(recursive: true);
        dirExists = true;
      }

      final file = await File('$externalDir/$fileName.png').create();
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      const snackBar = SnackBar(content: Text('QR code saved to gallery'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      if (!mounted) return;
      const snackBar = SnackBar(content: Text('Something went wrong!!!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.data['product_barcode']);
    _barcodeController.text = widget.data['product_barcode'];
    _productNameController.text = widget.data['product_name'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
        title: Center(
          child: Text(
            "Groc-POS Custom QR Code",
            style: GoogleFonts.getFont(AppFontsNames.kBodyFont,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: TextField(
              enabled: false,
              controller: _barcodeController,
              decoration: const InputDecoration(
                hintText: 'Product Bar-Code',
                helperText: "Product Bar Code",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: TextField(
              enabled: false,
              controller: _productNameController,
              decoration: const InputDecoration(
                hintText: 'Product Name',
                helperText: "Product Name",
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                data = _barcodeController.text;
              });
            },
            fillColor: CustomAppColors.mainThemeColorBlueLogo,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: const Text(
              'Generate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: RepaintBoundary(
              key: _qrkey,
              child: QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 250.0,
                gapless: true,
                errorStateBuilder: (ctx, err) {
                  return const Center(
                    child: Text(
                      'Something went wrong!!!',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          RawMaterialButton(
            onPressed: _captureAndSavePng,
            fillColor: CustomAppColors.mainThemeColorBlueLogo,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: const Text(
              'Export',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
