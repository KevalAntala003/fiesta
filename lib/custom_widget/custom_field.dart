import 'package:fiesta/custom_widget/custom_size.dart';

import '../constant/color_const.dart';
import '/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
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
          color: ColorConst.grey,
          fontFamily: ForFontFamily.rale,
        ),
        const CustomSize(),
        TextFormField(
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontWeight: FontWeight.bold),
          controller: controller,
          maxLength: length,
          validator: (value) {
            if (value!.isEmpty) {
              return "Enter valid input!!";
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor ?? ColorConst.white,
            hintText: hintText ?? "",
            hintStyle: const TextStyle(
                color: ColorConst.grey, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
