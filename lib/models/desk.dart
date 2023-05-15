import 'package:mobile_app/models/base_model.dart';

class Desk extends BaseModel {
  final int id;
  final int? width;
  final int? height;
  final int? length;
  final double? tariff;
  final TariffType? tariffType;

  Desk({
    // required int id,
    required this.id,
    this.width,
    this.height,
    this.length,
    this.tariff,
    this.tariffType,
  });
  // : super(id: id);

  factory Desk.fromJson(Map<String, dynamic> json) {
    return Desk(
      id: json["id"],
      width: json["width"],
      height: json["height"],
      length: json["length"],
      tariff: json["tariff"],
      tariffType: TariffTypeExtension.fromString(json["tariff_type"]),
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
  }) {
    return Desk(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      length: length ?? this.length,
      tariff: tariff ?? this.tariff,
      tariffType: tariffType ?? this.tariffType,
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
    };
  }

  @override
  int getId() => id;

  @override
  List<String> getDisplayData() {
    return [
      "id: $id",
      "\$$tariff/${tariffType?.stringValue}",
      "W: $width",
      "L: $length",
      "H: $height"
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
