import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/models/waiting_person.dart';
import 'package:mobile_app/repos/desk_repo.dart';
import 'package:mobile_app/repos/general_repo.dart';
import 'package:mobile_app/repos/waiting_list_repo.dart';
import 'package:rxdart/rxdart.dart';

class DeskListViewModel {
  final int? roomId;
  final int? userId;
  final Input input;
  final DeskRepo _deskRepo;
  final GeneralRepo _generalRepo;
  final WaitingListRepo _waitingListRepo;
  late Output output;

  Stream<UIModel<List<Desk>>> deskListStream() => _deskRepo
      .getDeskList(roomId)
      .map((data) => UIModel.success(data))
      .onErrorReturnWith(
        (error, _) => UIModel.error(error),
      )
      .startWith(UIModel.loading())
      .asBroadcastStream();

  Stream<UIModel<List<Desk>>> subscribedDeskListStream() => _waitingListRepo
      .getDeskList(userId)
      .map((data) => UIModel.success(data))
      .onErrorReturnWith(
        (error, _) => UIModel.error(error),
      )
      .startWith(UIModel.loading())
      .asBroadcastStream();

  DeskListViewModel(this.roomId, this.userId, this.input)
      : _deskRepo = DeskRepo(),
        _generalRepo = GeneralRepo(ModelType.deskRequest),
        _waitingListRepo = WaitingListRepo() {
    Stream<bool> onStartBroadcast = input.onStart.asBroadcastStream();

    Stream<UIModel<List<Desk>>> onStart = onStartBroadcast.flatMap((_) {
      return deskListStream();
    });

    Stream<UIModel<List<Desk>>> onWaitingListStart =
        onStartBroadcast.flatMap((_) {
      return subscribedDeskListStream();
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

    Stream<UIModel<List<Desk>>> onSubscribe =
        input.onSubscribe.flatMap((waitingPerson) {
      return _waitingListRepo
          .addWaitingPerson(waitingPerson)
          .flatMap((_) => subscribedDeskListStream())
          .onErrorReturnWith((error, _) => UIModel.error(error))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<List<Desk>>> onUnsubscribe =
        input.onUnsubscribe.flatMap((id) {
      return _waitingListRepo
          .removeWaitingPerson(id)
          .flatMap((_) => subscribedDeskListStream())
          .onErrorReturnWith((error, _) => UIModel.error(error))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<List<Desk>>> subscribedDeskListStreamMerge = MergeStream([
      onSubscribe,
      onUnsubscribe,
      onWaitingListStart,
    ]);

    output = Output(
      deskListStreamMerge,
      subscribedDeskListStreamMerge,
    );
  }
}

class Input {
  final Subject<bool> onStart;
  final Subject<DeskRequest> onDeskRequest;
  final Subject<WaitingPerson> onSubscribe;
  final Subject<int> onUnsubscribe;

  Input(
    this.onStart,
    this.onDeskRequest,
    this.onSubscribe,
    this.onUnsubscribe,
  );
}

class Output<T> {
  final Stream<UIModel<List<Desk>>> onStart;
  final Stream<UIModel<List<Desk>>> subscribedDeskList;

  Output(
    this.onStart,
    this.subscribedDeskList,
  );
}
