import 'package:flutter/material.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/room.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/screens/base_list_screen/base_list_view_model.dart';
import 'package:mobile_app/screens/base_list_screen/list_title_widget.dart';
import 'package:mobile_app/screens/desk_list_screen/desk_list_screen.dart';
import 'package:rxdart/rxdart.dart';

class RoomListScreen extends StatefulWidget {
  final User user;
  const RoomListScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  late List<Room> roomList = [];
  late BaseListViewModel<Room> vm;
  bool isError = false;
  bool isLoading = false;

  @override
  initState() {
    super.initState();

    vm = BaseListViewModel<Room>(
      Input(
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
      ),
      ModelType.room,
    );
    vm.output.onStart.listen((data) {
      setState(() {
        debugPrint("${data.state}");
        switch (data.state) {
          case UIState.success:
            roomList = (data.data!.map((e) => e as Room).toList());
            isLoading = false;
            isError = false;
            break;
          case UIState.error:
            debugPrint("${data.error}");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error: ${data.error}")));
            isError = true;
            isLoading = false;
            break;
          case UIState.loading:
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(content: Text("Loading...")));
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
        title: const BaseTitleWidget(ModelType.room),
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
                          ],
                        ),
                      ),
                      ...roomList.map(
                        (e) => RoomCell(
                          room: e,
                          onTap: () {
                            debugPrint("open room details screen");
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return DeskListScreen(
                                roomId: e.id,
                                user: widget.user,
                              );
                            }));
                          },
                        ),
                      ),
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
}

class RoomCell extends StatelessWidget {
  final VoidCallback? onTap;
  final Room room;

  const RoomCell({
    Key? key,
    required this.room,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          color: Colors.blue,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: room.getDisplayData().map((t) => Text(t)).toList(),
          ),
        ),
      ),
    );
  }
}
