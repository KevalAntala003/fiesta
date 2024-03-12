import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/custom_widget/custom_text.dart';
import 'package:fiesta/models/user_data.dart';
import 'package:fiesta/utils/show.dart';
import 'package:flutter/material.dart';
import '../../../constant/color_const.dart';
import '../../../constant/var_const.dart';
import '../../../custom_widget/custom_back.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../routing/routes.dart';

class AllUsersAdmin extends StatefulWidget {
   AllUsersAdmin({super.key});

  @override
  State<AllUsersAdmin> createState() => _AllUsersAdminState();
}

class _AllUsersAdminState extends State<AllUsersAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody(){
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.all(VarConst.padding),
        child: Column(
          children: [
             CustomSize(
              height: VarConst.sizeOnAppBar,
            ),
            buildAppbar(),
            buildListView(),
          ],
        ),
      ),
    );
  }

  Widget buildAppbar() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBack(),
        CustomText(
          text: "All Users",
          size: 20,
          weight: true,
        ),
        CustomSize(width: 50,)
      ],
    );
  }

  Widget buildListView(){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return  Center(child: Text('No Users available'));
        }
        return ListView(
          physics:  NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            UserData user = userDataFromJson(jsonEncode(document.data()));

            return Padding(
              padding:  EdgeInsets.symmetric(vertical: 4,horizontal: 8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side:  BorderSide(color: ColorConst.textSecondaryColor,width: 0.2)
                ),
                onTap: (){
                  show(Routes.userDataScreenAdmin,argument: user);
                },
                tileColor: ColorConst.cardBgColor,
                leading:  Icon(Icons.account_circle_rounded),
                title: CustomText(text: user.name!,size: 18,align: TextAlign.start,ls: 0.5,),
                subtitle: CustomText(text: 'Total Orders : ${user.orderList!.length}',overflow: TextOverflow.ellipsis,align: TextAlign.start,size: 16,color: ColorConst.textSecondaryColor,),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}