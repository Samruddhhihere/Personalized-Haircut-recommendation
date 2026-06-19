import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dcktjhg0q';
  static const String uploadPreset = 'Hairverse';

  Future<String?> uploadImage(File imageFile) async {
    try {
      var uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      var request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['upload_preset'] = uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(
          await response.stream.bytesToString(),
        );

        return data['secure_url'];
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}