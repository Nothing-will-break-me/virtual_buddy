import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/src/features/search_bar/search_bar_view.dart';
import 'package:frontend/src/features/user_dropdown_menu/user_details_view.dart';
import 'package:frontend/src/features/user_dropdown_menu/user_model.dart';
import 'package:frontend/src/features/user_dropdown_menu/user_service.dart';

import 'features/activity_list/activity_details_view.dart';
import 'features/activity_list/activity_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'features/activity_list/activity_model.dart';
import 'features/app_navigator/app_navigator_view.dart';
import 'features/auth/login/login_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('es'),
          ],
          locale: const Locale('en', ''),

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          home: LoginScreen(settingsController: settingsController),

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            switch (routeSettings.name) {
              case SettingsView.routeName:
                return MaterialPageRoute<void>(
                  builder: (BuildContext context) => SettingsView(controller: settingsController),
                  settings: routeSettings,
                );
              case ActivityDetailsView.routeName:
                final activity = routeSettings.arguments as Activity;
                return MaterialPageRoute<void>(
                  builder: (BuildContext context) => ActivityDetailsView(activity: activity),
                  settings: routeSettings,
                );
                case UserDetailsView.routeName:
                final user = routeSettings.arguments as User;
                return MaterialPageRoute<void>(
                  builder: (BuildContext context) => UserDetailsView(user: user),
                  );
              case AppNavigator.routeName:
                return MaterialPageRoute<void>(
                  builder: (BuildContext context) => AppNavigator(controller: settingsController),
                  settings: routeSettings,
                );
              case SearchBarPage.routeName:
                return MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SearchBarPage(service: fetchUsers),
                  settings: routeSettings,
                );
              case ActivityListView.routeName:
              default:
                return MaterialPageRoute<void>(
                  builder: (BuildContext context) => ActivityListView(controller: settingsController),
                  settings: routeSettings,
                );
            }
          },
        );
      },
    );
  }
}
