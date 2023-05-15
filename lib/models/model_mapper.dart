import 'package:mobile_app/app_values.dart';
import 'package:mobile_app/models/base_model.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/models/order.dart';
import 'package:mobile_app/models/room.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/models/waiting_person.dart';

abstract class ModelMapper {
  static BaseModel mapTo(Map<String, dynamic> json, ModelType type) {
    switch (type) {
      case ModelType.desk:
        return Desk.fromJson(json);
      case ModelType.deskRequest:
        return DeskRequest.fromJson(json);
      case ModelType.order:
        return Order.fromJson(json);
      case ModelType.room:
        return Room.fromJson(json);
      case ModelType.user:
        return User.fromJson(json);
      case ModelType.waitingPerson:
        return WaitingPerson.fromJson(json);
    }
  }

  static String getPath(ModelType type) {
    switch (type) {
      case ModelType.desk:
        return AppValues.deskPath;
      case ModelType.deskRequest:
        return AppValues.deskRequestPath;
      case ModelType.order:
        return AppValues.orderPath;
      case ModelType.room:
        return AppValues.roomPath;
      case ModelType.user:
        return AppValues.userPath;
      case ModelType.waitingPerson:
        return AppValues.waitingListPath;
    }
  }

  static String screenTitle(ModelType modelType) {
    switch (modelType) {
      case ModelType.desk:
        return "Desk List Screen";
      case ModelType.deskRequest:
        return "Desk Request List Screen";
      case ModelType.order:
        return "Order List Screen";
      case ModelType.room:
        return "Room List Screen";
      case ModelType.user:
        return "User List Screen";
      case ModelType.waitingPerson:
        return "Waiting List Screen";
    }
  }
}

enum ModelType {
  desk,
  deskRequest,
  order,
  room,
  user,
  waitingPerson,
}
