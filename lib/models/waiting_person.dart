import 'package:mobile_app/models/base_model.dart';

class WaitingPerson extends BaseModel {
  final int userId;
  final int deskId;
  final bool deskAvailable;

  WaitingPerson({
    required this.userId,
    required this.deskId,
    this.deskAvailable = false,
  });

  factory WaitingPerson.fromJson(Map<String, dynamic> json) {
    return WaitingPerson(
        userId: json["userId"] ?? 0,
        deskId: json["deskId"] ?? 0,
        deskAvailable: json["deskAvailable"] ?? false);
  }

  @override
  WaitingPerson copyWith({
    int? userId,
    int? deskId,
    bool? deskAvailable,
  }) {
    return WaitingPerson(
      userId: userId ?? this.userId,
      deskId: deskId ?? this.deskId,
      deskAvailable: deskAvailable ?? this.deskAvailable,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "desk_id": deskId,
    };
  }

  @override
  int getId() => userId;

  @override
  List<String> getDisplayData() {
    return [
      "id: $userId",
      "desk id: $deskId",
      "desk available: $deskAvailable",
    ];
  }
}
