// To parse this JSON data, do
//
//     final shoeData = shoeDataFromJson(jsonString);

import 'dart:convert';

ShoeData shoeDataFromJson(String str) => ShoeData.fromJson(json.decode(str));

String shoeDataToJson(ShoeData data) => json.encode(data.toJson());

class ShoeData {
  final String? name;
  final String? des;
  final int? id;
  final String? imgUrl;
  final int? price;
  final bool? isLive;
  final String? category;
  final List? shoesSize;

  ShoeData({
    this.name,
    this.des,
    this.id,
    this.imgUrl,
    this.price,
    this.isLive,
    this.category,
    this.shoesSize,
  });

  factory ShoeData.fromJson(Map<String, dynamic> json) => ShoeData(
    name: json["name"],
    des: json["des"],
    id: json["id"],
    imgUrl: json["imgUrl"],
    price: json["price"],
    isLive: json["isLive"],
    category: json["category"],
    shoesSize: json["ShoesSize"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "des": des,
    "id": id,
    "imgUrl": imgUrl,
    "price": price,
    "isLive":isLive,
    "category": category,
    "ShoesSize": shoesSize,
  };
}
