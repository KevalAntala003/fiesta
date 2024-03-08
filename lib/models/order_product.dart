// To parse this JSON data, do
//
//     final orderProduct = orderProductFromJson(jsonString);

import 'dart:convert';

OrderProduct orderProductFromJson(String str) => OrderProduct.fromJson(json.decode(str));

String orderProductToJson(OrderProduct data) => json.encode(data.toJson());

class OrderProduct {
  final String? productId;
  final String? qty;
  final double? price;

  OrderProduct({
    this.productId,
    this.qty,
    this.price,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
    productId: json["productId"],
    qty: json["qty"],
    price: json["price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "qty": qty,
    "price": price,
  };

  factory OrderProduct.fromMap(Map<String, dynamic> map) => OrderProduct(
    productId: map["productId"],
    qty: map["qty"],
    price: map["price"]?.toDouble(),
  );
}
