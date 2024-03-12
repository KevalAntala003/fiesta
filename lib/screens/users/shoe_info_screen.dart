import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fiesta/constant/list_const.dart';
import 'package:fiesta/custom_widget/custom_back.dart';
import 'package:fiesta/custom_widget/custom_bag_button.dart';
import 'package:fiesta/custom_widget/custom_size.dart';
import 'package:fiesta/custom_widget/custom_text.dart';
import 'package:fiesta/models/shoe_data.dart';
import 'package:fiesta/repository/get_data_repository.dart';
import 'package:fiesta/utils/common_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../constant/color_const.dart';
import '../../constant/var_const.dart';
import '../../utils/show.dart';

class ShoeInfoScreen extends StatefulWidget {
  const ShoeInfoScreen({super.key});

  @override
  State<ShoeInfoScreen> createState() => _ShoeInfoScreenState();
}

class _ShoeInfoScreenState extends State<ShoeInfoScreen> {
  ShoeData shoeData = Get.arguments;
  String selectedShoesSize = '';
  int? selectedShoesSizeIndex;

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
        CustomText(text: "Foot Fiesta",color: ColorConst.textPrimaryColor,),
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
              color: ColorConst.textPrimaryColor,
              weight: true,
            ),
            CustomText(
              text: "${shoeData.category}",
              size: 16,
              color: ColorConst.textSecondaryColor,
              fontFamily: ForFontFamily.rale,
            ),
            const CustomSize(),
            CustomText(text: "$rupeesIcon${shoeData.price}",color: ColorConst.primaryColor, size: 24),
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
              text: "Shoes Size :",
              size: 16,
              color: ColorConst.textSecondaryColor,
              ls: 0.5,
            ),
            const CustomSize(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: List.generate(shoeData.shoesSize!.length, (index) {
                return InkWell(onTap: () {
                  selectedShoesSizeIndex = index;
                  selectedShoesSize = shoeData.shoesSize![index];
                  setState(() {});
                },
                  child: Container(
                    margin:  const EdgeInsets.symmetric(horizontal:3),
                    height: 33,
                    width: 33,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color:selectedShoesSizeIndex == index ? ColorConst.primaryColor : ColorConst.textSecondaryColor)
                    ),
                    child: CustomText(
                      text: shoeData.shoesSize![index],
                      weight: true,
                      size: 14,
                      color: selectedShoesSizeIndex == index ? ColorConst.primaryColor : ColorConst.textSecondaryColor,
                      fontFamily: ForFontFamily.rale,
                    ),
                  ),
                );
              }),),
            ),
            const CustomSize(),
            const CustomText(
              text: "Description :",
              size: 16,
              color: ColorConst.textSecondaryColor,
              ls: 0.5,
            ),
            const CustomSize(),
            Card(
              elevation: 5,
              color: ColorConst.cardBgColor,
              shadowColor: ColorConst.textSecondaryColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomText(
                  text: "${shoeData.des}",
                  size: 14,
                  ls: 0.5,
                  color: ColorConst.textSecondaryColor,
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
                    backgroundColor: ColorConst.primaryColor,
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
                backgroundColor: ColorConst.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
            onPressed: () => onAddToCart(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.bag,color: ColorConst.textPrimaryColor,),
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
    if(shoeData.isLive! && selectedShoesSize.isNotEmpty){
      VarConst.isLoading.value = true;
      try {
        // ListConst.currentUser.cart!.add(shoeData.id);
        ListConst.currentUser.cart!.add({
          'id':shoeData.id,
          'size':selectedShoesSize,
          'image': shoeData.imgUrl,
          'name':shoeData.name,
          'price':shoeData.price,
          'category':shoeData.category,
          'des':shoeData.des
        });
        // await GetDataRepository().setCurrentUserDetail();
        await GetDataRepository().setCurrentUserDetailNew();
        Get.back();
        // Fluttertoast.showToast(msg: "Item added to cart.");
        AppSnackBar.showErrorSnackBar(message: 'Item added to cart.', title: 'success');
        log("tried!!");
        VarConst.isLoading.value = false;
      } catch (e) {
        VarConst.isLoading.value = false;
        log(e.toString());
        log("catch!!");
        AppSnackBar.showErrorSnackBar(message: e.toString(), title: 'error');
        // Fluttertoast.showToast(msg: e.toString());
      }
    }else{
      AppSnackBar.showErrorSnackBar(message: 'This select a size!', title: 'error');
    }
  }
}
