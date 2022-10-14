import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../UI/styles/styles.dart';

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
