import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/constant/list_const.dart';
import 'package:fiesta/constant/var_const.dart';
import 'package:fiesta/helper/firebase_notification.dart';
import 'package:fiesta/repository/get_data_repository.dart';
import 'package:fiesta/utils/emuns.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_data.dart';
import '/constant/img_const.dart';
import '../../routing/routes.dart';
import '../../utils/show.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<void> initNotification() async {
    /// from -- void main
    FireBaseNotification().configureSelectNotificationSubject();
    await FireBaseNotification().setUpLocalNotification();

    /// from -- splash screen
    await FireBaseNotification().firebaseCloudMessagingLSetup();

    /// from -- dash board screen
    await FireBaseNotification().localNotificationRequestPermissions();

    FireBaseNotification().configureDidReceiveLocalNotificationSubject();
  }

  @override
  void initState() {
    initNotification();
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("userId") != null) {
        VarConst.currentUser = prefs.getString("userId");
      }
    }).then((value) async {
      await GetDataRepository().getAdminCredentials();
      await GetDataRepository().getProductsData();
      GetDataRepository().getBestSeller();
      if (VarConst.currentUser != null) {
        if (VarConst.adminData.adminId == VarConst.currentUser) {
          log("Welcome Admin...");
          showOffAll(Routes.adminHome);
        } else {
          log("Welcome User...");
          await GetDataRepository().getCurrentUserDetails();
          await FirebaseFirestore.instance.collection("users").doc(VarConst.currentUser).get().then((value) {
            ListConst.currentUser = userDataFromJson(jsonEncode(value.data()));
          });
          if (ListConst.currentUser.userType == UserType.user.name) {
            showOffAll(Routes.userHome);
          } else {
            showOffAll(Routes.resellerScreen);
          }
        }
      } else {
        showOffAll(Routes.intro1);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          ImgConst.splash,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
