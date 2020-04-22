import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static const diagnosisBox = "assets/diagnosis.png";
  static const defaultProfile = "assets/profile.png";
  static const chatBackground = 'assets/chat_background_image.jpg';

  // functions that handles things related to images
  // -----------------------------------------------

  // crop images after picking the image from the source
  static Future<File> cropImage(File imageFile, BuildContext context) async {
    final primaryColor = Theme.of(context).primaryColor;
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Theme.of(context).accentColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile;
  }

  static Future<File> pickImageFromGallery(BuildContext context) async {
    final image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    if (image != null) {
      final croppedImage = await cropImage(image, context);
      return croppedImage;
    }
    return null;
  }

  static Future<File> pickImageUsingCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 30);
    if (image != null) {
      final croppedImage = await cropImage(image, context);
      return croppedImage;
    }
    return null;
  }
}
