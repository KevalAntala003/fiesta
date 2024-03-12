import 'package:flutter/cupertino.dart';

class CustomSize extends StatelessWidget {
   CustomSize({Key? key,this.height,this.width}) : super(key: key);
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 10,
      width: width ?? 10,
    );
  }
}
