import 'package:flutter/material.dart';
import 'package:frontend/src/features/activity_add/activity_add_view.dart';
import '../../settings/settings_controller.dart';
import '../activity_list/activity_list_view.dart';

/// Flutter code sample for [NavigationBar].


class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key, required this.controller});
  static const routeName = '/';
  final SettingsController controller;

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int currentPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {selectPage(index);},
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.import_contacts),
            label: 'Avatar',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.add_circle)),
            label: 'Add new activity',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.dangerous)),
            label: 'Activities',
          ),
        ],
      ),
      body: <Widget>[
        const Center(child: Text("Your avatar")),
        ActivityAddForm(controller: widget.controller),
        ActivityListView(controller: widget.controller),
      ][currentPageIndex],
    );
  }
}
