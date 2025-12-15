import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/session_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<SessionService>().login();
          },
          child: const Text("Login to App"),
        ),
      ),
    );
  }
}
