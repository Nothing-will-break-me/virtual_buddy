import 'package:flutter/material.dart';
import 'activity_model.dart';

/// Displays detailed information about a SampleItem.
class ActivityDetailsView extends StatelessWidget {
  const ActivityDetailsView({super.key, required this.activity});

  static const routeName = '/activity';
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.title),
      ),
      body: Center(
        child: Text(activity.description),
      ),
    );
  }
}
