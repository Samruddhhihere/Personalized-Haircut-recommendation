import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  Future<String> detectFaceShape(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        return "No Face Detected";
      }

      final face = faces.first;
      print("CONTOURS AVAILABLE:");

      for (var contour in face.contours.entries) {
        print("${contour.key} -> ${contour.value?.points.length}");
      }

      final width = face.boundingBox.width;
      final height = face.boundingBox.height;

      final ratio = height / width;

      print("FACE WIDTH = $width");
      print("FACE HEIGHT = $height");
      print("FACE RATIO = $ratio");

      if (ratio > 1.5) {
        return "Oval";
      } else if (ratio > 1.3) {
        return "Oblong";
      } else if (ratio > 1.1) {
        return "Heart";
      } else {
        return "Round";
      }
    } catch (e) {
      print("FACE DETECTION ERROR: $e");
      return "Error";
    }
  }

  Future<void> dispose() async {
    await _faceDetector.close();
  }
}
