import 'package:mobile_app/models/base_model.dart';
import 'package:intl/intl.dart';

class DeskRequest extends BaseModel {
  final int id;
  final int? userId;
  final int? deskId;
  final DateTime? startDate;
  final DateTime? endDate;
  final DeskStatus? deskStatus;

  DeskRequest({
    required this.id,
    this.userId,
    this.deskId,
    this.startDate,
    this.endDate,
    this.deskStatus,
  });

  factory DeskRequest.fromJson(Map<String, dynamic> json) {
    return DeskRequest(
      id: json["id"],
      userId: json["userId"],
      deskId: json["deskId"],
      startDate: DateTime.tryParse(json["startDate"] ?? ""),
      endDate: DateTime.tryParse(json["endDate"] ?? ""),
      deskStatus: DeskStatusExtension.fromString(json["status"]),
    );
  }

  @override
  DeskRequest copyWith({
    int? id,
    int? userId,
    int? deskId,
    DateTime? startDate,
    DateTime? endDate,
    DeskStatus? deskStatus,
  }) {
    return DeskRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deskId: deskId ?? this.deskId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      deskStatus: deskStatus ?? this.deskStatus,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "desk_id": deskId,
      "start_date":
          DateFormat("dd-MM-yyyy-hh:mm:ss").format(startDate ?? DateTime.now()),
      "end_date":
          DateFormat("dd-MM-yyyy-hh:mm:ss").format(endDate ?? DateTime.now()),
      "status": deskStatus?.stringValue.toUpperCase(),
    };
  }

  @override
  int getId() => id;

  @override
  List<String> getDisplayData() {
    return [
      "id: $id",
      "user_id: $userId",
      "desk_id: $deskId",
      "start_date: ${DateFormat("dd-MM-yyyy-hh:mm:ss").format(startDate ?? DateTime.now())}",
      "end_date: ${DateFormat("dd-MM-yyyy-hh:mm:ss").format(endDate ?? DateTime.now())}",
      "status: ${deskStatus?.stringValue}",
    ];
  }
}

enum DeskStatus {
  reserved,
  available,
  unknown,
}

extension DeskStatusExtension on DeskStatus {
  static DeskStatus? fromString(String? v) {
    if (v == "RESERVED") {
      return DeskStatus.reserved;
    }
    if (v == "AVAILABLE") {
      return DeskStatus.available;
    }
    return DeskStatus.unknown;
  }

  String get stringValue {
    switch (this) {
      case DeskStatus.reserved:
        return "reserved";
      case DeskStatus.available:
        return "available";
      case DeskStatus.unknown:
        return "unknown";
    }
  }
}
