import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../UI/Other/popUp.dart';
import '../UI/packages/choose_package_page.dart';
import '../UI/styles/styles.dart';
import '../UI/widgets/mighty_button.dart';
import '../controllers/permissions_controller.dart';

showMightySnackBar({required String message, Color color = kcPrimaryGradient}) {
  Get.showSnackbar(GetSnackBar(
    snackPosition: SnackPosition.BOTTOM,
    message: "${message}",
    duration: Duration(seconds: 5),
    leftBarIndicatorColor: color,
    margin: const EdgeInsets.all(kdPadding),
  ));
}

getLoading() {
  return Center(
    child: LoadingAnimationWidget.stretchedDots(color: kcPrimaryGradient, size: 30),
  );
}

void printApiResponse(String text) {
  print('\x1B[33m$text\x1B[0m');
}

const stEmailKey = 'EmailKey';
const stPasswordKey = "PasswordKey";
const stMobileKey = "MobileKey";
const stUserData = "MobileKey";
storeAuthData(Map<String, dynamic> user) async {
  final box = GetStorage();
  await box.write(stUserData, jsonEncode(user));
}

Future<Map<String, dynamic>> getAuthDataFromLocalStorage() async {
  final box = GetStorage();
  // final fcmToken = await FirebaseMessaging.instance.getToken();

  printApiResponse("Local user :: ${box.read(stUserData)}");

  return jsonDecode(box.read(stUserData));
}

Future<bool> isFirstTimeLogin() async {
  var box = GetStorage('LoginContainer');

  String? isFirstTimeLogin = box.read('firstTimeLogin');
  printApiResponse("FIRST TIME LOGIN ${isFirstTimeLogin}");
  if (isFirstTimeLogin == null) {
    await box.write('firstTimeLogin', 'false');
    return true;
  }
  return false;
}

showUpgradeAccountDialogue(BuildContext context, [String? message]) async {
  await showDialog(
    context: context,
    builder: (_) => MightyPopupDialogue(
      content: [
        Container(
          padding: EdgeInsets.all(kdPadding.w),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: CircleAvatar(
              backgroundColor: kcPrimaryGradient,
              child: Icon(Icons.clear_rounded, color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "You currently have a ${Get.find<PermissionsController>().permissionManager.value!.currentPlan.split(' ')[0]} account.",
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            message ?? "To receive and submit reports of incidents in your community. Would you like to upgrade?",
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: kdPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: MightyButton(
                  text: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: MightyButton(
                  text: 'Upgrade',
                  onTap: () {
                    Get.to(ChoosePackagePage());
                  },
                  backgroundGradient: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
