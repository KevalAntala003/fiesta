import 'package:fiesta/constant/img_const.dart';
import 'package:fiesta/custom_widget/custom_button.dart';
import 'package:fiesta/custom_widget/custom_size.dart';
import 'package:fiesta/custom_widget/custom_text.dart';
import 'package:fiesta/utils/show.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constant/color_const.dart';
import '../../../routing/routes.dart';

class OrderPlaced extends StatefulWidget {
  const OrderPlaced({super.key});

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody(){
    return Column(
      children: [
        Lottie.asset(ImgConst.done,fit: BoxFit.fill),
        const CustomSize(),
        const CustomText(text: "Order Placed..",size: 20,weight: true,ls: 0.5,color: ColorConst.textSecondaryColor),
        const CustomSize(),
        const CustomText(text: "Your order delivered soon.",size: 16,color: ColorConst.textSecondaryColor,),
        const CustomSize(height: 20,),
        GestureDetector(
          onTap: (){
            showOffAll(Routes.userHome);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.blueGrey,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 8),
              child: CustomText(text: "Explore More",color: ColorConst.cardBgColor,fontFamily: ForFontFamily.rale,size: 18,ls: 1,),
            ),
          ),
        ),
      ],
    );
  }
}
