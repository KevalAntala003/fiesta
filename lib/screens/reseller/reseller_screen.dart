import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../../constant/color_const.dart';
import '../../constant/img_const.dart';
import '../../constant/var_const.dart';
import '../../custom_widget/custom_size.dart';
import '../../custom_widget/custom_text.dart';
import '../../models/shoe_data.dart';
import '../../repository/get_data_repository.dart';
import '../../routing/routes.dart';
import '../../utils/show.dart';

class ResellerScreen extends StatefulWidget {
  ResellerScreen({super.key});

  @override
  State<ResellerScreen> createState() => _ResellerScreenState();
}

class _ResellerScreenState extends State<ResellerScreen> {
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
          floatingActionButton: buildFloatingButton(),
          body: Padding(
            padding: EdgeInsets.all(VarConst.padding),
            child: Column(
              children: [
                CustomSize(
                  height: VarConst.sizeOnAppBar,
                ),
                buildAppbar(),
                buildListView()
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
                  color: ColorConst.textSecondaryColor,
                ))),
        CustomText(
          text: "ReSeller",
          size: 28,
          weight: true,
        ),
        themeSwitch(),
      ],
    );
  }

  Widget buildDrawer() {
    return ListTileTheme(
      textColor: ColorConst.textPrimaryColor,
      iconColor: ColorConst.textPrimaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomText(
            text: "Seller",
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
            leading: Icon(
              Icons.home,
              color: ColorConst.white,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: ColorConst.white,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              show(Routes.allProductAdmin);
            },
            leading: Icon(
              Icons.card_travel,
              color: ColorConst.white,
            ),
            title: Text(
              'Products',
              style: TextStyle(
                color: ColorConst.white,
              ),
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     sideMenuKey.currentState!.closeSideMenu();
          //     show(Routes.allUserAdmin);
          //   },
          //   leading:  Icon(Icons.account_circle_rounded),
          //   title:  Text("Users"),
          // ),
          ListTile(
            onTap: () async {
              FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              showOffAll(Routes.signIn);
            },
            leading: Icon(
              Icons.logout,
              color: ColorConst.white,
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(
                color: ColorConst.white,
              ),
            ),
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
                  child: Text(
                    'Terms of Service | Privacy Policy',
                    style: TextStyle(
                      color: ColorConst.textSecondaryColor,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListView() {
    log('VarConst.currentUser!==>${VarConst.currentUser!}');
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').where("seller", isEqualTo: VarConst.currentUser!).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text(
              'No Products available!',
              style: TextStyle(fontSize: 20),
            ),
          ));
        }
        return ListView(
          // physics:  NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            ShoeData shoe = shoeDataFromJson(jsonEncode(document.data()));
            log("test the log --->${shoe.imgUrl}");
            if (shoe.isLive!) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), side: BorderSide(color: ColorConst.textSecondaryColor, width: 0.2)),
                  tileColor: ColorConst.cardBgColor,
                  onTap: () => show(Routes.shoeInfoScreenAdmin, argument: shoe),
                  leading: CachedNetworkImage(
                    imageUrl: shoe.imgUrl!,
                    placeholder: (context, url) => Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  trailing: PopupMenuButton(
                    color: ColorConst.cardBgColor,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        onTap: () {
                          show(Routes.editProductAdmin, argument: shoe);
                        },
                        child: CustomText(
                          text: "Edit",
                          size: 16,
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        onTap: () async {
                          await GetDataRepository().onDeleteProduct(shoe.id.toString());
                          log("deleting product ${shoe.id}");
                        },
                        child: CustomText(
                          text: "Delete",
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  title: CustomText(
                    text: shoe.name!,
                    size: 18,
                    align: TextAlign.start,
                    ls: 0.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Price: $rupeesIcon${shoe.price}',
                    style: TextStyle(color: ColorConst.textSecondaryColor),
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          }).toList(),
        );
      },
    );
  }

  Widget buildFloatingButton() {
    return InkWell(
      onTap: () {
        show(Routes.addProductAdmin);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6),
        width: 172,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: ColorConst.primaryColor, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              color: ColorConst.white,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            CustomText(
              text: 'Add Product',
              size: 18,
              align: TextAlign.start,
              ls: 0.5,
              color: ColorConst.white,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
