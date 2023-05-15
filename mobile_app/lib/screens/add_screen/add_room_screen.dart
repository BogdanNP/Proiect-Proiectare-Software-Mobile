import 'package:flutter/material.dart';
import 'package:mobile_app/models/room.dart';

class AddRoomScreen extends StatefulWidget {
  final Function(Room) saveRoom;
  final Room? room;

  const AddRoomScreen({
    Key? key,
    required this.saveRoom,
    this.room,
  }) : super(key: key);

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  late TextEditingController _widthController;
  late TextEditingController _lengthController;
  late TextEditingController _detailsController;

  @override
  initState() {
    super.initState();
    _widthController =
        TextEditingController(text: widget.room?.width?.toString() ?? "");
    _lengthController =
        TextEditingController(text: widget.room?.width?.toString() ?? "");
    _detailsController =
        TextEditingController(text: widget.room?.details?.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.room != null ? "Update " : "Add "}Desk Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text("width"),
                hintText: "m",
              ),
              keyboardType: TextInputType.number,
              controller: _widthController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("length"),
                hintText: "m",
              ),
              keyboardType: TextInputType.number,
              controller: _lengthController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("details"),
              ),
              controller: _detailsController,
            ),
            ElevatedButton(
              onPressed: () {
                Room newRoom = Room(
                  id: widget.room?.id ?? 0,
                  width: int.tryParse(_widthController.text),
                  length: int.tryParse(_lengthController.text),
                  details: _detailsController.text,
                );
                widget.saveRoom(newRoom);
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
