import 'package:flutter/material.dart';
import 'package:mobile_app/models/desk.dart';

class AddDeskScreen extends StatefulWidget {
  final Function(Desk) saveDesk;
  final Desk? desk;

  const AddDeskScreen({Key? key, required this.saveDesk, this.desk})
      : super(key: key);

  @override
  State<AddDeskScreen> createState() => _AddDeskScreenState();
}

class _AddDeskScreenState extends State<AddDeskScreen> {
  late TextEditingController _widthController;
  late TextEditingController _lengthController;
  late TextEditingController _heightController;
  late TextEditingController _tariffController;
  late TextEditingController _roomIdController;
  late TariffType _selectedTariff;
  late DeskStatus _selectedStatus;

  @override
  initState() {
    super.initState();
    _widthController =
        TextEditingController(text: widget.desk?.width?.toString() ?? "");
    _lengthController =
        TextEditingController(text: widget.desk?.width?.toString() ?? "");
    _heightController =
        TextEditingController(text: widget.desk?.width?.toString() ?? "");
    _tariffController =
        TextEditingController(text: widget.desk?.width?.toString() ?? "");
    _roomIdController =
        TextEditingController(text: widget.desk?.roomId?.toString() ?? "");
    _selectedTariff = widget.desk?.tariffType ?? TariffType.hour;
    _selectedStatus = widget.desk?.deskStatus ?? DeskStatus.unknown;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.desk != null ? "Update " : "Add New "}Desk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("room id"),
                ),
                keyboardType: TextInputType.number,
                controller: _roomIdController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("width"),
                  hintText: "cm",
                ),
                keyboardType: TextInputType.number,
                controller: _widthController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("length"),
                  hintText: "cm",
                ),
                keyboardType: TextInputType.number,
                controller: _lengthController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("height"),
                  hintText: "cm",
                ),
                keyboardType: TextInputType.number,
                controller: _heightController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("tariff"),
                  hintText: "\$",
                ),
                keyboardType: TextInputType.number,
                controller: _tariffController,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  label: Text("tariff type"),
                  hintText: "\$",
                ),
                items: TariffType.values
                    .map(
                      (e) => DropdownMenuItem<TariffType>(
                        value: e,
                        child: Text(e.stringValue),
                      ),
                    )
                    .toList(),
                onChanged: (TariffType? value) {
                  setState(() {
                    _selectedTariff = value ?? TariffType.day;
                  });
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  label: Text("desk status"),
                  hintText: "\$",
                ),
                items: DeskStatus.values
                    .map(
                      (e) => DropdownMenuItem<DeskStatus>(
                        value: e,
                        child: Text(e.stringValue),
                      ),
                    )
                    .toList(),
                onChanged: (DeskStatus? value) {
                  setState(() {
                    _selectedStatus = value ?? DeskStatus.unknown;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Desk newDesk = Desk(
                    id: widget.desk?.id ?? 0,
                    width: int.tryParse(_widthController.text),
                    length: int.tryParse(_lengthController.text),
                    height: int.tryParse(_heightController.text),
                    tariff: double.tryParse(_tariffController.text),
                    tariffType: _selectedTariff,
                    deskStatus: _selectedStatus,
                    roomId: int.tryParse(_roomIdController.text),
                  );
                  widget.saveDesk(newDesk);
                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
