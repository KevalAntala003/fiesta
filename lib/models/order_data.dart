// To parse this JSON data, do
//
//     final orderData = orderDataFromJson(jsonString);

import 'dart:convert';

OrderData orderDataFromJson(String str) => OrderData.fromJson(json.decode(str));

String orderDataToJson(OrderData data) => json.encode(data.toJson());

class OrderData {
  final String? orderId;
  final String? customerId;
  final String? customerName;
  final List<Item>? items;
  final int? totalAmount;

  OrderData({
    this.orderId,
    this.customerId,
    this.customerName,
    this.items,
    this.totalAmount,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    orderId: json["orderId"],
    customerId: json["customerId"],
    customerName: json["customerName"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "customerId": customerId,
    "customerName": customerName,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "totalAmount": totalAmount,
  };
}

class Item {
  final int? productId;
  final int? qty;

  Item({
    this.productId,
    this.qty,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    productId: json["productId"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "qty": qty,
  };
}
