import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Workspaces App",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("username"),
                ),
                controller: _usernameController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("password"),
                ),
                obscureText: obscurePassword,
                controller: _passwordController,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _usernameController.text;
                  _passwordController.text;
                  // Navigator.of(context).pop();
                },
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Continue as guest",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
