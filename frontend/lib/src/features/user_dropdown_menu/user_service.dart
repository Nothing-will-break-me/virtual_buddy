import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';


Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('http://localhost:8000/users'));

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