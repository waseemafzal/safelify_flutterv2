import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'UI/splash_page.dart';
import 'controllers/app_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/emergency_contact_controller.dart';
import 'controllers/notifications_controller.dart';
import 'controllers/payment_controller.dart';
import 'controllers/permissions_controller.dart';
import 'controllers/report_controller.dart';

import 'controllers/auth_controller.dart';
import 'controllers/comments_controller.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Put Controllers
    Get.put(AppController());
    Get.put(AuthController());
    Get.put(EmergencyContactController());
    Get.put(ReportController());
    Get.put(CommentsController());
    Get.put(ChatController());
    Get.put(PaymentController());
    Get.put(PermissionsController());
    Get.put(NotificationsController());

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Safe Lify",
          theme: ThemeData(
            textTheme: TextTheme(
              headline1: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              headline2: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              bodyText1: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            backgroundColor: Color(0xffefeeee),
          ),
          home: child,
        );
      },
      child: SplashPage(),
    );
  }
}
