import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/repos/desk_request_repo.dart';
import 'package:rxdart/rxdart.dart';

class DeskRequestListViewModel {
  final int? userId;
  final Input input;
  final DeskRequestRepo _deskRequestRepo;
  late Output output;

  Stream<UIModel<List<DeskRequest>>> deskListStream() => _deskRequestRepo
      .getDeskRequestList(userId)
      .map((data) => UIModel.success(data))
      .onErrorReturnWith(
        (error, _) => UIModel.error(error),
      )
      .startWith(UIModel.loading())
      .asBroadcastStream();

  DeskRequestListViewModel(this.userId, this.input)
      : _deskRequestRepo = DeskRequestRepo() {
    Stream<UIModel<List<DeskRequest>>> onStart = input.onStart.flatMap((_) {
      return deskListStream();
    });

    output = Output(onStart);
  }
}

class Input {
  final Subject<bool> onStart;

  Input(
    this.onStart,
  );
}

class Output<T> {
  final Stream<UIModel<List<DeskRequest>>> onStart;

  Output(this.onStart);
}
