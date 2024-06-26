import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/repository/get_data_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../constant/color_const.dart';
import '../../../constant/list_const.dart';
import '../../../models/shoe_data.dart';
import '../../../models/user_data.dart';
import '../../../utils/emuns.dart';
import '../../splash/splash.dart';
import '/custom_widget/custom_back.dart';
import '/utils/show.dart';
import 'package:flutter/material.dart';
import '../../../constant/var_const.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../routing/routes.dart';

class AllProductAdmin extends StatefulWidget {
   AllProductAdmin({super.key});

  @override
  State<AllProductAdmin> createState() => _AllProductAdminState();
}

class _AllProductAdminState extends State<AllProductAdmin> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      floatingActionButton: Obx(() => !isAdmin.value ? buildFloatingButton() : SizedBox() ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding:  EdgeInsets.all(VarConst.padding),
      child: SingleChildScrollView(
        child: Column(
          children: [
             CustomSize(
              height: VarConst.sizeOnAppBar,
            ),
            buildAppbar(),
            buildListView(),
            CustomSize(height: Get.height * 0.08,),
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
          text: "All Products",
          size: 20,
          weight: true,
        ),
        CustomSize(
          width: 50,
        )
      ],
    );
  }

  Widget buildListView() {
    return Obx(() => StreamBuilder(
      stream: !isAdmin.value ? FirebaseFirestore.instance
          .collection('products')
          .where("seller", isEqualTo: VarConst.currentUser!)
          .snapshots() :
      FirebaseFirestore.instance
          .collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return  Center(child: Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text('No Products available!',style: TextStyle(fontSize: 20,
                color: ColorConst.textPrimaryColor),),
          ));
        }
        return ListView(
          physics:  NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            ShoeData shoe = shoeDataFromJson(jsonEncode(document.data()));
            log("test the log --->${shoe.imgUrl}");
            if(shoe.isLive!){
              return Padding(
                padding:  EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side:  BorderSide(
                          color: ColorConst.textSecondaryColor, width: 0.2)),
                  tileColor: ColorConst.cardBgColor,
                  onTap: () => show(Routes.shoeInfoScreenAdmin, argument: shoe),
                  leading: CachedNetworkImage(
                    imageUrl: shoe.imgUrl!,
                    placeholder: (context, url) =>  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>  Icon(Icons.error),
                  ),
                  trailing: PopupMenuButton(
                    color: ColorConst.cardBgColor,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        onTap: () {
                          show(Routes.editProductAdmin, argument: shoe);
                        },
                        child:  CustomText(
                          text: "Edit",
                          size: 16,
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        onTap: () async {
                          await GetDataRepository()
                              .onDeleteProduct(shoe.id.toString());
                          log("deleting product ${shoe.id}");
                        },
                        child:  CustomText(
                          text: "Delete",
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  title: CustomText(
                    text: shoe.name!,
                    size: 18,
                    align: TextAlign.start,
                    ls: 0.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('Price: $rupeesIcon${shoe.price}'),
                ),
              );
            }else{
              return  SizedBox();
            }
          }).toList(),
        );
      },
    ));
  }

  Widget buildFloatingButton() {
    return FloatingActionButton(
        backgroundColor: ColorConst.primaryColor,
        child:  Icon(
          CupertinoIcons.add,
          color: ColorConst.cardBgColor,
        ),
        onPressed: () {
          show(Routes.addProductAdmin);
        });
  }
}
