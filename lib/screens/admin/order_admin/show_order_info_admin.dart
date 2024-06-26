import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/models/shoe_data.dart';
import 'package:fiesta/utils/show.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/color_const.dart';
import '../../../constant/var_const.dart';
import '../../../custom_widget/custom_back.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../models/order_data.dart';
import '../../../routing/routes.dart';

class ShowOrderInfoAdmin extends StatefulWidget {
   ShowOrderInfoAdmin({super.key});

  @override
  State<ShowOrderInfoAdmin> createState() => _ShowOrderInfoAdminState();
}

class _ShowOrderInfoAdminState extends State<ShowOrderInfoAdmin> {
  OrderData orderData = Get.arguments[0];
  String orderId = Get.arguments[1];
  RxBool isLoadingOrders = true.obs;
  List<ShoeData> shoeImages = [];

  @override
  void initState() {
    super.initState();
    log('orderData---->${orderData.toJson()}');
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding:  EdgeInsets.all(VarConst.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           CustomSize(
            height: VarConst.sizeOnAppBar,
          ),
          buildAppbar(),
           CustomSize(),
          CustomText(
            text: "Total Amount : $rupeesIcon${orderData.totalAmount}",
            align: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          buildOrderList()
        ],
      ),
    );
  }

  Widget buildAppbar() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBack(),
        CustomText(text: "Foot Fiesta"),
        CustomSize(
          width: 50,
        ),
      ],
    );
  }

  Widget buildOrderList() {
    return Obx(
      () => isLoadingOrders.value
          ?  Center(child: CircularProgressIndicator())
          : GridView.builder(
              physics:  NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemCount: orderData.items!.length,
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                  onTap: (){
                    show(Routes.shoeInfoScreenAdmin,argument: shoeImages[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: ColorConst.cardBgColor,
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: shoeImages[index].imgUrl!,
                              placeholder: (context, url) =>  Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                   Icon(Icons.error),
                            ),
                          ),
                          CustomText(text: shoeImages[index].name!,align: TextAlign.start,size: 18,),
                          CustomText(text: "Qty : ${orderData.items![index].qty}",align: TextAlign.start,size: 16,color: ColorConst.textSecondaryColor,)
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }

  Future<ShoeData> getProductData({required String productId}) async {
    ShoeData shoeData = ShoeData();
    await FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .get()
        .then((value) {
      shoeData = shoeDataFromJson(jsonEncode(value.data()));
    });
    return shoeData;
  }

  Future<void> getImages() async {
    try {
      for (int i = 0; i < orderData.items!.length; i++) {
        log('orderData.items![i].productId--->${orderData.items![i].productId}');
        await FirebaseFirestore.instance
            .collection("products")
            .doc(orderData.items![i].productId.toString())
            .get()
            .then((value) {
              log('value===>${value.data()}');
          shoeImages.add(shoeDataFromJson(jsonEncode(value.data())));
        });
        log('shoeImages--->${shoeImages.first.toJson()}');
      }
      isLoadingOrders.value = false;
    } catch (e) {
      isLoadingOrders.value = false;
      log(e.toString());
    }
  }
}
