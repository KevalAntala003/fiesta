import 'package:fiesta/utils/show.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/color_const.dart';
import '../routing/routes.dart';

class CustomBagButton extends StatelessWidget {
  const CustomBagButton({super.key,this.isWhite = true});
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {show(Routes.cartScreenUser);},
      child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isWhite ? Colors.white : ColorConst.backColor
          ),
          child: const Center(child: Icon(CupertinoIcons.bag,))),
    );
  }
}
