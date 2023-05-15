import 'package:mobile_app/models/base_model.dart';

class Room extends BaseModel {
  final int id;
  final int? width;
  final int? length;
  final String? details;

  Room({
    required this.id,
    this.width,
    this.length,
    this.details,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      width: json["width"],
      length: json["length"],
      details: json["details"],
    );
  }

  @override
  Room copyWith({
    int? id,
    int? width,
    int? height,
    int? length,
    String? details,
  }) {
    return Room(
      id: id ?? this.id,
      width: width ?? this.width,
      length: length ?? this.length,
      details: details ?? this.details,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "width": width,
      "length": length,
      "details": details,
    };
  }

  @override
  int getId() => id;

  @override
  List<String> getDisplayData() {
    return [
      "id: $id",
      "width: $width m",
      "length: $length m",
      "details: $details",
    ];
  }
}
