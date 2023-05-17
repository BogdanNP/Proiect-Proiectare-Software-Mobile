import 'package:flutter/material.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/screens/login_screen/login_view_model.dart';
import 'package:rxdart/rxdart.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginViewModel _vm;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _vm = LoginViewModel(
      Input(
        PublishSubject(),
      ),
    );
    _vm.output.onLogin.listen((event) {
      switch (event.state) {
        case UIState.success:
          // debugPrint("${event.data?.username}");
          // debugPrint("${event.data?.type}");
          Navigator.of(context).pop();
          break;
        case UIState.error:
          // TODO: Handle this case.
          break;
        case UIState.loading:
          // TODO: Handle this case.
          break;
      }
    });
  }

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
                decoration: InputDecoration(
                  label: const Text("password"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                    ),
                  ),
                ),
                obscureText: obscurePassword,
                controller: _passwordController,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _vm.input.onLogin.add(
                    LoginInput(
                      _usernameController.text,
                      _passwordController.text,
                    ),
                  );
                  // Navigator.of(context).pop();
                },
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  "Or continue as guest",
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
