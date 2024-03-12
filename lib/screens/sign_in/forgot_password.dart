import 'dart:developer';
import 'package:fiesta/custom_widget/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../constant/color_const.dart';
import '../../constant/var_const.dart';
import '../../custom_widget/custom_back.dart';
import '../../custom_widget/custom_field.dart';
import '../../custom_widget/custom_size.dart';
import '../../custom_widget/custom_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.bgColor,
      body: buildBody(),);
  }

  Widget buildBody(){
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
                CustomBack(isWhite: false,),
              ],
            ),
            const CustomSize(
              height: 8,
            ),
            const CustomText(
              text: "Forgot password",
              size: 32,
              weight: true,
            ),
            const CustomSize(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: CustomText(
                text: "Enter Your Email Account To Reset Your Password",
                size: 16,
                ls: 0.5,
                color: ColorConst.textSecondaryColor,
              ),
            ),
            const CustomSize(
              height: 30,
            ),
            CustomTextFormField(
                fieldColor: ColorConst.cardBgColor,
                text: "Email Address",
                hintText: "xyz@gmail.com",
                controller: emailController),
            CustomButton(onPressed: () => resetPassword(), buttonText: "Reset Password")
          ],
        ),
      ),
    );
  }

  Future resetPassword()async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      Get.back();
      Fluttertoast.showToast(msg: "Password Reset Mail Has Been Sent To Your Email.");
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
