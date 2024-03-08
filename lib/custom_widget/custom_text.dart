import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  const CustomText(
      {super.key,
      this.color,
      this.align,
      this.size,
      required this.text,
      this.weight,
      this.ls,
      this.overflow,
      this.fontFamily});

  final String text;
  final bool? weight;
  final double? size;
  final Color? color;
  final TextAlign? align;
  final double? ls;
  final TextOverflow? overflow;
  final ForFontFamily? fontFamily;

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  String currentFamily = "";

  @override
  Widget build(BuildContext context) {
    if (widget.fontFamily != null) {
      if (widget.fontFamily == ForFontFamily.pop) {
        currentFamily = "Pop";
      } else if (widget.fontFamily == ForFontFamily.rale) {
        currentFamily = "Rale";
      }
    } else {
      currentFamily = "Pop";
    }
    return Text(
      widget.text,
      textAlign: widget.align ?? TextAlign.center,
      style: TextStyle(
          fontSize: widget.size ?? 17,
          color: widget.color ?? Colors.black,
          fontWeight: widget.weight ?? true ? FontWeight.bold : FontWeight.normal,
          overflow: widget.overflow ?? TextOverflow.fade,
          letterSpacing: widget.ls ?? 0,
          fontFamily: currentFamily),
    );
  }
}

enum ForFontFamily { pop, rale }
