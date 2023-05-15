import 'package:flutter/material.dart';
import 'package:mobile_app/models/desk_request.dart';

class AddDeskRequestScreen extends StatefulWidget {
  final Function(DeskRequest) saveDeskRequest;
  final DeskRequest? deskRequest;

  const AddDeskRequestScreen({
    Key? key,
    required this.saveDeskRequest,
    this.deskRequest,
  }) : super(key: key);

  @override
  State<AddDeskRequestScreen> createState() => _AddDeskRequestScreenState();
}

class _AddDeskRequestScreenState extends State<AddDeskRequestScreen> {
  late TextEditingController _userIdController;
  late TextEditingController _deskIdController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late DeskRequestStatus _selectedStatus;

  @override
  initState() {
    super.initState();
    _userIdController = TextEditingController(
        text: widget.deskRequest?.userId?.toString() ?? "");
    _deskIdController = TextEditingController(
        text: widget.deskRequest?.deskId?.toString() ?? "");
    _startDateController = TextEditingController(
        text: widget.deskRequest?.startDate?.toString() ?? "");
    _endDateController = TextEditingController(
        text: widget.deskRequest?.endDate?.toString() ?? "");
    _selectedStatus =
        widget.deskRequest?.deskStatus ?? DeskRequestStatus.finished;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.deskRequest != null ? "Update " : "Add "}Desk Screen"),
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
            DropdownButtonFormField(
              decoration: const InputDecoration(
                label: Text("desk status"),
              ),
              items: DeskRequestStatus.values
                  .map(
                    (e) => DropdownMenuItem<DeskRequestStatus>(
                      value: e,
                      child: Text(e.stringValue),
                    ),
                  )
                  .toList(),
              onChanged: (DeskRequestStatus? value) {
                setState(() {
                  _selectedStatus = value ?? DeskRequestStatus.finished;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                DeskRequest newDeskRequest = DeskRequest(
                  id: widget.deskRequest?.id ?? 0,
                  userId: int.tryParse(_userIdController.text),
                  deskId: int.tryParse(_deskIdController.text),
                  startDate: DateTime.tryParse(_startDateController.text),
                  endDate: DateTime.tryParse(_endDateController.text),
                  deskStatus: _selectedStatus,
                );
                widget.saveDeskRequest(newDeskRequest);
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
