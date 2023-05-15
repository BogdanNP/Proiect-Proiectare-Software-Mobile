import 'package:mobile_app/models/base_model.dart';

class User extends BaseModel {
  final int id;
  final String? username;
  final UserType type;

  User({
    required this.id,
    required this.type,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      type: UserTypeExtension.fromString(json["type"]),
    );
  }

  @override
  User copyWith({
    int? id,
    String? username,
    UserType? type,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "type": type.stringValue,
    };
  }

  @override
  int getId() => id;

  @override
  List<String> getDisplayData() {
    return [
      "id: $id",
      "username: $username",
      "user type: $type",
    ];
  }
}

enum UserType {
  loggedIn,
  admin,
  guest,
}

extension UserTypeExtension on UserType {
  static UserType fromString(String? v) {
    if (v == "loggedIn") {
      return UserType.loggedIn;
    }
    if (v == "ADMIN") {
      return UserType.admin;
    }
    return UserType.guest;
  }

  String get stringValue {
    switch (this) {
      case UserType.loggedIn:
        return "logged in user";
      case UserType.admin:
        return "admin";
      case UserType.guest:
        return "guest user";
    }
  }
}
