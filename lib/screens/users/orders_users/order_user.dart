import 'dart:convert';
import 'dart:developer';

import 'package:fiesta/constant/list_const.dart';
import 'package:fiesta/repository/get_data_repository.dart';
import 'package:fiesta/routing/routes.dart';
import 'package:fiesta/utils/show.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/color_const.dart';
import '../../../constant/var_const.dart';
import '../../../custom_widget/custom_back.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../models/order_data.dart';

class OrderUser extends StatefulWidget {
   OrderUser({super.key});

  @override
  State<OrderUser> createState() => _OrderUserState();
}

class _OrderUserState extends State<OrderUser> {
  List<OrderData> allOrders = [];

  @override
  void initState() {
    getAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.all(VarConst.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             CustomSize(
              height: VarConst.sizeOnAppBar,
            ),
            buildAppbar(),
            buildOrderDataTile()
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
        CustomText(text: "Orders"),
        CustomSize(width: 50),
      ],
    );
  }

  Widget buildOrderDataTile() {
    return Obx(
      () => VarConst.isLoading.value
          ?  Center(
              child: CircularProgressIndicator(),
            )
          : allOrders.isEmpty ?  CustomText(text: "No Orders") : ListView.separated(
        separatorBuilder: (BuildContext context, index){
          return  CustomSize();
        },
        shrinkWrap: true,
              physics:  NeverScrollableScrollPhysics(),
              itemCount: allOrders.length,
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side:  BorderSide(color: ColorConst.textSecondaryColor,width: 0.2)
                  ),
                  onTap: (){
                    show(Routes.showOrderInfoAdmin,argument: [allOrders[index],allOrders[index].orderId]);
                  },
                  tileColor: ColorConst.cardBgColor,
                  leading:  Icon(Icons.density_medium_rounded,size: 20),
                  title: CustomText(
                      text: "Amount : ${allOrders[index].totalAmount}",align: TextAlign.start,),
                  subtitle: CustomText(
                    text:
                        "No. of items : ${allOrders[index].items!.length}",
                    size: 16,
                    align: TextAlign.start,
                    color: ColorConst.textSecondaryColor,
                  ),
                );
              }),
    );
  }

  void getAllOrders() {
    VarConst.isLoading.value = true;
    for (int j = 0; j < ListConst.currentUser.orderList!.length; j++) {
      allOrders.add(orderDataFromJson(jsonEncode(ListConst.currentUser.orderList![j])));
    }
    VarConst.isLoading.value = false;
  }
}
