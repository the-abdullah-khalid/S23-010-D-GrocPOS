import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShopProfileImagePicker extends StatefulWidget {
  String imagePath = '';
  ShopProfileImagePicker(
      {super.key, required this.onPickedImage, required this.imagePath});
  final void Function(File pickedImage) onPickedImage;

  @override
  State<ShopProfileImagePicker> createState() => _ShopProfileImagePickerState();
}

class _ShopProfileImagePickerState extends State<ShopProfileImagePicker> {
  File? _pickedImageFile;

  @override
  Widget build(BuildContext context) {
    Future<void> _pickImage() async {
      final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

      if (pickedImage == null) {
        return;
      }
      setState(() {
        widget.imagePath = '';
        _pickedImageFile = File(pickedImage.path);
        widget.onPickedImage(_pickedImageFile!);
      });
    }

    return Column(
      children: [
        widget.imagePath == ''
            ? CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                foregroundImage: _pickedImageFile != null
                    ? FileImage(_pickedImageFile!)
                    : null,
              )
            : CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                foregroundImage: NetworkImage(widget.imagePath),
              ),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(
            Icons.image,
            color: Colors.white,
          ),
          label: const Text('Add Shop Image'),
        )
      ],
    );
  }
}
