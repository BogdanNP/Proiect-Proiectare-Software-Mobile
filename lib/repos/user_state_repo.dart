import 'dart:convert';

import 'package:mobile_app/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStateRepo {
  SharedPreferences? _sharedPreferences;

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

  Stream<SharedPreferences> _getPreferences() async* {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    yield _sharedPreferences!;
  }
}
