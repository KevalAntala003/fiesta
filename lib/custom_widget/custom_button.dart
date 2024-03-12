import '../constant/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.weight,
      this.textSize,
      this.buttonColor, this.textColor});

  final VoidCallback onPressed;
  final String buttonText;
  final bool? weight;
  final double? textSize;
  final Color? buttonColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: buttonColor ?? ColorConst.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14))),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              size: textSize ?? 16,
              text: buttonText,
              weight: weight ?? true,
              color: textColor ?? Colors.white,
            ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
          )),
    );
  }
}
