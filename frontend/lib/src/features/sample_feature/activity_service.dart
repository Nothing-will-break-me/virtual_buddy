import 'dart:convert';
import 'package:http/http.dart' as http;
import 'activity_model.dart';


Future<List<Activity>> fetchActivities(String? userId) async {
  Map<String, String> params = {};
  if (userId != null) {
    params["user_id"] = userId;
  }
  Uri query = Uri.http('localhost:8000', '/activities', params);
  final response = await http.get(query);
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