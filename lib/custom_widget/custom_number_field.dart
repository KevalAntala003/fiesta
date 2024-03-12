import 'package:fiesta/custom_widget/custom_size.dart';
import 'package:flutter/services.dart';

import '../constant/color_const.dart';
import '/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';

class CustomNumberTextFormField extends StatelessWidget {
   CustomNumberTextFormField(
      {super.key,
        required this.text,
        required this.controller,
        this.hintText,
        this.length,
        this.fieldColor});

  final TextEditingController controller;
  final String text;
  final String? hintText;
  final int? length;
  final Color? fieldColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: text,
          weight: true,
          size: 16,
          color: ColorConst.textSecondaryColor,
          fontFamily: ForFontFamily.rale,
        ),
         CustomSize(),
        TextFormField(
          textInputAction: TextInputAction.next,
          style:  TextStyle(fontWeight: FontWeight.bold,color: ColorConst.textPrimaryColor),
          controller: controller,
          maxLength: length,
          validator: (value) {
            if (value!.isEmpty) {
              return "Enter valid input!!";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor ?? ColorConst.cardBgColor,
            hintText: hintText ?? "",
            hintStyle:  TextStyle(
                color: ColorConst.textSecondaryColor, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
