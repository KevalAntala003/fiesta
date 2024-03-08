// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  final String? name;
  final String? email;
  final String? address;
  final String? uId;
  final List<dynamic>? orderList;
  final List<dynamic>? cart;

  UserData({
    this.name,
    this.email,
    this.address,
    this.uId,
    this.orderList,
    this.cart,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    name: json["name"],
    email: json["email"],
    address: json["address"],
    uId: json["uId"],
    orderList: json["orderList"] == null ? [] : List<dynamic>.from(json["orderList"]!.map((x) => x)),
    cart: json["cart"] == null ? [] : List<dynamic>.from(json["cart"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "address": address,
    "uId": uId,
    "orderList": orderList == null ? [] : List<dynamic>.from(orderList!.map((x) => x)),
    "cart": cart == null ? [] : List<dynamic>.from(cart!.map((x) => x)),
  };
}
