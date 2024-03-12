import 'package:fiesta/screens/admin/order_admin/show_order_info_admin.dart';
import 'package:fiesta/screens/admin/users/user_data_admin.dart';
import 'package:fiesta/screens/terms/terms_screen.dart';
import 'package:fiesta/screens/users/cart/cart.dart';
import 'package:fiesta/screens/users/cart/order_placed.dart';
import 'package:fiesta/screens/users/orders_users/order_user.dart';
import 'package:fiesta/screens/users/profile_user/profile_user.dart';
import '../screens/admin/product_admin/edit_product_admin.dart';
import '../screens/reseller/reseller_screen.dart';
import '../screens/users/cart/confirm_address_user.dart';
import '../screens/users/cart/confirm_order.dart';
import '/screens/admin/admin_home.dart';
import '/screens/admin/product_admin/all_product_admin.dart';
import '/screens/admin/users/all_users_admin.dart';
import '/screens/sign_in/forgot_password.dart';
import '/screens/admin/product_admin/add_product_admin.dart';
import '/screens/admin/product_admin/shoe_info_screen_admin.dart';
import '/screens/users/shoe_info_screen.dart';
import '/screens/users/user_home.dart';
import '/screens/sign_in/create_account.dart';
import '/screens/intro/intro1.dart';
import '/screens/intro/intro2.dart';
import '/screens/intro/intro3.dart';
import '/screens/sign_in/sign_in.dart';
import '/screens/splash/splash.dart';
import 'package:get/get.dart';
import 'routes.dart';

class PageRouting{
  List<GetPage> pageRouting = [
    GetPage(name: Routes.splash, page: () =>  Splash()),
    GetPage(name: Routes.signIn, page: () =>  SignIn()),
    GetPage(name: Routes.intro1, page: () =>  Intro1()),
    GetPage(name: Routes.intro2, page: () =>  Intro2()),
    GetPage(name: Routes.intro3, page: () =>  Intro3()),
    GetPage(name: Routes.createAccount, page: () =>  CreateAccount()),
    GetPage(name: Routes.forgotPassword, page: () =>  ForgotPasswordScreen()),
    GetPage(name: Routes.adminHome, page: () =>  AdminHome()),
    GetPage(name: Routes.allProductAdmin, page: () =>  AllProductAdmin()),
    GetPage(name: Routes.addProductAdmin, page: () =>  AddProductAdmin()),
    GetPage(name: Routes.editProductAdmin, page: () =>  EditProductAdmin()),
    GetPage(name: Routes.shoeInfoScreenAdmin, page: () =>  ShoeInfoScreenAdmin()),
    GetPage(name: Routes.allUserAdmin, page: () =>  AllUsersAdmin()),
    GetPage(name: Routes.userDataScreenAdmin, page: () =>  UserDataScreenAdmin()),
    GetPage(name: Routes.showOrderInfoAdmin, page: () =>  ShowOrderInfoAdmin()),
    GetPage(name: Routes.userHome, page: () =>  UserHome()),
    GetPage(name: Routes.orderUser, page: () =>  OrderUser()),
    GetPage(name: Routes.confirmAddressUser, page: () =>  ConfirmAddressUser()),
    GetPage(name: Routes.confirmOrderUser, page: () =>  ConfirmOrderUser()),
    GetPage(name: Routes.orderPlaced, page: () =>  OrderPlaced()),
    GetPage(name: Routes.profileUser, page: () =>  ProfileUser()),
    GetPage(name: Routes.shoeInfoScreen, page: () =>  ShoeInfoScreen()),
    GetPage(name: Routes.cartScreenUser, page: () =>  CartScreenUser()),
    GetPage(name: Routes.termsScreen, page: () =>  TermsScreen()),
    GetPage(name: Routes.resellerScreen, page: () =>  ResellerScreen()),
  ];
}