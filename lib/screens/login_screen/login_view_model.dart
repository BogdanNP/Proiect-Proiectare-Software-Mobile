import 'package:flutter/material.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/repos/user_repo.dart';
import 'package:mobile_app/screens/base_list_screen/base_list_view_model.dart';
import 'package:rxdart/rxdart.dart';

class LoginViewModel {
  final UserRepo _userStateRepo;
  final Input input;
  late Output output;
  LoginViewModel(this.input) : _userStateRepo = UserRepo() {
    User _getUser(LoginInput loginInput) {
      return User(
        id: -1,
        type: UserTypeExtension.fromString(loginInput.password),
        username: loginInput.username,
      );
    }

    output = Output(
      input.onLogin.flatMap((loginInput) {
        return _userStateRepo
            .login(loginInput)
            .map((user) => UIModel.success(user));
      }),
    );
  }
}

class LoginInput {
  final String username;
  final String password;
  LoginInput(this.username, this.password);

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

class Input {
  final Subject<LoginInput> onLogin;

  Input(
    this.onLogin,
  );
}

class Output {
  final Stream<UIModel<User>> onLogin;
  Output(this.onLogin);
}
