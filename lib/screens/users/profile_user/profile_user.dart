import 'package:fiesta/constant/list_const.dart';
import 'package:fiesta/constant/var_const.dart';
import 'package:flutter/material.dart';

import '../../../constant/color_const.dart';
import '../../../custom_widget/custom_back.dart';
import '../../../custom_widget/custom_bag_button.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../custom_widget/custom_text.dart';

class ProfileUser extends StatefulWidget {
   ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
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
           CustomSize(),
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
        CustomText(text: "Profile"),
        CustomBagButton()
      ],
    );
  }

  Widget buildDataView(){
    return Column(
      children: [
        buildListTileView(title: "User Name :", subTitle: ListConst.currentUser.name!),
        buildListTileView(title: "Email :", subTitle: ListConst.currentUser.email!),
        buildListTileView(title: "User Id :", subTitle: ListConst.currentUser.uId!),
        buildListTileView(title: "Address :", subTitle: ListConst.currentUser.address!),
        buildListTileView(title: "No. of Order :", subTitle: ListConst.currentUser.orderList!.length.toString()),
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
