import 'dart:convert';

enum ActivityType { running, gym }

/// A placeholder class that represents an entity or model.
class Activity {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime additionDate;
  final DateTime startTime;
  final DateTime endTime;

  Activity({required this.id, required this.userId, required this.title, required this.description, 
            required this.additionDate, required this.startTime, required this.endTime});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      additionDate: DateTime.parse(json['addition_date']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }


  static getAddJson(String title, String description, DateTime startTime, DateTime endTime, ActivityType type) {
    return json.encode({
      "title": title,
      "description": description,
      "type": type.name,
      "start_time": startTime.toString(),
      "end_time": endTime.toString()
    });
  }
}
