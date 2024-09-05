import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<String> login(String username, String password) async {
  final baseUrl = dotenv.env['SERVER_API_BASE_URL']!;
  final payload = {"username": username, "password": password};
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    body: payload,
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['access_token'];
  } else {
    throw Exception(response.body);
  }
}