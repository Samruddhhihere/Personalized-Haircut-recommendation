import 'dart:convert';
import 'package:http/http.dart' as http;

class AiTryOnService {
  static const String apiKey =
      'X5DU6I3yugtpO5vtwLNvgQ5XRchKbrWPSprlUTLQlqtn1N8b-d';

  Future<String?> generateHairstyle({
    required String imageUrl,
    required String prompt,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://AI-Hairstyle-API.proxy-production.allthingsdev.co/external/api/v1/hairstyle',
      ),
      headers: {
        'Content-Type': 'application/json',
        'x-apihub-key': apiKey,
        'x-apihub-host': 'AI-Hairstyle-API.allthingsdev.co',
        'x-apihub-endpoint': '94ffdf66-5593-4534-a939-b916060439ad',
      },
      body: jsonEncode({"imageUrl": imageUrl, "textPrompt": prompt}),
    );

    print(response.body);

    final data = jsonDecode(response.body);

    if (data['body'] != null) {
      return data['body']['orderId'];
    }

    return null;
  }

  Future<String?> getResult(String orderId) async {
    final response = await http.post(
      Uri.parse(
        'https://AI-Hairstyle-API.proxy-production.allthingsdev.co/external/api/v1/order-status',
      ),
      headers: {
        'Content-Type': 'application/json',
        'x-apihub-key': apiKey,
        'x-apihub-host': 'AI-Hairstyle-API.allthingsdev.co',
        'x-apihub-endpoint': '266df42f-0a66-4df2-ba3d-c04d89e4da65',
      },
      body: jsonEncode({"orderId": orderId}),
    );
    print("STATUS CODE:");
    print(response.statusCode);

    print("RAW BODY:");
    print(response.body);

    final data = jsonDecode(response.body);

    print(data);

    if (data['body']?['output'] != null) {
      return data['body']['output'];
    }

    return null;
  }
}
