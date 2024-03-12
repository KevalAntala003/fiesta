import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/constant/list_const.dart';
import 'package:fiesta/custom_widget/custom_button.dart';
import 'package:fiesta/custom_widget/custom_field.dart';
import 'package:fiesta/utils/show.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../constant/color_const.dart';
import '../../../constant/var_const.dart';
import '../../../custom_widget/custom_back.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../models/cart_item.dart';
import '../../../models/order_data.dart';
import '../../../repository/get_data_repository.dart';
import '../../../routing/routes.dart';

class ConfirmAddressUser extends StatefulWidget {
  const ConfirmAddressUser({super.key});

  @override
  State<ConfirmAddressUser> createState() => _ConfirmAddressUserState();
}

class _ConfirmAddressUserState extends State<ConfirmAddressUser> {

  TextEditingController addressController = TextEditingController();
  OrderData orderData = Get.arguments[0];
  List<CartItem> cartItems = Get.arguments[1];
  int totalAmount = Get.arguments[2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildConfirmOrderButton(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(VarConst.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CustomSize(
              height: VarConst.sizeOnAppBar,
            ),
            buildAppbar(),
            const CustomSize(),
            buildAddressTile(),
            buildChangeAddressButton()
          ],
        ),
      ),
    );
  }

  Widget buildAppbar() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBack(),
        CustomText(text: "Confirm Address"),
        CustomSize(width: 50),
      ],
    );
  }

  Widget buildAddressTile() {
    return ListTile(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: ColorConst.hintColor, width: 0.2)),
      tileColor: ColorConst.white,
      title: const CustomText(
        text: "Address",
        size: 18,
        align: TextAlign.start,
      ),
      subtitle: CustomText(
        text: ListConst.currentUser.address!,
        size: 16,
        color: ColorConst.hintColor,
        align: TextAlign.start,
      ),
    );
  }

  Widget buildChangeAddressButton() {
    return TextButton(
        onPressed: () {
          Get.bottomSheet(
              backgroundColor: ColorConst.white,
              Padding(
                padding: const EdgeInsets.all(VarConst.padding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                        text: "New Address",
                        hintText: "25-B ,Avenue Colony",
                        controller: addressController),
                    const CustomSize(),
                    CustomButton(
                        onPressed: () async {
                          if(addressController.text != ""){
                            try {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(ListConst.currentUser.uId)
                                  .update({"address": addressController.text});
                              await GetDataRepository().getCurrentUserDetails();
                            } catch (e) {
                              Get.snackbar("Failed", e.toString());
                            }
                            addressController.clear();
                            Get.back();
                            setState(() {});
                          }else{
                            Fluttertoast.showToast(msg: "Add new address first");
                          }
                        },
                        buttonText: "Change Address")
                  ],
                ),
              ));
        },
        child: const CustomText(
          text: "Change Address",
          size: 14,
          color: ColorConst.buttonColor,
        ));
  }

  Widget buildConfirmOrderButton(){
    return CustomButton(onPressed: (){
      showOff(Routes.confirmOrderUser,argument: [orderData,cartItems,totalAmount]);
    }, buttonText: "Confirm Order");
  }
}
