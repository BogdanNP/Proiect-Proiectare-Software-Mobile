import 'package:mobile_app/models/base_model.dart';

class Order extends BaseModel {
  final int id;
  final int? userId;
  final int? deskId;
  final double? total;
  final OrderStatus? orderStatus;

  Order({
    required this.id,
    this.userId,
    this.deskId,
    this.total,
    this.orderStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      userId: json["userId"],
      deskId: json["deskId"],
      total: json["total"],
      orderStatus: OrderStatusExtension.fromString(json["status"]),
    );
  }

  @override
  Order copyWith({
    int? id,
    int? userId,
    int? deskId,
    double? total,
    OrderStatus? orderStatus,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deskId: deskId ?? this.deskId,
      total: total ?? this.total,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "desk_id": deskId,
      "total": total,
      "status": orderStatus?.stringValue.toUpperCase(),
    };
  }

  @override
  int getId() => id;

  @override
  List<String> getDisplayData() {
    return [
      "id: $id",
      "user id: $userId",
      "desk id: $deskId",
      "total: $total",
      "status: ${orderStatus?.stringValue}",
    ];
  }
}

enum OrderStatus {
  paid,
  newOrder,
  unknown,
}

extension OrderStatusExtension on OrderStatus {
  static OrderStatus? fromString(String? v) {
    if (v == "PAID") {
      return OrderStatus.paid;
    }
    if (v == "NEW") {
      return OrderStatus.newOrder;
    }
    return OrderStatus.unknown;
  }

  String get stringValue {
    switch (this) {
      case OrderStatus.paid:
        return "paid";
      case OrderStatus.newOrder:
        return "new order";
      case OrderStatus.unknown:
        return "unknown";
    }
  }
}
