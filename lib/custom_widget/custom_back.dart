import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/color_const.dart';
import '../constant/img_const.dart';

class CustomBack extends StatelessWidget {
  const CustomBack({super.key, this.isWhite = true});

  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: ColorConst.cardBgColor),
          child: const Center(
              child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: ColorConst.textPrimaryColor,
          ))),
    );
  }
}
