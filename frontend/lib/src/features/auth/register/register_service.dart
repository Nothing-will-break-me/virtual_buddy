import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<String> register(String username, String password) async {
  final baseUrl = dotenv.env['SERVER_API_BASE_URL']!;
  final response = await http.post(
    Uri.parse('$baseUrl/auth/register'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: json.encode({"username": username, "password": password}),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception(response.body);
  }
}