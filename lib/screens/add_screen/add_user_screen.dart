import 'package:flutter/material.dart';
import 'package:mobile_app/models/user.dart';

class AddUserScreen extends StatefulWidget {
  final Function(User) saveUser;
  final User? user;

  const AddUserScreen({
    Key? key,
    required this.saveUser,
    this.user,
  }) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _totalController;
  late UserType _selectedType;

  @override
  initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.user?.username?.toString() ?? "");
    _selectedType = widget.user?.type ?? UserType.guest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user != null ? "Update " : "Add "}Desk Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text("user id"),
              ),
              keyboardType: TextInputType.number,
              controller: _usernameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("desk id"),
              ),
              keyboardType: TextInputType.number,
              controller: _passwordController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("start date"),
              ),
              controller: _totalController,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                label: Text("desk status"),
              ),
              items: UserType.values
                  .map(
                    (e) => DropdownMenuItem<UserType>(
                      value: e,
                      child: Text(e.stringValue),
                    ),
                  )
                  .toList(),
              onChanged: (UserType? value) {
                setState(() {
                  _selectedType = value ?? UserType.guest;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                User newUser = User(
                  id: widget.user?.id ?? 0,
                  username: _usernameController.text,
                  type: _selectedType,
                );
                widget.saveUser(newUser);
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
