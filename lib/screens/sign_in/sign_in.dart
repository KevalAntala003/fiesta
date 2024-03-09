import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/constant/list_const.dart';
import 'package:fiesta/custom_widget/custom_button.dart';
import 'package:fiesta/custom_widget/custom_field.dart';
import 'package:fiesta/custom_widget/custom_size.dart';
import 'package:fiesta/custom_widget/custom_text.dart';
import 'package:fiesta/models/user_data.dart';
import 'package:fiesta/repository/get_data_repository.dart';
import 'package:fiesta/utils/common_snack_bar.dart';
import 'package:fiesta/utils/emuns.dart';
import 'package:fiesta/utils/show.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/var_const.dart';
import '../../custom_widget/custom_back.dart';
import '../../routing/routes.dart';
import '/constant/color_const.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  RxBool isView = true.obs;
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
              text: "Hello Again!",
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
              height: 30,
            ),
            CustomTextFormField(fieldColor: ColorConst.backColor, text: "Email Address", hintText: "xyz@gmail.com", controller: emailController),
            const CustomSize(
              height: 30,
            ),
            buildPasswordField(),
            const CustomSize(),
            buildRecoveryButton(),
            const CustomSize(
              height: 30,
            ),
            buildSignInButton(),
            buildCreateAccountButton()
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
            CustomText(text: "Password", color: ColorConst.grey, fontFamily: ForFontFamily.rale),
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
                icon: isView.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
              ),
              hintText: ".......",
              hintStyle: const TextStyle(color: ColorConst.grey, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
        )
      ],
    );
  }

  Widget buildRecoveryButton() {
    return GestureDetector(
      onTap: () {
        show(Routes.forgotPassword);
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomText(
            text: "Recovery Password",
            size: 12,
            color: ColorConst.grey,
          ),
        ],
      ),
    );
  }

  Widget buildSignInButton() {
    return Obx(
      () => VarConst.isLoading.value
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: ColorConst.buttonColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              onPressed: () {
                Get.snackbar("Wait", "Details checking is in process");
              },
              child: const CircularProgressIndicator(
                color: Colors.white,
              ))
          : CustomButton(onPressed: () => onSignIn(), buttonText: "SignIn"),
    );
  }

  Widget buildCreateAccountButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: "New User?",
          size: 16,
          color: ColorConst.grey,
        ),
        TextButton(
          onPressed: () {
            show(Routes.createAccount);
          },
          child: const CustomText(text: "Create Account"),
        )
      ],
    );
  }

  Future<void> onSignIn() async {
    try {
      final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim());

      if (!emailValid) {
        AppSnackBar.showErrorSnackBar(
          message: "please enter valid email address.",
          title: "error",
        );
      } else if (passwordController.text.trim().isEmpty) {
        AppSnackBar.showErrorSnackBar(
          message: "please enter password.",
          title: "error",
        );
      } else if (passwordController.text.length < 6) {
        AppSnackBar.showErrorSnackBar(
          message: "Password length must be 6 character",
          title: "error",
        );
      } else {
        VarConst.isLoading.value = true;
        VarConst.credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
        VarConst.isLoading.value = false;
        VarConst.currentUser = VarConst.credential!.user!.uid;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userId", VarConst.credential!.user!.uid);
        if (VarConst.credential!.user!.uid == VarConst.adminData.adminId) {
          showOffAll(Routes.adminHome);
        } else {
          await FirebaseFirestore.instance.collection("users").doc(VarConst.currentUser).get().then((value) {
            ListConst.currentUser = userDataFromJson(jsonEncode(value.data()));
          });
          if (ListConst.currentUser.userType == UserType.user.name) {
            showOffAll(Routes.userHome);
          } else {
            showOffAll(Routes.resellerScreen);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      VarConst.isLoading.value = false;
      AppSnackBar.showErrorSnackBar(
        message: e.message ?? "",
        title: "error",
      );
    }
  }
}
