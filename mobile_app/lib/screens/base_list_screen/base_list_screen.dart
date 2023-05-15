import 'package:flutter/material.dart';
import 'package:mobile_app/models/base_model.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/order.dart';
import 'package:mobile_app/models/room.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/screens/add_screen/add_desk_screen.dart';
import 'package:mobile_app/screens/add_screen/add_screen.dart';
import 'package:mobile_app/screens/base_list_screen/base_list_view_model.dart';
import 'package:rxdart/rxdart.dart';

class BaseListScreen<T extends BaseModel> extends StatefulWidget {
  final ModelType modelType;
  const BaseListScreen({
    Key? key,
    required this.modelType,
  }) : super(key: key);

  @override
  State<BaseListScreen> createState() => _BaseListScreenState<T>();
}

class _BaseListScreenState<T extends BaseModel> extends State<BaseListScreen> {
  late List<BaseModel> baseModelList = [];
  late BaseListViewModel vm;
  bool isError = false;
  bool isLoading = false;

  @override
  initState() {
    super.initState();

    vm = BaseListViewModel<T>(
      Input(
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
      ),
      widget.modelType,
    );
    vm.output.onStart.listen((data) {
      setState(() {
        debugPrint("${data.state}");
        switch (data.state) {
          case UIState.success:
            baseModelList = data.data ?? [];
            isLoading = false;
            isError = false;
            break;
          case UIState.error:
            debugPrint("${data.error}");
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
        title: BaseTitleWidget(widget.modelType),
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
                            // ElevatedButton(
                            //   child: const Text("Update First"),
                            //   onPressed: () => vm.input.onUpdate.add(
                            //     baseModelList.first,
                            //   ),
                            // ),
                            ElevatedButton(
                                child: const Text("Add New"),
                                onPressed: () {
                                  _openUpdateScreen();
                                }),
                          ],
                        ),
                      ),
                      ...baseModelList.map((e) => GeneralCell(
                            baseModel: e,
                            onDelete: () {
                              vm.input.onDelete.add(e);
                            },
                            onUpdate: () {
                              _openUpdateScreen(object: e);
                            },
                          )),
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

  BaseModel _getNewObject() {
    switch (widget.modelType) {
      case ModelType.desk:
        return Desk(
          id: 0,
          width: 100,
          length: 100,
          height: 100,
          tariff: 100.0,
          tariffType: TariffType.day,
        );
      case ModelType.deskRequest:
        return DeskRequest(
          id: 0,
          userId: 2,
          deskId: 2,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          deskStatus: DeskStatus.reserved,
        );
      case ModelType.order:
        return Order(
          id: 1,
          userId: 2,
          deskId: 2,
          total: 100,
          orderStatus: OrderStatus.newOrder,
        );
      case ModelType.room:
        return Room(
          id: 1,
          width: 100,
          length: 100,
          details: "Large Room",
        );
      case ModelType.user:
        return User(id: 1, type: UserType.guest, username: "Guest1");
      case ModelType.waitingPerson:
        // TODO: Handle this case.
        break;
    }
    return Desk(id: 0);
  }

  void _openUpdateScreen({BaseModel? object}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return BaseAddScreen(
            object: object,
            modelType: widget.modelType,
            saveObject:
                object == null ? vm.input.onSave.add : vm.input.onUpdate.add,
          );
        },
      ),
    );
  }

// Widget _deskCell(BaseModel desk) {}

}

class BaseTitleWidget extends StatelessWidget {
  final ModelType modelType;
  const BaseTitleWidget(this.modelType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(ModelMapper.screenTitle(modelType));
  }
}

class GeneralCell extends StatelessWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;
  final BaseModel baseModel;
  // ModelType modelType;
  const GeneralCell({
    Key? key,
    required this.baseModel,
    this.onDelete,
    this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: baseModel.getDisplayData().map((t) => Text(t)).toList(),
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: onUpdate,
                child: const Text("Update"),
              ),
              ElevatedButton(
                onPressed: onDelete,
                child: const Text("Delete"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
