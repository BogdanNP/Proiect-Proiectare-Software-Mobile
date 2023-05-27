import 'dart:convert';

import 'package:mobile_app/app_values.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/repos/general_repo.dart';
import 'package:mobile_app/screens/login_screen/login_view_model.dart';
import 'package:mobile_app/services/general_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  SharedPreferences? _sharedPreferences;
  final GeneralService _generalRepo;

  UserRepo() : _generalRepo = GeneralService();

  Stream<User> login(LoginInput loginInput) {
    return _generalRepo
        .uploadData(
            "${AppValues.userPath}${AppValues.loginPath}", loginInput.toJson())
        .asStream()
        .map((jsonData) {
      return User.fromJson(jsonData);
    }).flatMap((user) => setUser(user).map((_) => user));
  }

  Stream<User> register(LoginInput loginInput) {
    return _generalRepo
        .uploadData("${AppValues.userPath}${AppValues.registerPath}",
            loginInput.toJson())
        .asStream()
        .map((event) => User.fromJson(event));
  }

  Stream<User?> getUser() {
    return _getPreferences().map(
      (preferences) {
        String? jsonString = preferences.getString("user");
        if (jsonString != null) {
          return User.fromJson(jsonDecode(jsonString));
        }
        return null;
      },
    );
  }

  Stream<bool> setUser(User? user) {
    return _getPreferences().flatMap(
      (preferences) => preferences
          .setString(
            "user",
            jsonEncode(
              user?.toJson(),
            ),
          )
          .asStream(),
    );
  }

  Stream<bool> removeUser() {
    return _getPreferences().flatMap(
      (preferences) => preferences.remove("user").asStream(),
    );
  }

  Stream<SharedPreferences> _getPreferences() async* {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    yield _sharedPreferences!;
  }
}
