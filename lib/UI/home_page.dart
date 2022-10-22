import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'Other/popUp.dart';
import 'profile/profile_page.dart';
import 'widgets/mighty_button.dart';
import 'widgets/mighty_button_outlined.dart';
import '../utils/global_helpers.dart';

import '../controllers/app_controller.dart';
import '../controllers/auth_controller.dart';
import 'Other/medical_reports.dart';
import 'Other/report_page.dart';
import 'Other/road_assistance.dart';
import 'styles/styles.dart';
import 'widgets/app_bar.dart';
import 'widgets/mighty_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  AuthController _authController = Get.find();
  AppController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MightyDrawer(),
      appBar: getAppBar(
        context: context,
        color: Colors.white,
        iconColor: kcPrimaryGradient,
        title: Text(
          "Safelify",
          style: Theme.of(context).textTheme.headline2?.copyWith(color: kcPrimaryGradient),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => ProfilePage()),
            icon: Icon(LineIcons.user),
          ),
        ],
      ),
      body: Column(
        children: [
          Transform.scale(
            scale: 1,
            child: Transform.translate(
              offset: Offset(0, -40.h),
              child: Container(
                height: 110.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.elliptical(400, 100)),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView(
              padding: EdgeInsets.symmetric(horizontal: kdPadding.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                _buildHomePageItem(
                  bgPath: 'assets/images/rect_blue.png',
                  iconPath: 'assets/icons/shield.png',
                  title: 'Report Tips',
                  onTap: () {
                    _appController.currentBottomNavIndex.value = 1;
                  },
                ),
                _buildHomePageItem(
                  bgPath: 'assets/images/rect_red.png',
                  iconPath: 'assets/icons/strethoscope.png',
                  title: 'Medical\nemergency',
                  onTap: () {
                    _showRequestHelpDialogue(context: context, requestType: "Medical");
                  },
                ),
                _buildHomePageItem(
                  bgPath: 'assets/images/rect_green.png',
                  iconPath: 'assets/icons/med_kit.png',
                  title: 'Physical\nemergency',
                  onTap: () {
                    _showPhysicalEmergencyDialogue(context: context);
                  },
                ),
                _buildHomePageItem(
                  bgPath: 'assets/images/rect_yellow.png',
                  iconPath: 'assets/icons/fire.png',
                  title: 'Fire',
                  onTap: () {
                    _showRequestHelpDialogue(context: context, requestType: 'Fire');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildHomePageItem({required String bgPath, required String iconPath, required String title, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(bgPath)),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 35.h,
              width: 35.w,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  _showPhysicalEmergencyDialogue({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return MightyPopupDialogue(
          content: [
            Container(
              padding: EdgeInsets.only(top: kdPadding.w),
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
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              child: Obx(() {
                return _authController.isRequestingHelp.value
                    ? getLoading()
                    : Column(
                        children: [
                          MightyButtonOutlined(
                            text: 'Kidnapping',
                            onTap: () {
                              _authController.requestHelp(description: 'send help', requestType: 'Kidnapping');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Accident',
                            onTap: () {
                              _authController.requestHelp(description: 'send help', requestType: 'Accident');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Road Robbery',
                            onTap: () {
                              _authController.requestHelp(description: 'send help', requestType: 'Road Robbery');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Home Burglary',
                            onTap: () {
                              _authController.requestHelp(description: 'send help', requestType: 'Home Burglary');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Assault',
                            onTap: () {
                              _authController.requestHelp(description: 'send help', requestType: 'Assault');
                            },
                          ),
                        ],
                      );
              }),
            )
          ],
        );
      },
    );
  }

  _showRequestHelpDialogue({required BuildContext context, required String requestType}) async {
    showDialog(
      context: context,
      builder: (context) {
        return MightyPopupDialogue(
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
            Text("On Your Action"),
            Text("It will respond immediately."),
            Padding(
              padding: EdgeInsets.symmetric(vertical: kdPadding.w, horizontal: 12.w),
              child: Obx(() {
                return _authController.isRequestingHelp.value
                    ? getLoading()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MightyButton(
                              text: 'Send Help',
                              onTap: () {
                                _authController.requestHelp(requestType: requestType, description: 'send help');
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: MightyButton(
                              text: 'Notify Contact',
                              onTap: () {
                                _authController.requestHelp(requestType: requestType, description: 'notify contact');
                              },
                              backgroundGradient: Colors.blue,
                            ),
                          ),
                        ],
                      );
              }),
            )
          ],
        );
      },
    );
  }
}
