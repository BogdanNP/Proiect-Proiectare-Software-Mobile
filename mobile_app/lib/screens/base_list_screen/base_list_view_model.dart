import 'package:flutter/cupertino.dart';
import 'package:mobile_app/models/base_model.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/repos/general_repo.dart';
import 'package:rxdart/rxdart.dart';

class BaseListViewModel<T extends BaseModel> {
  final ModelType type;
  final Input input;
  final GeneralRepo _generalRepo;
  late Output output;

  Stream<UIModel<List<BaseModel>>> objectListStream() => _generalRepo
      .getObjectList()
      .map((data) => UIModel.success(data))
      .onErrorReturnWith(
        (error, _) => UIModel.error(error),
      )
      .startWith(UIModel.loading())
      .asBroadcastStream();

  BaseListViewModel(this.input, this.type, {GeneralRepo? generalRepo})
      : _generalRepo = generalRepo ?? GeneralRepo(type) {
    Stream<UIModel<List<BaseModel>>> onStart = input.onStart.flatMap((_) {
      return objectListStream();
    });

    Stream<UIModel<List<BaseModel>>> onSave = input.onSave.flatMap((object) {
      return _generalRepo
          .saveObject(object)
          .flatMap((_) => objectListStream())
          .onErrorReturnWith((error, _) => UIModel.error(error))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<List<BaseModel>>> onUpdate =
        input.onUpdate.flatMap((object) {
      return _generalRepo
          .updateObject(object)
          .flatMap((_) => objectListStream())
          .onErrorReturnWith((error, _) => UIModel.error(error))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<List<BaseModel>>> onDelete =
        input.onDelete.flatMap((object) {
      return _generalRepo
          .deleteObject(object.getId())
          .flatMap((_) {
            debugPrint("Delete Response: $_");
            return objectListStream();
          })
          .onErrorReturnWith((error, _) => UIModel.error(error))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<List<BaseModel>>> deskListStreamMerge = MergeStream([
      onStart,
      onSave,
      onUpdate,
      onDelete,
    ]);

    output = Output(deskListStreamMerge);
  }
}

class Input<T extends BaseModel> {
  final Subject<bool> onStart;
  final Subject<BaseModel> onSave;
  final Subject<BaseModel> onUpdate;
  final Subject<BaseModel> onDelete;

  Input(
    this.onStart,
    this.onSave,
    this.onUpdate,
    this.onDelete,
  );
}

class Output<T extends BaseModel> {
  final Stream<UIModel<List<BaseModel>>> onStart;

  Output(this.onStart);
}
