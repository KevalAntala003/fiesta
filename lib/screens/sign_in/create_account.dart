import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/constant/var_const.dart';
import 'package:fiesta/custom_widget/custom_back.dart';
import 'package:fiesta/custom_widget/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/color_const.dart';
import '../../constant/list_const.dart';
import '../../custom_widget/custom_field.dart';
import '../../custom_widget/custom_size.dart';
import '../../custom_widget/custom_text.dart';
import '../../models/user_data.dart';
import '../../routing/routes.dart';
import '../../utils/show.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  RxBool isView = true.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(VarConst.padding),
        child: Column(
          children: [
            const CustomSize(
              height: VarConst.sizeOnAppBar,
            ),
            const Row(
              children: [
                CustomBack(
                  isWhite: false,
                ),
              ],
            ),
            const CustomSize(
              height: 8,
            ),
            const CustomText(
              text: "Register Account",
              size: 32,
              weight: true,
            ),
            const CustomSize(
              height: 5,
            ),
            const CustomText(
              text: "Fill Your Details to Continue",
              size: 16,
              color: ColorConst.grey,
            ),
            const CustomSize(
              height: 20,
            ),
            CustomTextFormField(
                fieldColor: ColorConst.backColor,
                text: "Your Name",
                hintText: "xxxxxxxx",
                controller: nameController),
            const CustomSize(
              height: 20,
            ),
            CustomTextFormField(
                fieldColor: ColorConst.backColor,
                text: "Your Address",
                hintText: "24-B, new stallion street",
                controller: addressController),
            const CustomSize(
              height: 20,
            ),
            CustomTextFormField(
                fieldColor: ColorConst.backColor,
                text: "Email Address",
                hintText: "xyz@gmail.com",
                controller: emailController),
            const CustomSize(
              height: 20,
            ),
            buildPasswordField(),
            buildSignUpButton(),
            buildHaveAccountButton()
          ],
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return Column(
      children: [
        const Row(
          children: [
            CustomText(
                text: "Password",
                color: ColorConst.grey,
                fontFamily: ForFontFamily.rale),
          ],
        ),
        const CustomSize(),
        Obx(
          () => TextFormField(
            textInputAction: TextInputAction.next,
            style: const TextStyle(fontWeight: FontWeight.bold),
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter valid input!!";
              }
              return null;
            },
            obscureText: isView.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorConst.backColor,
              suffixIcon: IconButton(
                onPressed: () {
                  isView.value = !isView.value;
                },
                icon: isView.value
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              hintText: ".......",
              hintStyle: const TextStyle(
                  color: ColorConst.grey, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none),
            ),
          ),
        )
      ],
    );
  }

  Widget buildHaveAccountButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: "Already Have Account?",
          size: 16,
          color: ColorConst.grey,
        ),
        TextButton(
          onPressed: () {
            show(Routes.signIn);
          },
          child: const CustomText(text: "Sign In"),
        )
      ],
    );
  }

  Widget buildSignUpButton() {
    return Obx(
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
              onPressed: () => onCreateAccount(), buttonText: "SignUp"),
    );
  }

  Future<void> onCreateAccount() async {
    try {
      VarConst.isLoading.value = true;
      VarConst.credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      log("User Log In Found With ${VarConst.credential!.user!.uid}");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(VarConst.credential!.user!.uid)
          .set({
        "name": nameController.text.trim(),
        "address": addressController.text.trim(),
        "uId": VarConst.credential!.user!.uid,
        "email": emailController.text,
        "orderList": [],
        "cart": []
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(VarConst.credential!.user!.uid)
          .get()
          .then((value) {
        ListConst.currentUser = userDataFromJson(jsonEncode(value.data()));
      });
      VarConst.isLoading.value = false;
      VarConst.currentUser = VarConst.credential!.user!.uid;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", VarConst.credential!.user!.uid);
      showOffAll(Routes.userHome);
    } on FirebaseAuthException catch (e) {
      VarConst.isLoading.value = false;
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      VarConst.isLoading.value = false;
      log(e.toString());
    }
  }
}
