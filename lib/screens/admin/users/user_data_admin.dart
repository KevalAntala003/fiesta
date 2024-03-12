import 'package:fiesta/constant/var_const.dart';
import 'package:fiesta/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/color_const.dart';
import '../../../custom_widget/custom_back.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../custom_widget/custom_text.dart';

class UserDataScreenAdmin extends StatefulWidget {
   UserDataScreenAdmin({super.key});

  @override
  State<UserDataScreenAdmin> createState() => _UserDataScreenAdminState();
}

class _UserDataScreenAdminState extends State<UserDataScreenAdmin> {
  UserData userData = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody(){
    return SingleChildScrollView(child: Padding(
      padding:  EdgeInsets.all(VarConst.padding),
      child: Column(
        children: [
           CustomSize(
            height: VarConst.sizeOnAppBar,
          ),
          buildAppbar(),
          buildDataView()
        ],
      ),
    ));
  }

  Widget buildAppbar() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBack(),
        CustomText(
          text: "User Detail",
          size: 20,
          weight: true,
        ),
        CustomSize(width: 50,)
      ],
    );
  }

  Widget buildDataView(){
    return Column(
      children: [
        buildListTileView(title: "User Name :", subTitle: userData.name!),
        buildListTileView(title: "Email :", subTitle: userData.email!),
        buildListTileView(title: "User Id :", subTitle: userData.uId!),
        buildListTileView(title: "Address :", subTitle: userData.address!),
        buildListTileView(title: "No. of Order :", subTitle: userData.orderList!.length.toString()),
      ],
    );
  }

  Widget buildListTileView({required String title,required String subTitle}){
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side:  BorderSide(color: ColorConst.textSecondaryColor,width: 0.2)
        ),
        tileColor: ColorConst.cardBgColor,
        title: CustomText(
          text: title,
          weight: true,
          align: TextAlign.start,
          size: 16,
        ),
        subtitle: CustomText(
          text: subTitle,
          size: 14,
          align: TextAlign.start,
          color: ColorConst.textSecondaryColor,
        ),
      ),
    );
  }
}

