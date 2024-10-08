import 'dart:convert';
import 'package:frontend/src/features/auth/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<List<User>> fetchUsers(String? username) async {
  final baseUrl = dotenv.env['SERVER_API_BASE_URL']!;
  final token = await getToken();
  Uri url = Uri.parse('$baseUrl/users');
  final queryParams = <String, String?>{
    "username": username,
  };
  url = Uri(
    scheme: url.scheme,
    host: url.host,
    port: url.port,
    path: url.path,
    queryParameters: queryParams,
  );
  final response = await http.get(
    url, 
    headers: <String, String>{
      "Authorization": "Bearer $token"
  });

  if (response.statusCode != 200) {
    throw Exception('[${response.statusCode}] Failed to load users');
  }
  // Decode the JSON response
  Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

  // Access the 'users' list from the JSON response
  List<dynamic> usersJson = jsonResponse['users'];
  // Map the JSON data to the User model
  return usersJson.map((user) => User.fromJson(user)).toList();
}