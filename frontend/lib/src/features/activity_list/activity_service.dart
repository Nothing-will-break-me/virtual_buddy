import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_controller.dart';
import 'activity_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<List<Activity>> fetchActivities() async {
  final baseUrl = dotenv.env['SERVER_API_BASE_URL']!;
  final token = await getToken();
  final response = await http.get(
    Uri.parse('$baseUrl/activities'),
    headers: <String, String>{
      'Authorization': "Bearer $token"
    }
  );
  await Future.delayed(const Duration(seconds: 1));
  if (response.statusCode != 200) {
    throw Exception('[${response.statusCode}] Failed to load activities');
  }
  // Decode the JSON response
  Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

  // Access the 'users' list from the JSON response
  List<dynamic> activitiesJson = jsonResponse['activities'];

  // Map the JSON data to the User model
  return activitiesJson.map((activity) => Activity.fromJson(activity)).toList();
}