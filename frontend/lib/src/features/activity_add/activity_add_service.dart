import 'package:http/http.dart' as http;
import '../activity_list/activity_model.dart';
import '../auth/auth_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<String> addActivity(String title, String description, DateTime startTime, DateTime endTime, ActivityType type) async {
  final baseUrl = dotenv.env['SERVER_API_BASE_URL']!;
  final token = await getToken();
  final response = await http.post(
    Uri.parse('$baseUrl/activities'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    },
    body: Activity.getAddJson(title, description, startTime, endTime, type),
  );
  if (response.statusCode == 201) {
    return response.body;
  } else {
    throw Exception(response.body);
  }
}