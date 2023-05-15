import 'package:flutter/material.dart';
import 'package:mobile_app/models/base_model.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/order.dart';
import 'package:mobile_app/models/room.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/screens/add_screen/add_desk_screen.dart';
import 'package:mobile_app/screens/add_screen/add_room_screen.dart';

import 'add_desk_request_screen.dart';
import 'add_order_screen.dart';
import 'add_user_screen.dart';

class BaseAddScreen extends StatelessWidget {
  final BaseModel? object;
  final ModelType modelType;
  final Function(BaseModel) saveObject;

  const BaseAddScreen({
    Key? key,
    required this.object,
    required this.modelType,
    required this.saveObject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (modelType) {
      case ModelType.desk:
        return AddDeskScreen(
          saveDesk: saveObject,
          desk: object as Desk?,
        );
      case ModelType.deskRequest:
        return AddDeskRequestScreen(
          saveDeskRequest: saveObject,
          deskRequest: object as DeskRequest?,
        );
      case ModelType.order:
        return AddOrderScreen(
          saveOrder: saveObject,
          order: object as Order?,
        );
      case ModelType.room:
        return AddRoomScreen(
          saveRoom: saveObject,
          room: object as Room?,
        );
      case ModelType.user:
        return AddUserScreen(
          saveUser: saveObject,
          user: object as User?,
        );
      case ModelType.waitingPerson:
        // TODO: Handle this case.
        break;
    }
    return AddDeskScreen(
      saveDesk: saveObject,
      desk: object as Desk?,
    );
  }
}
