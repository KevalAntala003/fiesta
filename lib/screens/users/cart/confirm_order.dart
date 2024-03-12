import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../constant/color_const.dart';
import '../../../constant/list_const.dart';
import '../../../constant/var_const.dart';
import '../../../custom_widget/custom_back.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../models/cart_item.dart';
import '../../../models/order_data.dart';
import '../../../repository/get_data_repository.dart';
import '../../../routing/routes.dart';
import '../../../utils/show.dart';

class ConfirmOrderUser extends StatefulWidget {
  const ConfirmOrderUser({super.key});

  @override
  State<ConfirmOrderUser> createState() => _ConfirmOrderUserState();
}

class _ConfirmOrderUserState extends State<ConfirmOrderUser> {
  OrderData orderData = Get.arguments[0];
  List<CartItem> cartItems = Get.arguments[1];
  int totalAmount = Get.arguments[2];
  RxBool isPlacingOrder = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildConfirm(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(VarConst.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSize(
            height: VarConst.sizeOnAppBar,
          ),
          buildAppbar(),
          const CustomSize(),
          CustomText(
            text: "Total Amount : $rupeesIcon$totalAmount",
            align: TextAlign.start,
            color: ColorConst.textSecondaryColor,
          ),
          buildListView()
        ],
      ),
    );
  }

  Widget buildAppbar() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBack(),
        CustomText(
          text: "Confirm Order",
          size: 28,
          weight: true,
        ),
        CustomSize(
          width: 50,
        )
      ],
    );
  }

  Widget buildListView() {
    return Obx(
      () => VarConst.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), side: const BorderSide(color: ColorConst.textSecondaryColor, width: 0.2)),
                  tileColor: ColorConst.cardBgColor,
                  onTap: () => show(Routes.shoeInfoScreenAdmin, argument: cartItems[index].shoeData),
                  leading: CachedNetworkImage(
                    imageUrl: cartItems[index].shoeData!.imgUrl!,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  title: CustomText(
                    text: cartItems[index].shoeData!.name!,
                    size: 18,
                    align: TextAlign.start,
                    ls: 0.5,
                  ),
                  subtitle: Text(
                    'Qty : ${cartItems[index].qty}',
                    style: TextStyle(color: ColorConst.textSecondaryColor),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, index) {
                return const CustomSize();
              },
              itemCount: cartItems.length),
    );
  }

  Widget buildConfirm() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: ColorConst.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            onPressed: isPlacingOrder.value
                ? null
                : () async {
                    await onPlaceOrder();
                  },
            child: isPlacingOrder.value
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const CustomText(
                      size: 16,
                      text: "Confirm Order",
                      color: Colors.white,
                    ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
                  )),
      ),
    );
  }

  Future<void> onPlaceOrder() async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    isPlacingOrder.value = true;
    try {
      await FirebaseFirestore.instance.collection("orders").doc(orderId).set(jsonDecode(orderDataToJson(orderData)));
      ListConst.currentUser.orderList!.add(orderData);
      ListConst.currentUser.cart!.clear();
      await GetDataRepository().setCurrentUserDetail();
      isPlacingOrder.value = false;
      showOff(Routes.orderPlaced);
      Fluttertoast.showToast(msg: "Order Placed");
    } catch (e) {
      isPlacingOrder.value = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
