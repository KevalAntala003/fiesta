import 'package:fiesta/models/admin_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VarConst {
  static const double padding = 14;
  static const double sizeOnAppBar = 30;
  static UserCredential? credential;
  static String? currentUser;
  static RxBool isLoading = false.obs;
  static AdminData adminData =
      AdminData(adminId: "Unknown", adminName: "Unknown");
  static const categories = ["Kid's Shoes","Men's Shoes","WoMen's Shoes","BestSeller","Leather Shoes"];
}