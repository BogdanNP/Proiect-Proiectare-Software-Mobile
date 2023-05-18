import 'package:flutter/cupertino.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/repos/desk_repo.dart';
import 'package:rxdart/rxdart.dart';

class DeskListViewModel {
  final Input input;
  final DeskRepo _deskRepo;
  late Output output;

  Stream<UIModel<List<Desk>>> deskListStream(int? roomId) => _deskRepo
      .getDeskList(roomId)
      .map((data) => UIModel.success(data))
      .onErrorReturnWith(
        (error, _) => UIModel.error(error),
      )
      .startWith(UIModel.loading())
      .asBroadcastStream();

  DeskListViewModel(this.input, {DeskRepo? deskRepo})
      : _deskRepo = deskRepo ?? DeskRepo() {
    Stream<UIModel<List<Desk>>> onStart = input.onStart.flatMap((roomId) {
      return deskListStream(roomId);
    });

    // Stream<UIModel<List<Desk>>> onDeskRequest =
    //     input.onDeskRequest.flatMap((desk) {
    //   return _deskRepo
    //       .saveDesk(desk)
    //       .flatMap((_) => deskListStream())
    //       .onErrorReturnWith((error, _) => UIModel.error(error))
    //       .startWith(UIModel.loading());
    // });

    Stream<UIModel<List<Desk>>> deskListStreamMerge = MergeStream([
      onStart,
      // onDeskRequest,
    ]);

    output = Output(deskListStreamMerge);
  }
}

class Input {
  final Subject<int?> onStart;
  final Subject<DeskRequest> onDeskRequest;

  Input(
    this.onStart,
    this.onDeskRequest,
  );
}

class Output<T> {
  final Stream<UIModel<List<Desk>>> onStart;

  Output(this.onStart);
}
