import 'package:get/get.dart';

class AppController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt currentBottomNavIndex = 0.obs;
}
