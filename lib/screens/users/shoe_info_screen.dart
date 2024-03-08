import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fiesta/constant/list_const.dart';
import 'package:fiesta/custom_widget/custom_back.dart';
import 'package:fiesta/custom_widget/custom_bag_button.dart';
import 'package:fiesta/custom_widget/custom_size.dart';
import 'package:fiesta/custom_widget/custom_text.dart';
import 'package:fiesta/models/shoe_data.dart';
import 'package:fiesta/repository/get_data_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../constant/color_const.dart';
import '../../constant/var_const.dart';

class ShoeInfoScreen extends StatefulWidget {
  const ShoeInfoScreen({super.key});

  @override
  State<ShoeInfoScreen> createState() => _ShoeInfoScreenState();
}

class _ShoeInfoScreenState extends State<ShoeInfoScreen> {
  ShoeData shoeData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildFloatingButton(),
    );
  }

  Widget buildAppbar() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBack(),
        CustomText(text: "Foot Fiesta"),
        CustomSize(width: 50,)
      ],
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VarConst.padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSize(
              height: VarConst.sizeOnAppBar,
            ),
            buildAppbar(),
            const CustomSize(
              height: 20,
            ),
            CustomText(
              text: "${shoeData.name}",
              size: 26,
              align: TextAlign.start,
              fontFamily: ForFontFamily.rale,
              weight: true,
            ),
            CustomText(
              text: "${shoeData.category}",
              size: 16,
              color: ColorConst.grey,
              fontFamily: ForFontFamily.rale,
            ),
            const CustomSize(),
            CustomText(text: "\$${shoeData.price}", size: 24),
            SizedBox(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: shoeData.imgUrl!,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
            const CustomSize(),
            const CustomText(
              text: "Description :",
              size: 16,
              color: ColorConst.hintColor,
              ls: 0.5,
            ),
            const CustomSize(),
            Card(
              elevation: 5,
              color: ColorConst.backColor,
              shadowColor: ColorConst.grey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomText(
                  text: "${shoeData.des}",
                  size: 14,
                  ls: 0.5,
                  color: ColorConst.grey,
                  align: TextAlign.start,
                ),
              ),
            ),
            const CustomSize(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget buildFloatingButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(
        () => VarConst.isLoading.value
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: ColorConst.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                onPressed: () {
                  Get.snackbar("Processing", "Wait until process complete.");
                },
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ))
            : ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: ColorConst.buttonColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
            onPressed: () => onAddToCart(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.bag,color: ColorConst.white,),
                const CustomSize(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const CustomText(
                    size: 16,
                    text: "Add To Cart",
                    color: Colors.white,
                  ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> onAddToCart() async {
    if(shoeData.isLive!){
      VarConst.isLoading.value = true;
      try {
        ListConst.currentUser.cart!.add(shoeData.id);
        await GetDataRepository().setCurrentUserDetail();
        Get.back();
        Fluttertoast.showToast(msg: "Item added to cart.");
        log("tried!!");
        VarConst.isLoading.value = false;
      } catch (e) {
        VarConst.isLoading.value = false;
        log(e.toString());
        log("catch!!");
        Fluttertoast.showToast(msg: e.toString());
      }
    }else{
      Fluttertoast.showToast(msg: "This item no longer available.");
    }
  }
}
