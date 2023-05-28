import 'package:mobile_app/models/base_model.dart';

class Desk extends BaseModel {
  final int id;
  final int? width;
  final int? height;
  final int? length;
  final double? tariff;
  final TariffType? tariffType;
  final int? roomId;
  final DeskStatus? deskStatus;

  Desk({
    required this.id,
    this.width,
    this.height,
    this.length,
    this.tariff,
    this.tariffType,
    this.roomId,
    this.deskStatus,
  });
  // : super(id: id);

  factory Desk.fromJson(Map<String, dynamic> json) {
    return Desk(
      id: json["id"],
      width: json["width"],
      height: json["height"],
      length: json["length"],
      tariff: json["tariff"],
      tariffType: TariffTypeExtension.fromString(json["tariffType"]),
      deskStatus: DeskStatusExtension.fromString(json["status"]),
      roomId: json["roomId"],
    );
  }

  @override
  Desk copyWith({
    int? id,
    int? width,
    int? height,
    int? length,
    double? tariff,
    TariffType? tariffType,
    int? roomId,
    DeskStatus? deskStatus,
  }) {
    return Desk(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      length: length ?? this.length,
      tariff: tariff ?? this.tariff,
      tariffType: tariffType ?? this.tariffType,
      roomId: roomId ?? this.roomId,
      deskStatus: deskStatus ?? this.deskStatus,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "width": width,
      "height": height,
      "length": length,
      "tariff": tariff,
      "tariff_type": tariffType?.stringValue.toUpperCase(),
      "status": deskStatus?.stringValue.toUpperCase(),
      "room_id": roomId,
    };
  }

  @override
  int getId() => id;

  @override
  List<String> getDisplayData() {
    return [
      "id: $id",
      "room id : $roomId",
      "tariff: \$$tariff/${tariffType?.stringValue}",
      "width: $width",
      "length: $length",
      "height: $height",
      "status : ${deskStatus?.stringValue}",
    ];
  }
}

enum TariffType {
  hour,
  day,
}

extension TariffTypeExtension on TariffType {
  static TariffType? fromString(String? v) {
    if (v == "HOUR") {
      return TariffType.hour;
    }
    if (v == "DAY") {
      return TariffType.hour;
    }
    return TariffType.hour;
  }

  String get stringValue {
    switch (this) {
      case TariffType.hour:
        return "hour";
      case TariffType.day:
        return "day";
    }
  }
}

enum DeskStatus {
  reserved,
  available,
  unknown,
}

extension DeskStatusExtension on DeskStatus {
  static DeskStatus fromString(String? v) {
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
