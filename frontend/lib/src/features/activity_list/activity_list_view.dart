import 'package:flutter/material.dart';
import 'package:frontend/src/features/activity_list/activity_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../settings/settings_view.dart';
import '../../settings/settings_controller.dart';
import 'activity_model.dart';
import 'activity_details_view.dart';
import 'dart:developer';


class ActivityListView extends StatefulWidget {
  const ActivityListView({super.key, required this.controller});
  final SettingsController controller;
  static const routeName = "/activities";

  @override
  State<ActivityListView> createState() => _ActivityListView();
}

class _ActivityListView extends State<ActivityListView> {
  late Future<List<Activity>> futureActivities;

  @override
  void initState() {
    super.initState();
    futureActivities = fetchActivities();
    _loadActivities();
  }

  // Load the saved user
  void _loadActivities() async {
    futureActivities.then((activities) {
        log("Loaded activities");
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.activityFeed),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Activity>>(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              future: futureActivities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No activities found'));
              } else {
                List<Activity> activityList = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  restorationId: 'ActivityFeedListView',
                  itemCount: activityList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return getListTile(activityList[index], context);
                  },
                );}
              } 
            ),
          ),
          FloatingActionButton(
            onPressed: (){
              setState(() {
                futureActivities = fetchActivities();
              });
            },
            child: const Icon(Icons.refresh)
          )
        ],
      ),
    );
  }

  ListTile getListTile(Activity? activity, BuildContext context) {
    return ListTile(
                    title: Text(activity?.title ?? "none"),
                    leading: const CircleAvatar(
                      // Display the Flutter Logo image asset.
                      foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                    ),
                    onTap: () {
                      // Navigate to the details page. If the user leaves and returns to
                      // the app after it has been killed while running in the
                      // background, the navigation stack is restored.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityDetailsView(activity: activity!),
                        ),
                      );
                    }
                  );
  }
}
