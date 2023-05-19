import 'package:flutter/material.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/screens/add_screen/add_desk_screen.dart';
import 'package:mobile_app/screens/add_screen/add_screen.dart';
import 'package:mobile_app/screens/base_list_screen/base_list_screen.dart';
import 'package:mobile_app/screens/desk_request_list_screen/desk_request_list_screen.dart';
import 'package:mobile_app/screens/home_screen/home_screen_view_model.dart';
import 'package:mobile_app/screens/login_screen/login_screen.dart';
import 'package:mobile_app/screens/room_list_screen/room_list_screen.dart';
import 'package:rxdart/rxdart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late HomeScreenViewModel _vm;
  User user = User(id: -1, type: UserType.guest);

  @override
  initState() {
    super.initState();
    _vm = HomeScreenViewModel(Input(
      PublishSubject(),
      PublishSubject(),
    ));

    _vm.output.onStart.listen((event) {
      setState(() {
        switch (event.state) {
          case UIState.success:
            // debugPrint("${event.data?.username}");
            // debugPrint("${event.data?.type}");
            user = event.data ?? user;
            break;
          case UIState.error:
            break;
          case UIState.loading:
            break;
        }
      });
    });
    _vm.input.onStart.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: _drawerContent(),
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            _loginLogoutButton(),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return RoomListScreen(
                        user: user,
                      );
                    },
                  ),
                );
              },
              child: const Text("Room List"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return DeskRequestListScreen(
                        user: user,
                      );
                    },
                  ),
                );
              },
              child: const Text("My Desk Requests"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget(String text) {
    return Container(
      color: Colors.blue,
      height: 60,
      padding: const EdgeInsets.only(left: 10),
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 30),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginLogoutButton() {
    return TextButton(
      onPressed: () {
        if (user.type != UserType.guest) {
          _vm.input.onLogout.add(true);
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ),
        ).then((_) => _vm.input.onStart.add(true));
      },
      child: Text(
        user.type == UserType.guest ? "Log in" : "Log out",
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          // decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _drawerButton(VoidCallback? onTap, String text) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap?.call();
      },
      child: Ink(
        color: Colors.blue,
        height: 50,
        padding: const EdgeInsets.only(left: 10),
        width: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _drawerContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _titleWidget(
          user.type == UserType.guest ? "Hello!" : "Hello, ${user.username}!",
        ),
        const Divider(height: 5, color: Colors.white),
        _drawerButton(
          () => _openBaseListScreen(ModelType.desk),
          ModelMapper.screenTitle(ModelType.desk),
        ),
        const Divider(height: 2, color: Colors.white),
        _drawerButton(
          () => _openBaseListScreen(ModelType.deskRequest),
          ModelMapper.screenTitle(ModelType.deskRequest),
        ),
        const Divider(height: 2, color: Colors.white),
        _drawerButton(
          () => _openBaseListScreen(ModelType.order),
          ModelMapper.screenTitle(ModelType.order),
        ),
        const Divider(height: 2, color: Colors.white),
        _drawerButton(
          () => _openBaseListScreen(ModelType.room),
          ModelMapper.screenTitle(ModelType.room),
        ),
        const Divider(height: 2, color: Colors.white),
        _drawerButton(
          () => _openBaseListScreen(ModelType.user),
          ModelMapper.screenTitle(ModelType.user),
        ),
        const Divider(height: 2, color: Colors.white),
        _drawerButton(
          () => _openBaseListScreen(ModelType.waitingPerson),
          ModelMapper.screenTitle(ModelType.waitingPerson),
        ),
      ],
    );
  }

  void _openBaseListScreen(ModelType type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return BaseListScreen(
            modelType: type,
          );
        },
      ),
    );
  }
}
