import 'package:flutter/material.dart';
import 'package:frontend/src/features/user_dropdown_menu/user_model.dart';

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({super.key, required this.user});

  static const routeName = "/user";
  final User user;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
      ),
      body: const Center(
        child: Text("Placeholder for avatar"),
      ),
    );
  }

}