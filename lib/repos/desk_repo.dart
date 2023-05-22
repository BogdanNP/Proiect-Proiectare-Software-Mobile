import 'package:mobile_app/app_values.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/services/general_service.dart';

class DeskRepo {
  final GeneralService _generalService;

  DeskRepo() : _generalService = GeneralService();

  Stream<List<Desk>> getDeskList(int? roomId) {
    return _getDeskList(roomId).asStream();
  }

  Future<List<Desk>> _getDeskList(int? roomId) async {
    List<Map<String, dynamic>> jsonDataList = roomId == null
        ? (await _generalService
            .getDataList("${AppValues.deskPath}${AppValues.listPath}"))
        : (await _generalService.getDataList(
            "${AppValues.deskPath}${AppValues.roomPath}?id=$roomId"));
    return jsonDataList.map((e) => Desk.fromJson(e)).toList();
  }
}
