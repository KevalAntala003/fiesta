import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/routing/page_routing.dart';
import 'constant/color_const.dart';
import 'routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var sf = await SharedPreferences.getInstance();
  ColorConst.themeColor(themeName: (sf.getString(themeSfKey)) ?? lightTheme);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: changeTheme,
        builder: (BuildContext context, value, Widget? child) {
        return GetMaterialApp(
          key: Key(value),
          debugShowCheckedModeBanner: false,
          getPages: PageRouting().pageRouting,
          initialRoute: Routes.splash,
          theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()}),
              scaffoldBackgroundColor: ColorConst.bgColor,
              appBarTheme: AppBarTheme(backgroundColor: ColorConst.bgColor)),
        );
      }
    );
  }
}
