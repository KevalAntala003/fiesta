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
import 'package:get/get_state_manager/get_state_manager.dart';
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
  RxString searchTxt = "".obs;
  List<String> banners = [ImgConst.baner1, ImgConst.baner2, ImgConst.baner3, ImgConst.baner4, ImgConst.baner5];

  RxString selectedCategories = "All".obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> allShoesQuery(String selectedCategory) {
    if (selectedCategory == "All" || selectedCategory.isEmpty) {
      return FirebaseFirestore.instance.collection('products').snapshots();
    } else {
      return FirebaseFirestore.instance.collection('products').where("category", isEqualTo: selectedCategory).snapshots();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchShoesQuery({required String selectedCategory, required String searchData}) {
    if (selectedCategory == "All" || selectedCategory.isEmpty) {
      return FirebaseFirestore.instance
          .collection('products')
          .where('name',
              isGreaterThanOrEqualTo: searchData,
              isLessThan: searchData.substring(0, searchData.length - 1) + String.fromCharCode(searchData.codeUnitAt(searchData.length - 1) + 1))
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('products')
          .where("category", isEqualTo: selectedCategory)
          .where('name',
              isGreaterThanOrEqualTo: searchData,
              isLessThan: searchData.substring(0, searchData.length - 1) + String.fromCharCode(searchData.codeUnitAt(searchData.length - 1) + 1))
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      background: ColorConst.bottomSheetBgColor,
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
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
              ],
            ));
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 100),
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: buildAppbar()),
            ),
            body: buildBody(),
          ),
        ),
      ),
    );
  }

  Widget categoriesView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                selectedCategories("All");
              },
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: selectedCategories.value == "All" ? ColorConst.primaryColor : ColorConst.cardBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "All",
                    style: TextStyle(
                      color: selectedCategories.value == "All" ? ColorConst.white : ColorConst.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            ...List.generate(VarConst.categories.length, (index) {
              return GestureDetector(
                onTap: () {
                  selectedCategories(VarConst.categories[index]);
                },
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: selectedCategories.value == VarConst.categories[index] ? ColorConst.primaryColor : ColorConst.cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      VarConst.categories[index],
                      style: TextStyle(
                        color: selectedCategories.value == VarConst.categories[index] ? ColorConst.white : ColorConst.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSize(
            height: 20,
          ),
          buildSearchEngine(),
          const CustomSize(
            height: 20,
          ),
          categoriesView(),
          Obx(
            () => searchTxt.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // buildSearchedShoes(),
                      const CustomSize(),
                      buildUpperScroller(),
                      const CustomSize(),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: VarConst.padding),
                        child: CustomText(
                          text: "Best Seller :",
                          color: ColorConst.textPrimaryColor,
                          size: 18,
                        ),
                      ),
                      const CustomSize(),
                      buildBestSellerShoes(),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          const CustomSize(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: VarConst.padding),
            child: CustomText(
              text: "All Shoes :",
              color: ColorConst.textPrimaryColor,
              size: 18,
            ),
          ),
          buildAllShoes(),
          const CustomSize(
            height: 20,
          ),
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
                    color: ColorConst.textPrimaryColor,
                    fit: BoxFit.fill,
                  ))),
          const CustomText(
            text: "Explore",
            size: 28,
            color: ColorConst.textPrimaryColor,
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
        style: TextStyle(color: ColorConst.textPrimaryColor),
        decoration: const InputDecoration(
          hintText: "Looking For Shoes",
          hintStyle: TextStyle(color: ColorConst.textSecondaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide.none,
          ),
          fillColor: ColorConst.cardBgColor,
          filled: true,
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: ColorConst.textPrimaryColor,
          ),
        ),
        onChanged: (value) {
          searchTxt(value);
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
            return ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.asset(i));
          },
        );
      }).toList(),
    );
  }

  Widget buildBestSellerShoes() {
    return CarouselSlider(
      options: CarouselOptions(autoPlay: false, enlargeCenterPage: true, height: Get.height * 0.25),
      items: ListConst.bestSellerShoes.map((ShoeData i) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                show(Routes.shoeInfoScreen, argument: i);
              },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: ColorConst.cardBgColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: i.imgUrl!,
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
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
                              color: ColorConst.textPrimaryColor,
                              size: 20,
                            ),
                            CustomText(
                              text: i.category.toString(),
                              size: 14,
                              color: ColorConst.textSecondaryColor,
                            ),
                            const CustomSize(
                              height: 5,
                            ),
                            CustomText(
                              text: "$rupeesIcon ${i.price}",
                              size: 20,
                              color: ColorConst.primaryColor,
                            ),
                            const CustomSize(),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(i.shoesSize!.length, (index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    height: 25,
                                    width: 25,
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: ColorConst.primaryColor)),
                                    child: CustomText(
                                      text: i.shoesSize![index],
                                      weight: true,
                                      size: 10,
                                      color: ColorConst.primaryColor,
                                      fontFamily: ForFontFamily.rale,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const CustomSize(),
                            Text(
                              i.des.toString(),
                              textAlign: TextAlign.start,
                              style:
                                  const TextStyle(fontSize: 14, color: ColorConst.textSecondaryColor, overflow: TextOverflow.fade, fontFamily: "pop"),
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
      textColor: ColorConst.textPrimaryColor,
      iconColor: ColorConst.textPrimaryColor,

      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const CustomText(
            text: "Foot Fiesta",
            size: 32,
            overflow: TextOverflow.fade,
            weight: true,
            color: ColorConst.textPrimaryColor,
            fontFamily: ForFontFamily.rale,
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
            },
            leading: const Icon(Icons.home, color: ColorConst.textPrimaryColor),
            title: const Text('Home', style: TextStyle(color: ColorConst.textPrimaryColor)),
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              show(Routes.profileUser);
            },
            leading: const Icon(Icons.card_travel, color: ColorConst.textPrimaryColor),
            title: const Text('Profile', style: TextStyle(color: ColorConst.textPrimaryColor)),
          ),
          ListTile(
            onTap: () {
              sideMenuKey.currentState!.closeSideMenu();
              show(Routes.orderUser);
            },
            leading: const Icon(Icons.account_circle_rounded, color: ColorConst.textPrimaryColor),
            title: const Text("Orders", style: TextStyle(color: ColorConst.textPrimaryColor)),
          ),
          ListTile(
            onTap: () async {
              FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("userId");
              ListConst.currentUser = UserData(orderList: [], email: "Unknown", cart: [], address: "Unknown", name: "Unknown", uId: "Unknown");
              showOffAll(Routes.signIn);
            },
            leading: const Icon(Icons.logout, color: ColorConst.textPrimaryColor),
            title: const Text('Sign Out', style: TextStyle(color: ColorConst.textPrimaryColor)),
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
                  child: const Text('Terms of Service | Privacy Policy', style: TextStyle(color: ColorConst.textSecondaryColor))),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAllShoes() {
    return Obx(
      () => StreamBuilder(
          stream: searchTxt.isEmpty
              ? allShoesQuery(selectedCategories.value)
              : searchShoesQuery(selectedCategory: selectedCategories.value, searchData: searchTxt.value),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(child: CircularProgressIndicator());
            // }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text(
                'No Products available',
                style: TextStyle(color: ColorConst.textPrimaryColor),
              ));
            }
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: VarConst.padding),
                child: GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 250, crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    ShoeData shoe = shoeDataFromJson(jsonEncode(document.data()));
                    return buildShoeContainer(shoe: shoe);
                  }).toList(),
                ));
          }),
    );
  }

  Widget buildShoeContainer({required ShoeData shoe}) {
    return GestureDetector(
      onTap: () {
        show(Routes.shoeInfoScreen, argument: shoe);
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: ColorConst.cardBgColor),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: shoe.imgUrl!,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 8),
              CustomText(
                text: "${shoe.category}",
                color: ColorConst.primaryColor,
                weight: true,
                size: 16,
              ),
              const SizedBox(height: 5),
              CustomText(
                text: "${shoe.name}",
                size: 18,
                overflow: TextOverflow.ellipsis,
                fontFamily: ForFontFamily.rale,
                color: ColorConst.textPrimaryColor,
                weight: true,
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(shoe.shoesSize!.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 25,
                      width: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: ColorConst.primaryColor)),
                      child: CustomText(
                        text: shoe.shoesSize![index],
                        weight: true,
                        size: 10,
                        color: ColorConst.textPrimaryColor,
                        fontFamily: ForFontFamily.rale,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CustomText(
                    text: "$rupeesIcon${shoe.price}",
                    size: 18,
                    color: ColorConst.textPrimaryColor,
                    weight: true,
                  ),
                  const Spacer(),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(color: ColorConst.primaryColor, borderRadius: BorderRadius.circular(6)),
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
