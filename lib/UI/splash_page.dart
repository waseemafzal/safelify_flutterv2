import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_page.dart';
import '../controllers/auth_controller.dart';
import '../utils/global_helpers.dart';
import '../controllers/permissions_controller.dart';
import 'auth/login_page.dart';
import 'styles/styles.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthController _authController = Get.find();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onInit();
    });
  }

  onInit() async {
    try {
      Map<String, dynamic> authData = await getAuthDataFromLocalStorage();

      if (await _authController.attemptLogin(email: authData['user']['email'], password: authData['user']['password'])) {
        Get.offAll(() => MainPage());
      } else {
        Get.offAll(() => LoginPage());
      }
    } catch (e) {
      printApiResponse("Login failed :: ${e.toString()}");
      Get.offAll(() => LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: null),
        child: Center(
          child: Image.asset(
            'assets/logo/app_logo.png',
            width: Get.width * 0.4,
          ),
        ),
      ),
    );
  }
}
