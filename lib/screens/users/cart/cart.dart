import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/color_const.dart';
import '../../../constant/list_const.dart';
import '../../../constant/var_const.dart';
import '../../../custom_widget/custom_back.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../models/cart_item.dart';
import '../../../models/order_data.dart';
import '../../../models/shoe_data.dart';
import '../../../repository/get_data_repository.dart';
import '../../../routing/routes.dart';
import '../../../utils/show.dart';

class CartScreenUser extends StatefulWidget {
  const CartScreenUser({super.key});

  @override
  State<CartScreenUser> createState() => _CartScreenUserState();
}

class _CartScreenUserState extends State<CartScreenUser> {
  @override
  void initState() {
    getCartItems();
    super.initState();
  }

  List<CartItem> cartItems = [];
  RxInt totalAmount = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      floatingActionButton: buildFloatingButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          Obx(() => totalAmount.value == 0
              ? const SizedBox()
              : CustomText(
                  text: "Total Amount : \$${totalAmount.value}",
                  align: TextAlign.start,
                  color: ColorConst.hintColor,
                )),
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
          text: "Cart",
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
          : cartItems.isEmpty
              ? const Center(
                  child: CustomText(text: "Cart is Empty!!"),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(
                              color: ColorConst.hintColor, width: 0.2)),
                      tileColor: ColorConst.white,
                      onTap: () => show(Routes.shoeInfoScreenAdmin,
                          argument: cartItems[index].shoeData),
                      leading: CachedNetworkImage(
                        imageUrl: cartItems[index].shoeData!.imgUrl!,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: CustomText(
                        text: cartItems[index].shoeData!.name!,
                        size: 18,
                        align: TextAlign.start,
                        ls: 0.5,
                      ),
                      subtitle: Text('Qty : ${cartItems[index].qty}'),
                    );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return const CustomSize();
                  },
                  itemCount: cartItems.length),
    );
  }

  Widget buildFloatingButtons() {
    return cartItems.isEmpty ? const SizedBox() : Padding(
      padding: const EdgeInsets.all(VarConst.padding),
      child: Row(
        children: [
          Expanded(
              child: ElevatedButton(
            onPressed: () async {
              await onClearCart();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorConst.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
            child: const CustomText(
              text: "Clear Cart",
              color: ColorConst.white,
            ),
          )),
          const CustomSize(),
          Expanded(
              child: ElevatedButton(
                onPressed: () {
                  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
                  showOff(Routes.confirmAddressUser,argument: [OrderData(
                      customerId: VarConst.currentUser,
                      items: List.generate(
                          cartItems.length,
                              (index) => Item(
                              productId: cartItems[index].shoeData!.id,
                              qty: cartItems[index].qty)),
                      customerName: ListConst.currentUser.name,
                      orderId: orderId,
                      totalAmount: totalAmount.value),cartItems,totalAmount.value]);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child: const CustomText(
                        text: "Place Order", color: ColorConst.white)),
          ),
        ],
      ),
    );
  }

    void getTotalAmount() {
      for (int i = 0; i < cartItems.length; i++) {
        totalAmount.value = totalAmount.value +
            (cartItems[i].shoeData!.price! * cartItems[i].qty!);
      }
    }

  Future<void> getCartItems() async {
    VarConst.isLoading.value = true;
    try {
      for (int i = 0; i < ListConst.currentUser.cart!.length; i++) {
        if (cartItems.any((element) =>
            element.shoeData!.id == ListConst.currentUser.cart![i])) {
          for (int j = 0; j < cartItems.length; j++) {
            if (ListConst.currentUser.cart![i] == cartItems[j].shoeData!.id) {
              if (cartItems[j].qty != null) {
                cartItems[j].qty = cartItems[j].qty! + 1;
              }
            }
          }
        } else {
          await FirebaseFirestore.instance
              .collection("products")
              .doc(ListConst.currentUser.cart![i].toString())
              .get()
              .then((value) {
            cartItems.add(CartItem(
                shoeData: shoeDataFromJson(jsonEncode(value.data())), qty: 1));
          });
        }
      }
      getTotalAmount();
      VarConst.isLoading.value = false;
    } catch (e) {
      VarConst.isLoading.value = false;
      log(e.toString());
    }
    setState(() {});
  }

  Future<void> onClearCart() async {
    VarConst.isLoading.value = true;
    try {
      cartItems.clear();
      ListConst.currentUser.cart!.clear();
      await GetDataRepository().setCurrentUserDetail();
      VarConst.isLoading.value = false;
    } catch (e) {
      VarConst.isLoading.value = false;
      log(e.toString());
    }
    setState(() {});
  }
}