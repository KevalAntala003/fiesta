import 'package:get/get.dart';


String rupeesIcon = '\u{20B9}';

void show(String route, {dynamic argument}){
  Get.toNamed(route,arguments: argument);
}

void showOff(String route,{argument}){
  Get.offAndToNamed(route,arguments: argument);
}

void showOffAll(String route,{argument}){
  Get.offAllNamed(route,arguments: argument);
}