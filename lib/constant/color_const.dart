import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<String> changeTheme = ValueNotifier<String>("");

String themeSfKey = "themeSfKey";
String darkTheme = "darkTheme";
String lightTheme = "lightTheme";

Widget themeSwitch() {
  return Container(
    decoration: BoxDecoration(color: ColorConst.cardBgColor, borderRadius: BorderRadius.circular(100)),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            ColorConst.themeColor(themeName: lightTheme);
          },
          child: Container(
            decoration: BoxDecoration(
              color: changeTheme.value == lightTheme ? ColorConstLight.primaryColor : ColorConst.cardBgColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(5),
            child: Icon(
              Icons.sunny,
              size: 20,
              color: changeTheme.value == lightTheme ? ColorConstLight.white : ColorConst.white,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          onTap: () {
            ColorConst.themeColor(themeName: darkTheme);
          },
          child: Container(
            decoration: BoxDecoration(
              color: changeTheme.value == darkTheme ? ColorConstLight.primaryColor : ColorConst.cardBgColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(5),
            child: Icon(
              Icons.dark_mode,
              size: 20,
              color: changeTheme.value == darkTheme ? ColorConstLight.white : ColorConst.black,
            ),
          ),
        ),
      ],
    ),
  );
}

class ColorConst {
  static Color bgColor = ColorConstLight.bgColor;
  static Color cardBgColor = ColorConstLight.cardBgColor;
  static Color bottomSheetBgColor = ColorConstLight.bottomSheetBgColor;
  static Color textPrimaryColor = ColorConstLight.textPrimaryColor;
  static Color textSecondaryColor = ColorConstLight.textSecondaryColor;
  static Color primaryColor = ColorConstLight.primaryColor;
  static Color white = ColorConstLight.white;
  static Color black = ColorConstLight.black;
  static Color red = ColorConstLight.red;

  static void themeColor({required String themeName}) async {
    var sf = await SharedPreferences.getInstance();
    await sf.setString(themeSfKey, themeName);

    if (themeName == darkTheme) {
      /// TODO : Dark Mode
      changeTheme.value = darkTheme;
      bgColor = ColorConstDark.bgColor;
      cardBgColor = ColorConstDark.cardBgColor;
      bottomSheetBgColor = ColorConstDark.bottomSheetBgColor;
      textPrimaryColor = ColorConstDark.textPrimaryColor;
      textSecondaryColor = ColorConstDark.textSecondaryColor;
      primaryColor = ColorConstDark.primaryColor;
      white = ColorConstDark.white;
      black = ColorConstDark.black;
      red = ColorConstDark.red;
    } else {
      /// TODO : Light Theme
      changeTheme.value = lightTheme;
      bgColor = ColorConstLight.bgColor;
      cardBgColor = ColorConstLight.cardBgColor;
      bottomSheetBgColor = ColorConstLight.bottomSheetBgColor;
      textPrimaryColor = ColorConstLight.textPrimaryColor;
      textSecondaryColor = ColorConstLight.textSecondaryColor;
      primaryColor = ColorConstLight.primaryColor;
      white = ColorConstLight.white;
      black = ColorConstLight.black;
      red = ColorConstLight.red;
    }
  }
}

class ColorConstDark {
  static Color bgColor = const Color(0xFF000000);
  static Color cardBgColor = const Color(0xff222222);
  static Color bottomSheetBgColor = const Color(0xff131313);
  static Color textPrimaryColor = const Color(0xffffffff);
  static Color textSecondaryColor = const Color(0xffdedede);
  static Color primaryColor = const Color(0xFF0D6EFD);
  static Color white = const Color(0xffffffff);
  static Color black = const Color(0xff000000);
  static Color red = const Color(0xffff5959);
}

class ColorConstLight {
  static Color bgColor = const Color(0xFFF7F7F9);
  static Color cardBgColor = const Color(0xFFFFFFFF);
  static Color bottomSheetBgColor = const Color(0xffe0e0e0);
  static Color textPrimaryColor = const Color(0xff000000);
  static Color textSecondaryColor = const Color(0xff232323);
  static Color primaryColor = const Color(0xFF0D6EFD);
  static Color white = const Color(0xffffffff);
  static Color black = const Color(0xff000000);
  static Color red = const Color(0xffff5959);
}

// class ColorConst{
//   static  Color bgColor = Color(0xFFF7F7F9);
//   static  Color backColor = Color(0xFFF7F7F9);
//   static  Color buttonColor = Color(0xFF0D6EFD);
//   static  Color hintColor = Color(0xFF6A6A6A);
//   static  Color white = Colors.white;
//   static  Color black = Colors.black;
//   static  Color blue = Color(0xFF0D6EFD);
//   static  Color grey = Color(0xFF707B81);
//   static  Color red = Color(0xFFFF3D3D);
// }
