import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/constant/var_const.dart';
import 'package:fiesta/custom_widget/custom_back.dart';
import 'package:fiesta/custom_widget/custom_button.dart';
import 'package:fiesta/utils/common_snack_bar.dart';
import 'package:fiesta/utils/emuns.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
   CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  RxBool isView = true.obs;

  RxString selectedUserType = UserType.user.name.obs;
  List<String> userType = [
    UserType.user.name,
    UserType.admin.name,
    UserType.seller.name,
  ];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.bgColor,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.all(VarConst.padding),
        child: Column(
          children: [
             CustomSize(
              height: VarConst.sizeOnAppBar,
            ),
             Row(
              children: [
                CustomBack(
                  isWhite: false,
                ),
              ],
            ),
             CustomSize(
              height: 8,
            ),
             CustomText(
              text: "Register Account",
              size: 32,
              weight: true,
            ),
             CustomSize(
              height: 5,
            ),
             CustomText(
              text: "Fill Your Details to Continue",
              size: 16,
              color: ColorConst.textSecondaryColor,
            ),
             CustomSize(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding:  EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(color: ColorConst.cardBgColor, borderRadius: BorderRadius.circular(14)),
              child: Theme(
                data: Theme.of(context).copyWith(
                    buttonTheme: ButtonTheme.of(context).copyWith(
                  alignedDropdown: true, //If false (the default), then the dropdown's menu will be wider than its button.
                )),
                child: Obx(() => DropdownButton(
                      underline: Container(
                        decoration:  ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                      ),

                      dropdownColor: ColorConst.cardBgColor,
                      borderRadius: BorderRadius.circular(14),
                      value: selectedUserType.value,
                      isExpanded: true,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      items: List.generate(
                          userType.length,
                          (index) => DropdownMenuItem(
                                value: userType[index],
                                child: Row(
                                  children: [
                                    CustomText(
                                      color: ColorConst.textSecondaryColor,
                                      ls: 0.5,
                                      text: userType[index],
                                    ),
                                  ],
                                ),
                              )),
                      onChanged: (value) {
                        selectedUserType.value = value!;
                      },
                    )),
              ),
            ),
             CustomSize(
              height: 20,
            ),
            CustomTextFormField(fieldColor: ColorConst.cardBgColor, text: "Your Name", hintText: "xxxxxxxx", controller: nameController),
             CustomSize(
              height: 20,
            ),
            CustomTextFormField(
                fieldColor: ColorConst.cardBgColor, text: "Your Address", hintText: "24-B, new stallion street", controller: addressController),
             CustomSize(
              height: 20,
            ),
            CustomTextFormField(fieldColor: ColorConst.cardBgColor, text: "Email Address", hintText: "xyz@gmail.com", controller: emailController),
             CustomSize(
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
         Row(
          children: [
            CustomText(text: "Password", color: ColorConst.textSecondaryColor, fontFamily: ForFontFamily.rale),
          ],
        ),
         CustomSize(),
        Obx(
          () => TextFormField(
            textInputAction: TextInputAction.next,
            style:  TextStyle(fontWeight: FontWeight.bold,color: ColorConst.textPrimaryColor),
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
              fillColor: ColorConst.cardBgColor,
              suffixIcon: IconButton(
                onPressed: () {
                  isView.value = !isView.value;
                },
                icon: isView.value ?  Icon(Icons.visibility_off,color: ColorConst.textPrimaryColor,) :  Icon(Icons.visibility,color: ColorConst.textPrimaryColor,),
              ),
              hintText: ".......",
              hintStyle:  TextStyle(color: ColorConst.textSecondaryColor, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
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
         CustomText(
          text: "Already Have Account?",
          size: 16,
          color: ColorConst.textSecondaryColor,
        ),
        TextButton(
          onPressed: () {
            show(Routes.signIn);
          },
          child:  CustomText(
            text: "Sign In",
            color: ColorConst.primaryColor,
          ),
        )
      ],
    );
  }

  Widget buildSignUpButton() {
    return Obx(
      () => VarConst.isLoading.value
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize:  Size.fromHeight(50),
                  backgroundColor: ColorConst.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              onPressed: () {
                Get.snackbar("Wait", "Details checking is in process");
              },
              child:  CircularProgressIndicator(
                color: Colors.white,
              ))
          : CustomButton(onPressed: () => onCreateAccount(), buttonText: "SignUp"),
    );
  }

  Future<void> onCreateAccount() async {
    try {
      final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim());

      if (nameController.text.trim().isEmpty) {
        AppSnackBar.showErrorSnackBar(
          message: "please enter your name.",
          title: "error",
        );
      } else if (addressController.text.trim().isEmpty) {
        AppSnackBar.showErrorSnackBar(
          message: "please enter your address.",
          title: "error",
        );
      } else if (!emailValid) {
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

        VarConst.credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        log("User Log In Found With ${VarConst.credential!.user!.uid}");

        VarConst.userFCMToken = await FirebaseMessaging.instance.getToken();
        log("UVarConst.userFCMToken ${VarConst.userFCMToken}");

        await FirebaseFirestore.instance.collection("users").doc(VarConst.credential!.user!.uid).set({
          "name": nameController.text.trim(),
          "address": addressController.text.trim(),
          "uId": VarConst.credential!.user!.uid,
          "email": emailController.text,
          "orderList": [],
          "userFcm": VarConst.userFCMToken ?? "",
          "userType": selectedUserType.value,
          "cart": []
        });
        VarConst.isLoading.value = false;
        showOffAll(Routes.signIn);
      }
    } on FirebaseAuthException catch (e) {
      VarConst.isLoading.value = false;
      AppSnackBar.showErrorSnackBar(
        message: e.message ?? "",
        title: "error",
      );
    } catch (e) {
      VarConst.isLoading.value = false;
      log(e.toString());
      AppSnackBar.showErrorSnackBar(
        message: e.toString(),
        title: "error",
      );
    }
  }
}
