import 'package:flutter/material.dart';

import '../../constant/img_const.dart';
import '../../custom_widget/custom_button.dart';
import '../../routing/routes.dart';
import '../../utils/show.dart';

class Intro3 extends StatefulWidget {
  const Intro3({super.key});

  @override
  State<Intro3> createState() => _Intro3State();
}

class _Intro3State extends State<Intro3> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: buildBody(),
    ));
  }

  Widget buildBody(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImgConst.intro3),
              fit: BoxFit.fill
          )

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
                buttonColor: Colors.white,
                textColor: Colors.black,
                onPressed: (){show(Routes.signIn);}, buttonText: "Next"),
          ),
        ],
      ),
    );
  }
}
