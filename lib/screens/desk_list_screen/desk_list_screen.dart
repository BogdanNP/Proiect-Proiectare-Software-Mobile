import 'package:flutter/material.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/models/waiting_person.dart';
import 'package:mobile_app/screens/base_list_screen/list_title_widget.dart';
import 'package:mobile_app/screens/create_desk_request_screen/create_desk_request_screen.dart';
import 'package:mobile_app/screens/desk_list_screen/desk_list_view_model.dart';
import 'package:mobile_app/screens/desk_request_list_screen/desk_request_list_screen.dart';
import 'package:rxdart/rxdart.dart';

class DeskListScreen extends StatefulWidget {
  final int? roomId;
  final User user;
  final bool showOnlySubscribed;
  const DeskListScreen({
    Key? key,
    this.roomId,
    required this.user,
    this.showOnlySubscribed = false,
  }) : super(key: key);

  @override
  State<DeskListScreen> createState() => _DeskListScreenState();
}

class _DeskListScreenState extends State<DeskListScreen> {
  late List<Desk> deskList = [];
  late List<Desk> subscribedDeskList = [];
  late DeskListViewModel vm;
  bool isError = false;
  bool isLoading = false;

  @override
  initState() {
    super.initState();

    vm = DeskListViewModel(
      widget.roomId,
      widget.user.id,
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
            deskList = data.data!;
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

    vm.output.subscribedDeskList.listen((data) {
      setState(() {
        debugPrint("${data.state}");
        switch (data.state) {
          case UIState.success:
            subscribedDeskList = data.data!;
            subscribedDeskList.forEach((element) {
              debugPrint("${element.toJson()}");
            });
            isLoading = false;
            isError = false;
            break;
          case UIState.error:
            debugPrint("${data.error}");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("${data.error}")));
            isError = false;
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

  List<Desk> get _deskList =>
      widget.showOnlySubscribed ? subscribedDeskList : deskList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseTitleWidget(ModelType.desk),
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
                      ..._deskList.map(
                        (desk) => DeskCell(
                          userType: widget.user.type,
                          desk: desk,
                          subscribeEnable: widget.user.type != UserType.guest,
                          tapEnable: true, //widget.user.type != UserType.guest,
                          isSubscribed: subscribedDeskList
                              .where((e) => e.id == desk.id)
                              .isNotEmpty,
                          onTap: widget.user.type == UserType.guest
                              ? null
                              : () => _createDeskRequest(desk),
                          onSubscribeTap: () {
                            if (subscribedDeskList
                                .where((e) => e.id == desk.id)
                                .isNotEmpty) {
                              vm.input.onUnsubscribe.add(widget.user.id);
                            } else {
                              vm.input.onSubscribe.add(WaitingPerson(
                                userId: widget.user.id,
                                deskId: desk.id,
                              ));
                            }
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

  void _createDeskRequest(Desk desk) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CreateDeskRequestScreen(
            desk: desk,
            user: widget.user,
            saveDeskRequest: (deskRequest) {
              debugPrint("${deskRequest.toJson()}");
              vm.input.onDeskRequest.add(deskRequest);
            },
          );
        },
      ),
    ).then((value) {
      if (value) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DeskRequestListScreen(user: widget.user);
            },
          ),
        );
      }
    });
  }
}

class DeskCell extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onSubscribeTap;
  final Desk desk;
  final bool subscribeEnable;
  final bool tapEnable;
  final bool isSubscribed;
  final UserType userType;

  const DeskCell({
    Key? key,
    required this.desk,
    this.onTap,
    this.onSubscribeTap,
    this.tapEnable = false,
    this.subscribeEnable = false,
    this.isSubscribed = false,
    this.userType = UserType.guest,
  }) : super(key: key);

  List<String> _getDisplayData() {
    if (userType == UserType.admin) {
      return desk.getDisplayData();
    }
    if (userType == UserType.loggedIn) {
      return desk.getDisplayData().sublist(2);
    }
    return desk.getDisplayData().sublist(2, 6);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: tapEnable ? onTap : null,
        child: Ink(
          width: double.infinity,
          color: desk.deskStatus == DeskStatus.available
              ? Colors.green
              : Colors.orange,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._getDisplayData().map((t) => Text(t)),
                ],
              ),
              if (subscribeEnable)
                ElevatedButton(
                  onPressed: onSubscribeTap,
                  child: Text(isSubscribed ? "Unsubscribe" : "Subscribe"),
                )
            ],
          ),
        ),
      ),
    );
  }
}
