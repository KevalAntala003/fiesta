import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/models/order_data.dart';
import 'package:get/get.dart';
import '../constant/list_const.dart';
import '../constant/var_const.dart';
import '../models/admin_data.dart';
import '../models/shoe_data.dart';
import '../models/user_data.dart';

class GetDataRepository {
  Future<void> getAdminCredentials() async {
    await FirebaseFirestore.instance
        .collection("adminData")
        .doc("credentials")
        .get()
        .then((value) async {
      log("data1 ::::: ${adminDataFromJson(json.encode(value.data())).adminId}");
      VarConst.adminData = adminDataFromJson(json.encode(value.data()));
    });
  }

  /*Future<void> getUsersData() async {
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var doc in value.docs) {
        try {
          ListConst.users.add(userDataFromJson(json.encode(doc.data())));
          log(doc.data().toString());
        } catch (e) {
          log("error while parsing ::::: $e");
        }
      }
      log("data got");
    });
  }*/

  Future<void> onDeleteProduct(String id) async {
    await FirebaseFirestore.instance.collection("products").doc(id).update({"isLive":false});
  }

  Future<void> getProductsData() async {
    await FirebaseFirestore.instance.collection("products").get().then((value) {
      for (var doc in value.docs) {
        try {
          ListConst.shoes.add(shoeDataFromJson(json.encode(doc.data())));
          log(doc.data().toString());
        } catch (e) {
          log("error while parsing shoes ::::: $e");
        }
      }
      log("shoes data got");
    });
  }

  void getBestSeller(){
    for(int k = 0; k < ListConst.shoes.length; k++){
      if(ListConst.shoes[k].category == "BestSeller"){
        ListConst.bestSellerShoes.add(ListConst.shoes[k]);
      }
    }
  }

  Future<void> getCurrentUserDetails() async {
    log("current User >> ${VarConst.currentUser}");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(VarConst.currentUser)
        .get()
        .then((value) {
      ListConst.currentUser = userDataFromJson(jsonEncode(value.data()));
    });
  }

  Future<void> setCurrentUserDetail() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(VarConst.currentUser)
        .set(jsonDecode(userDataToJson(ListConst.currentUser)));
  }
}
