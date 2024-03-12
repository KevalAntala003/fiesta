import 'package:fiesta/constant/img_const.dart';
import 'package:fiesta/custom_widget/custom_button.dart';
import 'package:fiesta/utils/show.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routing/routes.dart';

class Intro1 extends StatefulWidget {
   Intro1({super.key});

  @override
  State<Intro1> createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildBody(),
    );
  }
  
  Widget buildBody(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration:  BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImgConst.intro1),
          fit: BoxFit.fill
        )

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:  EdgeInsets.all(16.0),
            child: CustomButton(
                buttonColor: Colors.white,
                textColor: Colors.black,
                onPressed: (){show(Routes.intro2);}, buttonText: "Get Started"),
          ),
        ],
      ),
    );
  }
}
