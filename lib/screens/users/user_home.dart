import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/constant/list_const.dart';
import 'package:fiesta/constant/var_const.dart';
import 'package:fiesta/custom_widget/custom_bag_button.dart';
import 'package:fiesta/custom_widget/custom_size.dart';
import 'package:fiesta/models/shoe_data.dart';
import 'package:fiesta/models/user_data.dart';
import 'package:fiesta/routing/routes.dart';
import 'package:fiesta/utils/show.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import '../../constant/color_const.dart';
import '../../constant/img_const.dart';
import '../../custom_widget/custom_text.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
  final TextEditingController searchController = TextEditingController();
  List<ShoeData> searchedShoes = <ShoeData>[];
  List<String> banners = [
    ImgConst.baner1,
    ImgConst.baner2,
    ImgConst.baner3,
    ImgConst.baner4,
    ImgConst.baner5
  ];

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      background: ColorConst.blue,
      key: sideMenuKey,
      menu: buildDrawer(),
      child: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            log("back function is hit");
            if (sideMenuKey.currentState!.isOpened) {
              sideMenuKey.currentState!.closeSideMenu();
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
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                  ),
                ],
              ));
            }
          },
          child: Scaffold(body: buildBody())),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSize(
            height: VarConst.sizeOnAppBar + 10,
          ),
          buildAppbar(),
          const CustomSize(
            height: 20,
          ),
          buildSearchEngine(),
          const CustomSize(),
          buildSearchedShoes(),
          const CustomSize(),
          buildUpperScroller(),
          const CustomSize(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: VarConst.padding),
            child: CustomText(
              text: "Best Seller :",
              color: ColorConst.black,
              size: 18,
            ),
          ),
          const CustomSize(),
          buildBestSellerShoes(),
          const CustomSize(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: VarConst.padding),
            child: CustomText(
              text: "All Shoes :",
              color: ColorConst.black,
              size: 18,
            ),
          ),
          buildAllShoes()
        ],
      ),
    );
  }

  Widget buildAppbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VarConst.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState!.closeSideMenu();
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
            text: "Explore",
            size: 28,
            weight: true,
          ),
          const CustomBagButton()
        ],
      ),
    );
  }

  Widget buildSearchEngine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VarConst.padding),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: "Looking For Shoes",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide.none,
          ),
          fillColor: ColorConst.white,
          filled: true,
          prefixIcon: Icon(CupertinoIcons.search),
        ),
        onChanged: (value) {
          searchedShoes.clear();
          ListConst.shoes.map((ShoeData e) {
            log("${e.category!.toLowerCase().trim()} || ${value.toLowerCase().trim()}");
            if (e.category!
                .toLowerCase()
                .trim()
                .contains(value.toLowerCase().trim())) {
              searchedShoes.add(e);
            }
          }).toList();
          log("searched >> $value && >>> ${searchedShoes.length}");
          setState(() {});
        },
      ),
    );
  }

  Widget buildUpperScroller() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.25,
      ),
      items: banners.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(14), child: Image.asset(i));
          },
        );
      }).toList(),
    );
  }

  Widget buildBestSellerShoes() {
    return CarouselSlider(
      options: CarouselOptions(
          autoPlay: false, enlargeCenterPage: true, height: Get.height * 0.25),
      items: ListConst.bestSellerShoes.map((ShoeData i) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                show(Routes.shoeInfoScreen, argument: i);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: ColorConst.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: i.imgUrl!,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "${i.name}",
                              overflow: TextOverflow.ellipsis,
                              size: 20,
                            ),
                            CustomText(
                              text: i.category.toString(),
                              size: 14,
                              color: ColorConst.hintColor,
                            ),
                            const CustomSize(
                              height: 5,
                            ),
                            CustomText(
                              text: "$rupeesIcon ${i.price}",
                              size: 20,
                              color: ColorConst.buttonColor,
                            ),
                            const CustomSize(),
                            Text(
                              i.des.toString(),
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: ColorConst.grey,
                                  overflow: TextOverflow.fade,
                                  fontFamily: "pop"),
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
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
            text: "Foot Fiesta",
            size: 32,
            overflow: TextOverflow.fade,
            weight: true,
            color: ColorConst.white,
            fontFamily: ForFontFamily.rale,
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
            },
            leading: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              show(Routes.profileUser);
            },
            leading: const Icon(Icons.card_travel),
            title: const Text('Profile'),
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              show(Routes.orderUser);
            },
            leading: const Icon(Icons.account_circle_rounded),
            title: const Text("Orders"),
          ),
          ListTile(
            onTap: () async {
              FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("userId");
              ListConst.currentUser = UserData(
                  orderList: [],
                  email: "Unknown",
                  cart: [],
                  address: "Unknown",
                  name: "Unknown",
                  uId: "Unknown");
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

  Widget buildSearchedShoes() {
    return searchController.text == ""
        ? const SizedBox()
        : searchedShoes.isEmpty
            ? const SizedBox()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: VarConst.padding),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 250,
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemCount: searchedShoes.length,
                    itemBuilder: (BuildContext context, index) {
                      return buildShoeContainer(shoe: searchedShoes[index]);
                    }),
              );
  }

  Widget buildAllShoes() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Products available'));
          }
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: VarConst.padding),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 250,
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  ShoeData shoe = shoeDataFromJson(jsonEncode(document.data()));
                  return buildShoeContainer(shoe: shoe);
                }).toList(),
              ));
        });
  }

  Widget buildShoeContainer({required ShoeData shoe}) {

    return GestureDetector(
      onTap: () {
        show(Routes.shoeInfoScreen, argument: shoe);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14), color: ColorConst.white),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: shoe.imgUrl!,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 8),
              CustomText(
                text: "${shoe.category}",
                color: Colors.blue,
                weight: true,
                size: 16,
              ),
              const SizedBox(height: 5),
              CustomText(
                text: "${shoe.name}",
                size: 18,
                overflow: TextOverflow.ellipsis,
                fontFamily: ForFontFamily.rale,
                weight: true,
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: List.generate(shoe.shoesSize!.length, (index) {
                  return Container(
                    margin:  const EdgeInsets.symmetric(horizontal:2),
                    height: 25,
                    width: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: ColorConst.buttonColor)
                    ),
                    child: CustomText(
                      text: shoe.shoesSize![index],
                      weight: true,
                      size: 10,
                      color: ColorConst.buttonColor,
                      fontFamily: ForFontFamily.rale,
                    ),
                  );
                }),),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CustomText(
                    text: "$rupeesIcon${shoe.price}",
                    size: 18,
                    weight: true,
                  ),
                  const Spacer(),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: ColorConst.buttonColor,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSignOut() async {
    await FirebaseAuth.instance.signOut();
    showOffAll(Routes.signIn);
  }
}
