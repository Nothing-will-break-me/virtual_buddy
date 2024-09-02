import 'package:flutter/material.dart';
import 'package:frontend/src/features/auth/register/register_view.dart';
import '../../../settings/settings_controller.dart';
import 'login_service.dart';
import '../auth_controller.dart';
import '../../app_navigator/app_navigator_view.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key, required this.settingsController});

  final SettingsController settingsController;
  final TextEditingController _usernameInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _usernameInput,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: _passwordInput,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
              ),
            ),
            TextButton(
              onPressed: (){},
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  // Capture the current context
                  final currentContext = context;
                  
                  // Perform the async operation
                  
                  try {
                    final token = await login(_usernameInput.text, _passwordInput.text);


                    // Ensure context is still valid and mounted before using it
                    if (token.isNotEmpty) {
                      storeToken(token);

                      // Check if the widget is still in the tree
                      if (currentContext.mounted) {
                        // Navigate to HomePage
                        Navigator.pushReplacement(
                          currentContext,
                          MaterialPageRoute(builder: (context) => AppNavigator(controller: settingsController)),
                        );
                      }
                    } else {
                      // Handle login failure
                      if (currentContext.mounted) {
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                          const SnackBar(content: Text('Login failed! Please try again.')),
                        );
                      }
                    }
                  } catch (e) {
                    if (currentContext.mounted) {
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text("Don't have an account?"),
              TextButton(
              onPressed: (){
                Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context2) => RegisterScreen(settingsController: settingsController)),
                        );
              },
              child: const Text(
                'Sign up',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            ],)
          ],
        ),
      ),
    );
  }
}
