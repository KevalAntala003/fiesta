import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/constant/var_const.dart';
import 'package:fiesta/custom_widget/custom_size.dart';
import 'package:fiesta/models/user_data.dart';
import 'package:fiesta/routing/routes.dart';
import 'package:fiesta/utils/show.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import '../../constant/color_const.dart';
import '../../constant/img_const.dart';
import '../../custom_widget/custom_text.dart';
import '../../models/order_data.dart';

class AdminHome extends StatefulWidget {
  AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      background: ColorConst.primaryColor,
      key: sideMenuKey,
      menu: buildDrawer(),
      onChange: (val) {
        setState(() {});
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          log("back function is hit");
          if (sideMenuKey.currentState!.isOpened) {
            sideMenuKey.currentState!.closeSideMenu();
            setState(() {});
            log("drawer close with back");
          } else {
            log("Exit with back");
            Get.dialog(AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    // User tapped the cancel button, pop the dialog and return false
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Exit'),
                  onPressed: () {
                    // User tapped the exit button, pop the dialog and return true
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
              ],
            ));
          }
        },
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(VarConst.padding),
            child: Column(
              children: [
                CustomSize(
                  height: VarConst.sizeOnAppBar,
                ),
                buildAppbar(),
                Expanded(child: buildBody())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () {
              if (sideMenuKey.currentState!.isOpened) {
                sideMenuKey.currentState!.closeSideMenu();
                setState(() {});
              } else {
                sideMenuKey.currentState!.openSideMenu();
              }
            },
            child: SizedBox(
                height: 20,
                width: 20,
                child: Image.asset(
                  ImgConst.menu,
                  fit: BoxFit.fill,
                ))),
        CustomText(
          text: "Orders",
          size: 28,
          weight: true,
        ),
        themeSwitch(),
      ],
    );
  }

  Widget buildBody() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No Orders available',style: TextStyle(color: ColorConst.textPrimaryColor),));
        }
        return ListView(
          // physics:  NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            OrderData orderData = orderDataFromJson(jsonEncode(document.data()));
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14), side: BorderSide(color: ColorConst.textSecondaryColor, width: 0.2)),
                tileColor: ColorConst.cardBgColor,
                onTap: () {
                  show(Routes.showOrderInfoAdmin, argument: [orderData, document.id]);
                },
                title: CustomText(
                  text: orderData.customerName!,
                  size: 18,
                  align: TextAlign.start,
                  ls: 0.5,
                ),
                subtitle: Text(
                  'Amount: $rupeesIcon${orderData.totalAmount}',
                  style: TextStyle(color: ColorConst.textSecondaryColor),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget buildDrawer() {
    return ListTileTheme(
      textColor: Colors.white,
      iconColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomText(
            text: "Admin",
            size: 32,
            weight: true,
            color: ColorConst.white,
            fontFamily: ForFontFamily.rale,
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              setState(() {});
            },
            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              show(Routes.allProductAdmin);
            },
            leading: Icon(Icons.card_travel),
            title: Text('Products'),
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              show(Routes.allUserAdmin);
            },
            leading: Icon(Icons.account_circle_rounded),
            title: Text("Users"),
          ),
          ListTile(
            onTap: () async {
              FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              // prefs.remove("userId");
              await prefs.clear();
              showOffAll(Routes.signIn);
            },
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
          ),
          Spacer(),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: GestureDetector(
                  onTap: () {
                    sideMenuKey.currentState!.closeSideMenu();
                    show(Routes.termsScreen);
                  },
                  child: Text('Terms of Service | Privacy Policy')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSignOut() async {
    await FirebaseAuth.instance.signOut();
    showOffAll(Routes.signIn);
  }
}
