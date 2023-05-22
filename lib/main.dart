import 'package:flutter/material.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/screens/add_screen/add_desk_screen.dart';
import 'package:mobile_app/screens/add_screen/add_screen.dart';
import 'package:mobile_app/screens/base_list_screen/base_list_screen.dart';
import 'package:mobile_app/screens/home_screen/home_screen.dart';
import 'package:mobile_app/screens/login_screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

// Legend: * -> not implemented yet

// first screen -> verify user / kind of login
// show menu depending of the type of user (guest/user/admin)

// guest:
//  -show rooms screen -> DONE
//  -show desks screen -> DONE // hide the status

// user:
//  -show rooms screen  -> DONE
//  -show desks screen:  -> can see the current status -> DONE
//                       -> can make a desk request -> DONE
//                       -> can subscribe to the waiting list -> DONE
//                       -> can see their requests -> DONE
//  -show orders screen: -> *can see their orders
//                       -> *can pay order

// admin:
//  -> can create/update/delete anything -> DOME
//  -show users screen -> DONE
//  -show rooms screen -> DONE
//  -show desk requests screen -> DONE
//  -show waiting list screen -> DONE
//  -show desks screen:  -> can see the current status -> DONE
//                       -> can make a desk request -> DONE
//                       -> can subscribe to the waiting list -> DONE
//                       -> can see all requests -> DONE
//  -show orders screen: -> can see all orders -> DONE
//                       -> *can pay order

// TODO: create "Login Screen" -> DONE
// TODO: update Desk to store the room id, and remove deskList from Room -> DONE

// TODO: target -> be able to create full flows:
// TODO: create the logic then create the screens
// TODO: create the endpoint/request service first -> repo -> vm -> screen
// TODO:

// Create account

// Login as User -> check room -> select desk -> get desk request
// -> complete desk request -> pay order

// how to complete desk requests:
// show the time left -> if the time passes and the user did not check out
// then count it as extra time ??? what about the case when there are 2
// desk requests, one after another ???

// Login as User -> check room -> select desk -> get desk request
// -> cancel desk request

// Login as User -> check room -> select desk -> subscribe to the waiting list
// -> get notification when its status was changed

// Login as User -> check my requests / past orders

// When user creates a desk request -> update the desk status
// After the desk request is completed -> update the desk status
// Maybe make the completion automatically -> after the duration has passed
// change the desk status

// create my requests screen -> get all the desk requests for a specific user -> DONE

// TODO: check the logic and make all work :D

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
      // home: const LoginScreen(),
    );
  }
}
