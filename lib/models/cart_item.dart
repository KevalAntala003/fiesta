// To parse this JSON data, do
//
//     final cartItem = cartItemFromJson(jsonString);

import 'dart:convert';

import 'package:fiesta/models/shoe_data.dart';

CartItem cartItemFromJson(String str) => CartItem.fromJson(json.decode(str));

String cartItemToJson(CartItem data) => json.encode(data.toJson());

class CartItem {
  final ShoeData? shoeData;
  int? qty;

  CartItem({
    this.shoeData,
    this.qty,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    shoeData: json["shoeData"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "shoeData": shoeData,
    "qty": qty,
  };
}
