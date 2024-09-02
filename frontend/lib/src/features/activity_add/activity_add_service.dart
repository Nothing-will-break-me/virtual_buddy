import 'package:http/http.dart' as http;
import '../activity_list/activity_model.dart';
import '../auth/auth_controller.dart';


Future<String> addActivity(String title, String description, DateTime startTime, DateTime endTime, ActivityType type) async {
  final token = await getToken();
  final response = await http.post(
    Uri.parse('http://localhost:8000/activities'),
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