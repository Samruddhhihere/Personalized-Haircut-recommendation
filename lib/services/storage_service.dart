import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> uploadImage(File imageFile) async {
    final fileName =
        DateTime.now().millisecondsSinceEpoch.toString();

    final ref = FirebaseStorage.instance
        .ref()
        .child('uploads')
        .child('$fileName.jpg');

    await ref.putFile(imageFile);

    return await ref.getDownloadURL();
  }
}