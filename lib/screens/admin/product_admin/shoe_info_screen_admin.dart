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
import '../../../utils/show.dart';

class ShoeInfoScreenAdmin extends StatefulWidget {
   ShoeInfoScreenAdmin({super.key});

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
    return  Row(
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
      padding:  EdgeInsets.symmetric(horizontal: VarConst.padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             CustomSize(
              height: VarConst.sizeOnAppBar,
            ),
            buildAppbar(),
             CustomSize(
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
              color: ColorConst.textSecondaryColor,
              fontFamily: ForFontFamily.rale,
            ),
             CustomSize(),
            CustomText(text: "$rupeesIcon${shoeData.price}", size: 24),
            SizedBox(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: shoeData.imgUrl!,
                  placeholder: (context, url) =>  Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>  Icon(Icons.error),
                )),
             CustomSize(),
             CustomText(
              text: "Description :",
              size: 16,
              color: ColorConst.textSecondaryColor,
              ls: 0.5,
            ),
             CustomSize(),
            Card(
              elevation: 5,
              color: ColorConst.cardBgColor,
              shadowColor: ColorConst.textSecondaryColor,
              child: Padding(
                padding:  EdgeInsets.all(12.0),
                child: CustomText(
                  text: "${shoeData.des}",
                  size: 14,
                  ls: 0.5,
                  color: ColorConst.textSecondaryColor,
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
