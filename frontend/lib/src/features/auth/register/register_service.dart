import 'dart:convert';
import 'package:http/http.dart' as http;


Future<String> register(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/auth/register'),
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