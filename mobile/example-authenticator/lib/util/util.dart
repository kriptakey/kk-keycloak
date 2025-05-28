import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class Util {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/deviceCertificate.pem');
  }

  Future<File> writeDataToFile(String data) async {
    final file = await localFile;
    return file.writeAsString(data);
  }

  Future<Uint8List> readImageAsBytesFromGallery() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 400, maxHeight: 400);
    Uint8List imageBytes = Uint8List.fromList([0]);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      imageBytes = await imageFile.readAsBytes();
    }
    return imageBytes;
  }
}
