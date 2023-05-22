import 'package:flutter/material.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/models/user.dart';

class CreateDeskRequestScreen extends StatefulWidget {
  final Function(DeskRequest) saveDeskRequest;
  final Desk desk;
  final User user;

  const CreateDeskRequestScreen({
    Key? key,
    required this.saveDeskRequest,
    required this.desk,
    required this.user,
  }) : super(key: key);

  @override
  State<CreateDeskRequestScreen> createState() =>
      _CreateDeskRequestScreenState();
}

class _CreateDeskRequestScreenState extends State<CreateDeskRequestScreen> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  initState() {
    super.initState();
    _startDateController = TextEditingController(
      text: DateTime.now().toString(),
    );
    _endDateController = TextEditingController(
      text: DateTime.now().add(const Duration(hours: 5)).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Desk Request"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text("start date"),
              ),
              controller: _startDateController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("end date"),
              ),
              controller: _endDateController,
            ),
            ElevatedButton(
              onPressed: () {
                DeskRequest newDeskRequest = DeskRequest(
                  id: widget.desk.id,
                  userId: widget.user.id,
                  deskId: widget.desk.id,
                  startDate: DateTime.tryParse(_startDateController.text),
                  endDate: DateTime.tryParse(_endDateController.text),
                  deskStatus: DeskRequestStatus.reserved,
                );
                widget.saveDeskRequest(newDeskRequest);
                Navigator.of(context).pop(true);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
