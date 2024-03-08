import 'package:cached_network_image/cached_network_image.dart';
import 'package:fiesta/custom_widget/custom_back.dart';
import 'package:fiesta/custom_widget/custom_bag_button.dart';
import 'package:fiesta/custom_widget/custom_size.dart';
import 'package:fiesta/custom_widget/custom_text.dart';
import 'package:fiesta/models/shoe_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/color_const.dart';
import '../../../constant/var_const.dart';

class ShoeInfoScreenAdmin extends StatefulWidget {
  const ShoeInfoScreenAdmin({super.key});

  @override
  State<ShoeInfoScreenAdmin> createState() => _ShoeInfoScreenAdminState();
}

class _ShoeInfoScreenAdminState extends State<ShoeInfoScreenAdmin> {
  ShoeData shoeData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildAppbar() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBack(),
        CustomText(text: "Foot Fiesta"),
        CustomSize(width: 50,),
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
            )
          ],
        ),
      ),
    );
  }
}
