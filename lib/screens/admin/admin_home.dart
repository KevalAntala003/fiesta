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
  const AdminHome({super.key});

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
              title: const Text('Confirm Exit'),
              content: const Text('Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    // User tapped the cancel button, pop the dialog and return false
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Exit'),
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
            padding: const EdgeInsets.all(VarConst.padding),
            child: Column(
              children: [
                const CustomSize(
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
        const CustomText(
          text: "Orders",
          size: 28,
          weight: true,
        ),
        const CustomSize(
          width: 20,
        )
      ],
    );
  }

  Widget buildBody() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Orders available'));
        }
        return ListView(
          // physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            OrderData orderData = orderDataFromJson(jsonEncode(document.data()));
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: ColorConst.textSecondaryColor, width: 0.2)),
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
                subtitle: Text('Amount: $rupeesIcon${orderData.totalAmount}',
                style: const TextStyle(color: ColorConst.textSecondaryColor),
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
          const CustomText(
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
            leading: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              show(Routes.allProductAdmin);
            },
            leading: const Icon(Icons.card_travel),
            title: const Text('Products'),
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              show(Routes.allUserAdmin);
            },
            leading: const Icon(Icons.account_circle_rounded),
            title: const Text("Users"),
          ),
          ListTile(
            onTap: () async {
              FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              // prefs.remove("userId");
              await prefs.clear();
              showOffAll(Routes.signIn);
            },
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
          ),
          const Spacer(),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: GestureDetector(
                  onTap: () {
                    sideMenuKey.currentState!.closeSideMenu();
                    show(Routes.termsScreen);
                  },
                  child: const Text('Terms of Service | Privacy Policy')),
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
