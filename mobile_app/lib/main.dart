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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _openBaseListScreen(ModelType.desk),
              child: const Text("Desk List Screen"),
            ),
            ElevatedButton(
              onPressed: () => _openBaseListScreen(ModelType.deskRequest),
              child: const Text("DeskRequest List Screen"),
            ),
            ElevatedButton(
              onPressed: () => _openBaseListScreen(ModelType.order),
              child: const Text("Order List Screen"),
            ),
            ElevatedButton(
              onPressed: () => _openBaseListScreen(ModelType.room),
              child: const Text("Room List Screen"),
            ),
            ElevatedButton(
              onPressed: () => _openBaseListScreen(ModelType.user),
              child: const Text("User List Screen"),
            ),
            ElevatedButton(
              onPressed: () => _openBaseListScreen(ModelType.waitingPerson),
              child: const Text("WaitingPerson List Screen"),
            ),
          ],
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
