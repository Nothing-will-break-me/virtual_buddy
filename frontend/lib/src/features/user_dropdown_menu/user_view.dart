import 'package:flutter/material.dart';
import 'user_model.dart';
import 'user_service.dart';
import '../../settings/settings_controller.dart';
import 'dart:developer';


class UserDropdown extends StatefulWidget {
  const UserDropdown({super.key, required this.controller});
  final SettingsController controller;

  @override
  State<UserDropdown> createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  late Future<List<User>> futureUsers;
  User? selectedUser;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
    _loadSelectedUser();
  }

  // Load the saved user
  void _loadSelectedUser() async {
    String? userId = widget.controller.user?.id;
    futureUsers.then((users) {
        setState(() {
          selectedUser = users.firstWhere((user) => user.id == userId, orElse: () => users[0]);
        });
        log(selectedUser?.username ?? "null");
      });
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No users found');
        } else {
          return DropdownButton<User>(
            hint: const Text("Select a user"),
            value: selectedUser,
            onChanged: (User? newUser) {
              setState(() {
                selectedUser = newUser;
              });
              widget.controller.updateUser(newUser);
            },
            items: snapshot.data!.map<DropdownMenuItem<User>>((User user) {
              return DropdownMenuItem<User>(
                value: user,
                child: Text(user.username),
              );
            }).toList(),
          );
        }
      },
    );
  }
}