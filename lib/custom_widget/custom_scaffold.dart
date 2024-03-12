import 'package:flutter/material.dart';
import '/custom_widget/custom_text.dart';
import '../constant/color_const.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.appBarAction, this.appBarText, this.body, this.drawer, this.bgColor, this.appBarBgColor, this.floatingActionButton, this.floatingActionButtonLocation, this.onBack});

  final List<Widget>? appBarAction;
  final String? appBarText;
  final Widget? body;
  final Widget? drawer;
  final Color? bgColor;
  final Color? appBarBgColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor ?? ColorConst.bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBgColor ?? ColorConst.primaryColor,
        title: CustomText(text: appBarText ?? "Foot Fiesta",color: Colors.white,size: 18,),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        actions: appBarAction,
      ),
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
