import 'dart:convert';
import 'package:http/http.dart' as http;


Future<String> login(String username, String password) async {
  final payload = {"username": username, "password": password};
  final response = await http.post(
    Uri.parse('http://localhost:8000/auth/login'),
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