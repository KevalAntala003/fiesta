import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiesta/utils/common_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
import 'package:http/http.dart' as http;


class ConfirmOrderUser extends StatefulWidget {
   ConfirmOrderUser({super.key});

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
    return  Row(
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
          ?  Center(child: CircularProgressIndicator())
          : ListView.separated(
              shrinkWrap: true,
              physics:  NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), side:  BorderSide(color: ColorConst.textSecondaryColor, width: 0.2)),
                  tileColor: ColorConst.cardBgColor,
                  onTap: () => show(Routes.shoeInfoScreenAdmin, argument: cartItems[index].shoeData),
                  leading: CachedNetworkImage(
                    imageUrl: cartItems[index].shoeData!.imgUrl!,
                    placeholder: (context, url) =>  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>  Icon(Icons.error),
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
                return  CustomSize();
              },
              itemCount: cartItems.length),
    );
  }

  Widget buildConfirm() {
    return Obx(
      () => Padding(
        padding:  EdgeInsets.all(8.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize:  Size.fromHeight(50),
                backgroundColor: ColorConst.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
            onPressed: isPlacingOrder.value ? null : () async {
              Razorpay razorpay = Razorpay();
              var options = {
                'key': 'rzp_test_fpmD1GY1NRMzCJ',
                'amount': totalAmount * 100,
                'name': 'Fiesta',
                'description': 'Fine T-Shirt',
                'retry': {'enabled': true, 'max_count': totalAmount},
                'send_sms_hash': true,
                'prefill': {
                  'contact': '8888888888',
                  'email': ListConst.currentUser.email!
                },
                'external': {
                  'wallets': ['paytm']
                }
              };
              razorpay.on(
                  Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                  handlePaymentSuccessResponse);
              razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                  handleExternalWalletSelected);
              razorpay.open(options);
            },
            child: isPlacingOrder.value ?  CircularProgressIndicator() : Padding(
              padding:  EdgeInsets.all(8.0),
              child:  CustomText(
                size: 16,
                text: "Confirm Order",
                color: Colors.white,
              ).animate().fadeIn(duration:  Duration(milliseconds: 500)),
            )),
      ),
    );
  }

  Future<void> sellerNotificationApi({String? fcmToken,String? title,String? body}) async {
    var headers = {
      'authority': 'testfcm.com',
      'accept': 'application/json, text/plain, /',
      'accept-language':
          'en-IN,en-US;q=0.9,en;q=0.8,gu-IN;q=0.7,gu;q=0.6,en-GB;q=0.5',
      'content-type': 'application/json;charset=UTF-8',
      'cookie':
          '_ga_NYD7VXW2YX=GS1.1.1710087334.1.0.1710087334.60.0.0; _ga=GA1.2.2056033710.1710087334; _gid=GA1.2.304498755.1710087334; _gat=1; _clck=1j6f6a5%7C2%7Cfjy%7C0%7C1530; _gat_gtag_UA_148206087_1=1; _hjSessionUser_2531851=eyJpZCI6ImZiYzBkN2JmLTcyZTYtNTI1OS1hN2ZjLTg5MzVmMTNkMjliYSIsImNyZWF0ZWQiOjE3MTAwODczMzQ1MzIsImV4aXN0aW5nIjpmYWxzZX0=; _hjSession_2531851=eyJpZCI6IjRjODhjZTA0LTMxNjktNDBlZi1hMzZkLWE0OGEyMDI3YWM3YSIsImMiOjE3MTAwODczMzQ1MzMsInMiOjAsInIiOjAsInNiIjowLCJzciI6MCwic2UiOjAsImZzIjoxLCJzcCI6MX0=; _clsk=186x5xj%7C1710087335585%7C1%7C1%7Cm.clarity.ms%2Fcollect',
      'origin': 'https://testfcm.com',
      'referer': 'https://testfcm.com/',
      'sec-ch-ua':
          '"Chromium";v="122", "Not(A:Brand";v="24", "Google Chrome";v="122"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Windows"',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'same-origin',
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36'
    };
    var request =
        http.Request('POST', Uri.parse('https://testfcm.com/api/notify'));

    Map<String,dynamic> bodyData = {
      "postBody": {
        "notification": {
          "title": "$title",
          "body": "$body",
          "click_action": null,
          "icon": null
        },
        "data": null,
        "to": "$fcmToken"
      },
      "serverKey": "AAAAAoemCuc:APA91bHaR3rTz3ccz9r70dAaPz8VfjnpEAhBjglIVDShaaapyrF_1im6df7Y-1Wx22RPyxZ_5H9_n5ZtXo-Bab9IGc3khOUN8FhLYn6ejFG1AtnyfzYYL8mkMJ5RXYslJVaGUNMyKQ7K"
    };

    request.body = jsonEncode(bodyData);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
    } else {
      log('${response.reasonPhrase}');
    }
  }

  Future<void> onPlaceOrder() async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    isPlacingOrder.value = true;
    try {
      await FirebaseFirestore.instance.collection("orders").doc(orderId).set(jsonDecode(orderDataToJson(orderData)));
      ListConst.currentUser.orderList!.add(orderData);
      ListConst.currentUser.cart!.clear();
      await GetDataRepository().setCurrentUserDetail();
      for (var element in cartItems) {
        sellerNotificationApi(
          fcmToken: element.shoeData!.FCMToken,
          title: element.shoeData!.name,
          body: element.shoeData!.price.toString(),
        );
        log('element--->${element.shoeData!.toJson()}');
      }
      isPlacingOrder.value = false;
      showOff(Routes.orderPlaced);
      AppSnackBar.showErrorSnackBar(message: 'Order Placed', title: 'success');
    } catch (e) {
      isPlacingOrder.value = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Description: ${response.message}");
  }

  Future<void> handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    log(response.data.toString());
    await onPlaceOrder();
    // showAlertDialog(
    //     context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child:  Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
