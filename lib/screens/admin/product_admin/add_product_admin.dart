import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/repository/get_data_repository.dart';
import '../../../custom_widget/custom_number_field.dart';
import '/constant/img_const.dart';
import '/custom_widget/custom_field.dart';
import '/custom_widget/custom_text.dart';
import '/utils/show.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constant/color_const.dart';
import '../../../constant/var_const.dart';
import '../../../custom_widget/custom_back.dart';
import '../../../custom_widget/custom_button.dart';
import '../../../custom_widget/custom_size.dart';
import '../../../routing/routes.dart';

class AddProductAdmin extends StatefulWidget {
  const AddProductAdmin({super.key});

  @override
  State<AddProductAdmin> createState() => _AddProductAdminState();
}

class _AddProductAdminState extends State<AddProductAdmin> {
  ImagePicker picker = ImagePicker();
  File? image;
  RxString selectedCategory = "Men's Shoes".obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildFloatingButton(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(VarConst.padding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSize(
              height: VarConst.sizeOnAppBar,
            ),
            buildAppbar(),
            const CustomSize(
              height: 20,
            ),
            CustomTextFormField(
                text: "Name Of Product",
                controller: nameController,
                hintText: "xxxxxxxx"),
            const CustomSize(),
            CustomTextFormField(
                text: "Description",
                controller: desController,
                hintText: "cool shoes for men"),
            const CustomSize(),
            buildCategorySelection(),
            const CustomSize(),
            CustomNumberTextFormField(
              text: "Price",
              controller: priceController,
              hintText: "\$4000",
            ),
            const CustomSize(),
            image != null ? buildShowImage() : buildGetImage(),
            const CustomSize(
              height: 70,
            )
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
        CustomText(
          text: "Add Product",
          size: 20,
        ),
        CustomSize(
          width: 50,
        )
      ],
    );
  }

  Widget buildShowImage() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      width: double.infinity,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            image!,
            fit: BoxFit.fill,
          )),
    );
  }

  Widget buildGetImage() {
    return GestureDetector(
      onTap: () {
        getImage();
      },
      child: Container(
        height: Get.width / 3,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(14),
            color: ColorConst.white),
        child: Obx(
          () => VarConst.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImgConst.addImage,
                      scale: 15,
                    ),
                    const CustomText(text: "Add Image")
                  ],
                ),
        ),
      ),
    );
  }

  Widget buildCategorySelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomText(
          text: "Category",
          weight: true,
          size: 16,
          color: ColorConst.grey,
          fontFamily: ForFontFamily.rale,
        ),
        Obx(() => DropdownButton(
              underline: Container(
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
              dropdownColor: ColorConst.white,
              borderRadius: BorderRadius.circular(14),
              value: selectedCategory.value,
              items: List.generate(
                  VarConst.categories.length,
                  (index) => DropdownMenuItem(
                        value: VarConst.categories[index],
                        child: CustomText(
                          color: ColorConst.grey,
                          ls: 0.5,
                          text: VarConst.categories[index],
                        ),
                      )),
              onChanged: (value) {
                selectedCategory.value = value!;
              },
            )),
      ],
    );
  }

  Widget buildFloatingButton() {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => VarConst.isLoading.value
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: ColorConst.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                onPressed: () {
                  Get.snackbar("Wait", "Details checking is in process");
                },
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ))
            : CustomButton(
                onPressed: () async {
                  try {
                    VarConst.isLoading.value = true;
                    String imgUrl = await uploadDocument(image!);
                    await FirebaseFirestore.instance
                        .collection("products")
                        .doc(orderId)
                        .set({
                      "name": nameController.text,
                      "des": desController.text,
                      "id": orderId,
                      "imgUrl": imgUrl,
                      "isLive": true,
                      "price": int.parse(priceController.text),
                      "category": selectedCategory.value
                    });
                    VarConst.isLoading.value = false;
                    await GetDataRepository().getProductsData();
                    Get.back();
                  } catch (e) {
                    log(e.toString());
                    VarConst.isLoading.value = false;
                  }
                },
                buttonText: "Add Product"),
      ),
    );
  }

  Future getImage() async {
    VarConst.isLoading.value = true;
    XFile? pickedFile;
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    try {} catch (e) {
      log("$e");
    }

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        log("image picked $image");
      } else {
        log('No image selected.');
      }
    });
    VarConst.isLoading.value = false;
  }

  Future<String> uploadDocument(File file) async {
    String currentImgUrl = "Unknown";
    try {
      String fileName = "${DateTime.now().millisecondsSinceEpoch}";
      String ext = file.path.split('/').last.split('.').last;
      TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref()
          .child('productPhoto/$fileName.$ext')
          .putFile(file);
      log("test the url --->${await uploadTask.ref.getDownloadURL()}");
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      log(e.toString());
    }
    return currentImgUrl;
  }
}
