import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void showErrorSnackBar({
    required String message,
    required String title,
  }) {
    Get.snackbar(
      "",
      "",
      snackPosition: SnackPosition.TOP,
      margin:  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: 14,
      snackStyle: SnackStyle.FLOATING,
      messageText: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              message,
              style:  TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
           SizedBox(
            width: 12,
          ),
          InkWell(
            onTap: Get.back,
            child:  Icon(Icons.close, color: Colors.white, size: 18),
          )
        ],
      ),
      titleText: Container(),
      backgroundColor: title.toLowerCase() == "error"
          ? Colors.redAccent
          : title.toLowerCase() == "success"
              ? Colors.green
              : Colors.black45,
      animationDuration:  Duration(milliseconds: 500),
      duration:  Duration(seconds: 2),
      colorText: Colors.white,

      // isDismissible: false,
      padding:  EdgeInsets.only(left: 12, right: 12, bottom: 20, top: 16),
    );
  }
}
