import 'package:mobile_app/app_values.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/waiting_person.dart';
import 'package:mobile_app/services/general_service.dart';

class WaitingListRepo {
  final GeneralService _generalService;

  WaitingListRepo() : _generalService = GeneralService();

  Stream<bool> addWaitingPerson(WaitingPerson waitingPerson) {
    return _addWaitingPerson(waitingPerson).asStream();
  }

  Stream<bool> removeWaitingPerson(int id) {
    return _removeWaitingPerson(id).asStream();
  }

  Stream<List<Desk>> getDeskList(int? userId) {
    return _getDeskList(userId).asStream();
  }

  Stream<Desk> checkDesk(int? deskId) {
    return _checkDesk(deskId).asStream();
  }

  Future<bool> _addWaitingPerson(WaitingPerson waitingPerson) async {
    Map<String, dynamic> jsonData = (await _generalService.uploadData(
      "${AppValues.waitingListPath}${AppValues.addPath}",
      waitingPerson.toJson(),
    ));
    return true;
  }

  Future<bool> _removeWaitingPerson(int userId) async {
    Map<String, dynamic> jsonData = (await _generalService.deleteData(
      "${AppValues.waitingListPath}${AppValues.deletePath}",
      userId,
    ));
    return true;
  }

  Future<List<Desk>> _getDeskList(int? userId) async {
    List<Map<String, dynamic>> jsonDataList =
        (await _generalService.getDataList(
            "${AppValues.waitingListPath}${AppValues.userPath}?id=$userId"));
    return jsonDataList.map((e) => Desk.fromJson(e)).toList();
  }

  Future<Desk> _checkDesk(int? deskId) async {
    Map<String, dynamic> jsonData = await _generalService.getData(
        "${AppValues.waitingListPath}${AppValues.deskPath}?id=$deskId");
    return Desk.fromJson(jsonData);
  }
}
