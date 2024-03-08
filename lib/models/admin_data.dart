// To parse this JSON data, do
//
//     final adminData = adminDataFromJson(jsonString);

import 'dart:convert';

AdminData adminDataFromJson(String str) => AdminData.fromJson(json.decode(str));

String adminDataToJson(AdminData data) => json.encode(data.toJson());

class AdminData {
  final String? adminId;
  final String? adminName;

  AdminData({
    this.adminId,
    this.adminName,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) => AdminData(
    adminId: json["adminId"],
    adminName: json["adminName"],
  );

  Map<String, dynamic> toJson() => {
    "adminId": adminId,
    "adminName": adminName,
  };
}
