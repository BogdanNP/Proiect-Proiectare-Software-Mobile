import 'package:flutter/material.dart';
import 'package:mobile_app/models/order.dart';

class AddOrderScreen extends StatefulWidget {
  final Function(Order) saveOrder;
  final Order? order;

  const AddOrderScreen({
    Key? key,
    required this.saveOrder,
    this.order,
  }) : super(key: key);

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  late TextEditingController _userIdController;
  late TextEditingController _deskIdController;
  late TextEditingController _totalController;
  late OrderStatus _selectedStatus;

  @override
  initState() {
    super.initState();
    _userIdController =
        TextEditingController(text: widget.order?.userId?.toString() ?? "");
    _deskIdController =
        TextEditingController(text: widget.order?.deskId?.toString() ?? "");
    _totalController =
        TextEditingController(text: widget.order?.total?.toString() ?? "");
    _selectedStatus = widget.order?.orderStatus ?? OrderStatus.unknown;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.order != null ? "Update " : "Add New "}Order"),
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
              controller: _totalController,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                label: Text("order status"),
              ),
              items: OrderStatus.values
                  .map(
                    (e) => DropdownMenuItem<OrderStatus>(
                      value: e,
                      child: Text(e.stringValue),
                    ),
                  )
                  .toList(),
              onChanged: (OrderStatus? value) {
                setState(() {
                  _selectedStatus = value ?? OrderStatus.unknown;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                Order newOrder = Order(
                  id: widget.order?.id ?? 0,
                  userId: int.tryParse(_userIdController.text),
                  deskId: int.tryParse(_deskIdController.text),
                  total: double.tryParse(_totalController.text),
                  orderStatus: _selectedStatus,
                );
                widget.saveOrder(newOrder);
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
