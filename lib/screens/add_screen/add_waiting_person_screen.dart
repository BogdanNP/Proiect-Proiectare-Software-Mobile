import 'package:flutter/material.dart';
import 'package:mobile_app/models/waiting_person.dart';

class AddWaitingPersonScreen extends StatefulWidget {
  final Function(WaitingPerson) saveWaitingPerson;
  final WaitingPerson? waitingPerson;

  const AddWaitingPersonScreen({
    Key? key,
    required this.saveWaitingPerson,
    this.waitingPerson,
  }) : super(key: key);

  @override
  State<AddWaitingPersonScreen> createState() => _AddWaitingPersonScreenState();
}

class _AddWaitingPersonScreenState extends State<AddWaitingPersonScreen> {
  late TextEditingController _userIdController;
  late TextEditingController _deskIdController;

  @override
  initState() {
    super.initState();
    _userIdController = TextEditingController(
        text: widget.waitingPerson?.userId.toString() ?? "");
    _deskIdController = TextEditingController(
        text: widget.waitingPerson?.deskId.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.waitingPerson != null ? "Update " : "Add "}Desk Screen"),
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
              controller: _userIdController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("desk id"),
              ),
              keyboardType: TextInputType.number,
              controller: _deskIdController,
            ),
            ElevatedButton(
              onPressed: () {
                WaitingPerson newWaitingPerson = WaitingPerson(
                  userId: int.tryParse(_userIdController.text) ?? 0,
                  deskId: int.tryParse(_deskIdController.text) ?? 0,
                );
                widget.saveWaitingPerson(newWaitingPerson);
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
