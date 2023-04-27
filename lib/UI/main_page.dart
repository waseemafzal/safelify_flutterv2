import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';
import 'Other/emergency_contact_page.dart';
import 'Other/report_page.dart';
import 'Other/safelify_reports_page.dart';
import 'home_page.dart';
import 'styles/styles.dart';
import 'widgets/mighty_bottm_nav/fancy_bottom_navigation.dart';

class MainPage extends StatelessWidget {
  final AppController _appController = Get.find();

  final tabs = [HomePage(), ReportPage(), SafeLifyReports(), EmergencyContactPage()];
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: tabs[_appController.currentBottomNavIndex.value],
        extendBody: true,
        bottomNavigationBar: Obx(() {
          return MightyBottomNavigation(
            initialSelection: _appController.currentBottomNavIndex.value,
            tabs: [
              TabData(
                iconData: Image.asset(
                  'assets/icons/home.png',
                  height: 25,
                  width: 25,
                ),
                title: "Home",
              ),
              TabData(
                iconData: Image.asset(
                  'assets/icons/report.png',
                  height: 25,
                  width: 25,
                ),
                title: "Report",
              ),
              TabData(
                iconData: Image.asset(
                  'assets/icons/community.png',
                  color: Colors.black54,
                  height: 25,
                  width: 25,
                ),
                title: "Community",
              ),
              TabData(
                iconData: Image.asset(
                  'assets/icons/user_shield.png',
                  height: 25,
                  width: 25,
                ),
                title: "Contacts",
              ),
            ],
            inactiveIconColor: Colors.black54,
            circleColor: kcPrimaryGradient,
            activeIconColor: Colors.white,
            onTabChangedListener: (position) {
              _appController.currentBottomNavIndex.value = position;
              // _appController.currentBottomNavIndex.refresh();
            },
          );
        }),
      );
    });
  }
}
