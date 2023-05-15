import 'package:flutter/material.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/screens/add_screen/add_desk_screen.dart';
import 'package:mobile_app/screens/add_screen/add_screen.dart';
import 'package:mobile_app/screens/base_list_screen/base_list_screen.dart';

void main() {
  runApp(const MyApp());
}

// Legend: * -> not implemented yet

// first screen -> verify user / kind of login
// show menu depending of the type of user (guest/user/admin)

// guest:
//  -show rooms screen
//  -show desks screen

// user:
//  -show rooms screen
//  -show desks screen:  -> can see the current status
//                       -> can make a desk request
//                       -> can subscribe to the waiting list
//                       -> *can see their requests
//  -show orders screen: -> *can see their orders
//                       -> *can pay order

// admin:
//  -> can create/update/delete anything
//  -show users screen
//  -show rooms screen
//  -show desk requests screen
//  -show waiting list screen
//  -show desks screen:  -> can see the current status
//                       -> can make a desk request
//                       -> can subscribe to the waiting list
//                       -> *can see all requests
//  -show orders screen: -> *can see all orders
//                       -> *can pay order

// TODO: create "Add/Update Screen" for each data model
// TODO: create "Login Screen"
// TODO: update Desk to store the room id, and remove deskList from Room
// TODO:

// TODO: target -> be able to create full flows:
// Create account

// Login as User -> check room -> select desk -> get desk request
// -> complete desk request -> pay order

// Login as User -> check room -> select desk -> get desk request
// -> cancel desk request

// Login as User -> check room -> select desk -> subscribe to the waiting list
// -> get notification when its status was changed

// Login as User -> check my requests / past orders

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        primarySwatch: Colors.blue,
        cardColor: Colors.blue.shade300,
      ),
      home: const MyHomePage(title: "Home Page"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _titleWidget(
                "Hello, User!",
              ),
              const Divider(height: 5, color: Colors.white),
              _drawerButton(
                () => _openBaseListScreen(ModelType.desk),
                "Desk List Screen",
              ),
              const Divider(height: 2, color: Colors.white),
              _drawerButton(
                () => _openBaseListScreen(ModelType.deskRequest),
                "DeskRequest List Screen",
              ),
              const Divider(height: 2, color: Colors.white),
              _drawerButton(
                () => _openBaseListScreen(ModelType.order),
                "Order List Screen",
              ),
              const Divider(height: 2, color: Colors.white),
              _drawerButton(
                () => _openBaseListScreen(ModelType.room),
                "Room List Screen",
              ),
              const Divider(height: 2, color: Colors.white),
              _drawerButton(
                () => _openBaseListScreen(ModelType.user),
                "User List Screen",
              ),
              const Divider(height: 2, color: Colors.white),
              _drawerButton(
                () => _openBaseListScreen(ModelType.waitingPerson),
                "WaitingPerson List Screen",
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(),
    );
  }

  Widget _titleWidget(String text) {
    return Container(
      color: Colors.blue,
      height: 50,
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

  Widget _drawerButton(VoidCallback? onTap, String text) {
    return InkWell(
      onTap: onTap,
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
