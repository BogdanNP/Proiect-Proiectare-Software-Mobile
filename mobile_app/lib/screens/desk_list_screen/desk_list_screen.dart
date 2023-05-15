import 'package:flutter/material.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:rxdart/rxdart.dart';
import 'desk_list_view_model.dart';

class DeskListScreen extends StatefulWidget {
  const DeskListScreen({Key? key}) : super(key: key);

  @override
  State<DeskListScreen> createState() => _DeskListScreenState();
}

class _DeskListScreenState extends State<DeskListScreen> {
  late List<Desk> deskList = [];
  late DeskListViewModel vm;
  bool isError = false;
  bool isLoading = false;

  @override
  initState() {
    super.initState();

    vm = DeskListViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
      ),
    );
    vm.output.onStart.listen((data) {
      setState(() {
        debugPrint("${data.state}");
        switch (data.state) {
          case UIState.success:
            deskList = data.data ?? [];
            isLoading = false;
            isError = false;
            break;
          case UIState.error:
            isError = true;
            isLoading = false;
            break;
          case UIState.loading:
            isLoading = true;
            break;
        }
      });
    });
    vm.input.onStart.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Desk List Screen"),
      ),
      body: !isError
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              child: const Text("Refresh"),
                              onPressed: () => vm.input.onStart.add(true),
                            ),
                            ElevatedButton(
                              child: const Text("Add Desk"),
                              onPressed: () => vm.input.onSaveDesk.add(
                                Desk(
                                  id: 0,
                                  width: 100,
                                  length: 100,
                                  height: 100,
                                  tariff: 100.0,
                                  tariffType: TariffType.day,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: const Text("Update Desk"),
                              onPressed: () => vm.input.onUpdateDesk.add(
                                deskList.first.copyWith(length: 300),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...deskList.map((e) => _deskCell(e)),
                    ],
                  ),
                ),
                if (isLoading)
                  const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      strokeWidth: 5,
                    ),
                  ),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: const Text("Refresh"),
                onPressed: () => vm.input.onStart.add(true),
              ),
            ),
    );
  }

  Widget _deskCell(Desk desk) {
    return Container(
      width: double.infinity,
      color: Colors.green,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text("id: ${desk.id}"),
              Text("\$${desk.tariff}/${desk.tariffType?.stringValue}"),
              Text("W: ${desk.width}"),
              Text("L: ${desk.length}"),
              Text("H: ${desk.height}"),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  vm.input.onDeleteDesk.add(desk);
                },
                child: const Text("Delete"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
