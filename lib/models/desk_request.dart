import 'package:mobile_app/models/base_model.dart';
import 'package:intl/intl.dart';

class DeskRequest extends BaseModel {
  final int id;
  final int? userId;
  final int? deskId;
  final DateTime? startDate;
  final DateTime? endDate;
  final DeskRequestStatus? deskStatus;

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
    DeskRequestStatus? deskStatus,
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

enum DeskRequestStatus {
  reserved,
  current,
  finished,
}

extension DeskStatusExtension on DeskRequestStatus {
  static DeskRequestStatus? fromString(String? v) {
    if (v == "RESERVED") {
      return DeskRequestStatus.reserved;
    }
    if (v == "CURRENT") {
      return DeskRequestStatus.current;
    }
    return DeskRequestStatus.finished;
  }

  String get stringValue {
    switch (this) {
      case DeskRequestStatus.reserved:
        return "reserved";
      case DeskRequestStatus.current:
        return "current";
      case DeskRequestStatus.finished:
        return "finished";
    }
  }
}
