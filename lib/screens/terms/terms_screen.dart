import 'package:fiesta/constant/color_const.dart';
import 'package:flutter/material.dart';

import '../../constant/var_const.dart';
import '../../custom_widget/custom_back.dart';
import '../../custom_widget/custom_size.dart';
import '../../custom_widget/custom_text.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  List<String> titles = [
    "Terms and Conditions :",
    "Purchases :",
    "Subscriptions :",
    "Content :",
    "Links To Other Web Sites :"
  ];
  List<String> subTitles = [
    "These Terms and Conditions govern your use of Foot Fiesta mobile application operated by Jensi & Team.\nBy accessing or using the App, you agree to be bound by these Terms and Conditions. If you disagree with any part of the terms, then you may not access the App.",
    "If you wish to purchase any product or service made available through the App, you may be asked to supply certain information relevant to your Purchase including, without limitation, your name, address, payment information, and contact details.",
    "Some parts of the App are billed on a subscription basis. You will be billed in advance on a recurring and periodic basis. Billing cycles are set on a monthly or annual basis, depending on the type of subscription plan you select when purchasing a Subscription.",
    "Our App allows you to post, link, store, share, and otherwise make available certain information, text, graphics, videos, or other material. You are responsible for the Content that you post on or through the App, including its legality, reliability, and appropriateness.",
    "Our App may contain links to third-party web sites or services that are not owned or controlled by Jensi & Team.Team has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third-party web sites or services. You further acknowledge and agree that our team shall not be responsible or liable, directly or indirectly, for any damage or loss"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            buildAppbar(),
            buildContent()
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
          text: "Terms",
          size: 20,
          weight: true,
        ),
        CustomSize(
          width: 50,
        )
      ],
    );
  }

  Widget buildContent() {
    return ListView.separated(
      separatorBuilder: (BuildContext context,index){
        return const CustomSize(height: 20,);
      },
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: titles.length,
        itemBuilder: (BuildContext context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: titles[index],
                size: 18,
                align: TextAlign.start,
              ),
              const CustomSize(),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: ColorConst.cardBgColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    text: subTitles[index],
                    size: 16,
                    align: TextAlign.start,
                    color: ColorConst.textSecondaryColor,                  ),
                ),
              )
            ],
          );
        });
  }
}
