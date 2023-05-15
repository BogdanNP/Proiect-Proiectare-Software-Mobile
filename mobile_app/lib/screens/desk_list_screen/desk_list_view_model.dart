import 'package:flutter/cupertino.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/repos/desk_repo.dart';
import 'package:rxdart/rxdart.dart';

class DeskListViewModel {
  final Input input;
  final DeskRepo _deskRepo;
  late Output output;

  Stream<UIModel<List<Desk>>> deskListStream() => _deskRepo
      .getDeskList()
      .map((data) => UIModel.success(data))
      .onErrorReturnWith(
        (error, _) => UIModel.error(error),
      )
      .startWith(UIModel.loading())
      .asBroadcastStream();

  DeskListViewModel(this.input, {DeskRepo? deskRepo})
      : _deskRepo = deskRepo ?? DeskRepo() {
    Stream<UIModel<List<Desk>>> onStart = input.onStart.flatMap((_) {
      return deskListStream();
    });

    Stream<UIModel<List<Desk>>> onSaveDesk = input.onSaveDesk.flatMap((desk) {
      return _deskRepo
          .saveDesk(desk)
          .flatMap((_) => deskListStream())
          .onErrorReturnWith((error, _) => UIModel.error(error))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<List<Desk>>> onUpdateDesk =
        input.onUpdateDesk.flatMap((desk) {
      return _deskRepo
          .updateDesk(desk)
          .flatMap((_) => deskListStream())
          .onErrorReturnWith((error, _) => UIModel.error(error))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<List<Desk>>> onDeleteDesk =
        input.onDeleteDesk.flatMap((desk) {
      return _deskRepo
          .deleteDesk(desk.id)
          .flatMap((_) {
            debugPrint("Delete Response: $_");
            return deskListStream();
          })
          .onErrorReturnWith((error, _) => UIModel.error(error))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<List<Desk>>> deskListStreamMerge = MergeStream([
      onStart,
      onSaveDesk,
      onUpdateDesk,
      onDeleteDesk,
    ]);

    output = Output(deskListStreamMerge);
  }
}

class Input {
  final Subject<bool> onStart;
  final Subject<Desk> onSaveDesk;
  final Subject<Desk> onUpdateDesk;
  final Subject<Desk> onDeleteDesk;

  Input(
    this.onStart,
    this.onSaveDesk,
    this.onUpdateDesk,
    this.onDeleteDesk,
  );
}

class Output<T> {
  final Stream<UIModel<List<Desk>>> onStart;

  Output(this.onStart);
}
