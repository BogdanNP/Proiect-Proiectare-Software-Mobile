import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/repos/user_state_repo.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenViewModel {
  final UserStateRepo _userStateRepo;
  final Input input;
  late Output output;

  Stream<User?> _userStream() => _userStateRepo.getUser();

  HomeScreenViewModel(this.input) : _userStateRepo = UserStateRepo() {
    Stream<UIModel<User?>> onLogout = input.onLogout.flatMap((_) {
      return _userStateRepo.removeUser().map(
            (_) => UIModel.success(User(id: -1, type: UserType.guest)),
          );
    });

    Stream<UIModel<User?>> onStart = input.onStart
        .flatMap(
          (_) => _userStream().map(
            (user) => UIModel.success(user),
          ),
        )
        .startWith(UIModel.loading())
        .onErrorReturnWith((error, _) => UIModel.error(error));

    Stream<UIModel<User?>> onUserChange = Rx.merge([onStart, onLogout]);

    output = Output(
      onUserChange,
    );
  }
}

class Input {
  final Subject<bool> onLogout;
  final Subject<bool> onStart;
  Input(
    this.onStart,
    this.onLogout,
  );
}

class Output {
  final Stream<UIModel<User?>> onStart;
  Output(this.onStart);
}
