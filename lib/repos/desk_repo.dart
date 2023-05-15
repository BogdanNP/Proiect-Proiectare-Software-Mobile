import 'package:mobile_app/app_values.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/services/general_service.dart';

class DeskRepo {
  final GeneralService _generalService;

  DeskRepo() : _generalService = GeneralService();

  Stream<List<Desk>> getDeskList() {
    return _getDeskList().asStream();
  }

  Stream<Desk> saveDesk(Desk desk) {
    return _saveDesk(desk).asStream();
  }

  Stream<Desk> updateDesk(Desk desk) {
    return _updateDesk(desk).asStream();
  }

  Stream<bool> deleteDesk(int id) async* {
    bool wasDeleted = await _deleteDesk(id);
    yield wasDeleted;
  }

  Future<List<Desk>> _getDeskList() async {
    List<Map<String, dynamic>> jsonDataList = (await _generalService
        .getDataList("${AppValues.deskPath}${AppValues.listPath}"));
    return jsonDataList.map((e) => Desk.fromJson(e)).toList();
  }

  Future<Desk> _saveDesk(Desk desk) async {
    Map<String, dynamic> jsonData = (await _generalService.uploadData(
      "${AppValues.deskPath}${AppValues.addPath}",
      desk.toJson(),
    ));
    return Desk.fromJson(jsonData);
  }

  Future<Desk> _updateDesk(Desk desk) async {
    Map<String, dynamic> jsonData = (await _generalService.updateData(
      "${AppValues.deskPath}${AppValues.updatePath}",
      desk.toJson(),
    ));
    return Desk.fromJson(jsonData);
  }

  Future<bool> _deleteDesk(int id) async {
    Map<String, dynamic> jsonData = (await _generalService.deleteData(
      "${AppValues.deskPath}${AppValues.deletePath}",
      id,
    ));
    return jsonData["message"] == "Deleted.";
  }
}
