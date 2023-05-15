import 'package:mobile_app/app_values.dart';
import 'package:mobile_app/models/base_model.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/services/general_service.dart';

class GeneralRepo<T extends BaseModel> {
  final GeneralService _generalService;
  ModelType type;
  GeneralRepo(this.type) : _generalService = GeneralService();

  String get path => ModelMapper.getPath(type);

  Stream<List<BaseModel>> getObjectList() {
    return _getObjectList().asStream();
  }

  Stream<BaseModel> saveObject(BaseModel object) {
    return _saveObject(object).asStream();
  }

  Stream<BaseModel> updateObject(BaseModel object) {
    return _updateObject(object).asStream();
  }

  Stream<bool> deleteObject(int id) {
    return _deleteObject(id).asStream();
  }

  Future<List<BaseModel>> _getObjectList() async {
    List<Map<String, dynamic>> jsonDataList =
        (await _generalService.getDataList("$path${AppValues.listPath}"));
    return jsonDataList.map((jsonData) {
      return ModelMapper.mapTo(jsonData, type);
    }).toList();
  }

  Future<BaseModel> _saveObject(BaseModel object) async {
    Map<String, dynamic> jsonData = (await _generalService.uploadData(
      "$path${AppValues.addPath}",
      object.toJson(),
    ));
    return ModelMapper.mapTo(jsonData, type);
  }

  Future<BaseModel> _updateObject(BaseModel object) async {
    Map<String, dynamic> jsonData = (await _generalService.updateData(
      "$path${AppValues.updatePath}",
      object.toJson(),
    ));
    return ModelMapper.mapTo(jsonData, type);
  }

  Future<bool> _deleteObject(int id) async {
    Map<String, dynamic> jsonData = (await _generalService.deleteData(
      "$path${AppValues.deletePath}",
      id,
    ));
    return jsonData["message"] == "Deleted.";
  }
}
