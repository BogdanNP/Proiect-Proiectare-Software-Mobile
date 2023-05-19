import 'package:mobile_app/app_values.dart';
import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/services/general_service.dart';

class DeskRequestRepo {
  final GeneralService _generalService;

  DeskRequestRepo() : _generalService = GeneralService();

  Stream<List<DeskRequest>> getDeskRequestList(int? roomId) {
    return _getDeskRequestList(roomId).asStream();
  }

  Future<List<DeskRequest>> _getDeskRequestList(int? userId) async {
    List<Map<String, dynamic>> jsonDataList =
        (await _generalService.getDataList(
            "${AppValues.deskRequestPath}${AppValues.userPath}?id=$userId"));
    return jsonDataList.map((e) => DeskRequest.fromJson(e)).toList();
  }
}
