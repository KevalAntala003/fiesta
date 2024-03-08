import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/routing/page_routing.dart';
import 'constant/color_const.dart';
import 'routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: PageRouting().pageRouting,
      initialRoute: Routes.splash,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {TargetPlatform.android:CupertinoPageTransitionsBuilder()}),
        scaffoldBackgroundColor: ColorConst.bgColor,
          appBarTheme: const AppBarTheme(
          backgroundColor: ColorConst.bgColor
      )
      ),
    );
  }
}
