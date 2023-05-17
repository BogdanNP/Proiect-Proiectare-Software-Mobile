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
    output = Output(
      input.onStart
          .flatMap(
            (_) => _userStream().map(
              (user) => UIModel.success(user),
            ),
          )
          .startWith(UIModel.loading())
          .onErrorReturnWith((error, _) => UIModel.error(error)),
    );
  }
}

class Input {
  final Subject<bool> onStart;
  Input(this.onStart);
}

class Output {
  final Stream<UIModel<User?>> onStart;
  Output(this.onStart);
}
