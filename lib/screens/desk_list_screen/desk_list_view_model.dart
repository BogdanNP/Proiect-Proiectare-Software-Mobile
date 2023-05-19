import 'package:flutter/cupertino.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/repos/desk_repo.dart';
import 'package:mobile_app/repos/general_repo.dart';
import 'package:rxdart/rxdart.dart';

class DeskListViewModel {
  final int? roomId;
  final Input input;
  final DeskRepo _deskRepo;
  final GeneralRepo _generalRepo;
  late Output output;

  Stream<UIModel<List<Desk>>> deskListStream() => _deskRepo
      .getDeskList(roomId)
      .map((data) => UIModel.success(data))
      .onErrorReturnWith(
        (error, _) => UIModel.error(error),
      )
      .startWith(UIModel.loading())
      .asBroadcastStream();

  DeskListViewModel(this.roomId, this.input)
      : _deskRepo = DeskRepo(),
        _generalRepo = GeneralRepo(ModelType.deskRequest) {
    Stream<UIModel<List<Desk>>> onStart = input.onStart.flatMap((_) {
      return deskListStream();
    });

    Stream<UIModel<List<Desk>>> onDeskRequest =
        input.onDeskRequest.flatMap((deskRequest) {
      return _generalRepo
          .saveObject(deskRequest)
          .flatMap((_) => deskListStream())
          .onErrorReturnWith((error, _) => UIModel.error(error))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<List<Desk>>> deskListStreamMerge = MergeStream([
      onStart,
      onDeskRequest,
    ]);

    output = Output(deskListStreamMerge);
  }
}

class Input {
  final Subject<bool> onStart;
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
