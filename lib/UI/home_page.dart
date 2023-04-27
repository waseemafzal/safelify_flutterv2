import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:safe_lify/controllers/permissions_controller.dart';

import '../controllers/app_controller.dart';
import '../controllers/auth_controller.dart';
import '../utils/global_helpers.dart';
import 'Other/popUp.dart';
import 'profile/profile_page.dart';
import 'styles/styles.dart';
import 'widgets/app_bar.dart';
import 'widgets/mighty_button.dart';
import 'widgets/mighty_button_outlined.dart';
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
                  iconPath: 'assets/icons/vehicle.png',
                  title: 'Auto\nEmergency',
                  onTap: () {
                    _showRequestHelpDialogue(context: context, requestType: "Accident");
                  },
                ),
                _buildHomePageItem(
                  bgPath: 'assets/images/rect_red.png',
                  iconPath: 'assets/icons/strethoscope.png',
                  title: 'Medical\nemergency',
                  onTap: () async {
                    // if (Get.find<PermissionsController>().canNotifyContacts('Medical')) {
                    _showRequestHelpDialogue(context: context, requestType: "Medical");
                    // } else {
                    //   showUpgradeAccountDialogue(context);
                    // }
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
                  iconPath: 'assets/icons/balance.png',
                  title: 'Legal\nemergency',
                  onTap: () {
                    _showRequestHelpDialogue(context: context, requestType: 'Legal Emergency');
                    // _showPhysicalEmergencyDialogue(context: context);
                  },
                ),
                _buildHomePageItem(
                  bgPath: 'assets/images/rect_red.png',
                  iconPath: 'assets/icons/workplace.png',
                  title: 'Workplace\nemergency',
                  onTap: () async {
                    _showWorkPlaceEmergencyDialogue(context: context);
                  },
                ),
                _buildHomePageItem(
                  bgPath: 'assets/images/rect_blue.png',
                  iconPath: 'assets/icons/shield.png',
                  color: Color(0xff3f47cc),
                  title: 'Report Tips',
                  onTap: () {
                    _appController.currentBottomNavIndex.value = 1;
                  },
                ),
                // _buildHomePageItem(
                //   bgPath: 'assets/images/rect_yellow.png',
                //   iconPath: 'assets/icons/fire.png',
                //   title: 'Fire',
                //   onTap: () {
                //     _showRequestHelpDialogue(context: context, requestType: 'Fire');
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildHomePageItem({required String bgPath, required String iconPath, required String title, required Function() onTap, Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(bgPath),
            colorFilter: color != null ? ColorFilter.mode(color, BlendMode.multiply) : null,
          ),
          boxShadow: color != null
              ? [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 1,
                    spreadRadius: 2,
                  ),
                ]
              : [],
          border: color != null ? Border.all(width: 9, color: Colors.grey[200]!) : null,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 35.h,
              width: 35.w,
              color: Colors.white,
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
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Kidnapping');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Accident',
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Accident');
                              // if (await confirmed(context)) _authController.requestHelp(description: 'send help', requestType: 'Accident');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Road Robbery',
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Road Robbery');
                              // if (await confirmed(context)) _authController.requestHelp(description: 'send help', requestType: 'Road Robbery');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Home Burglary',
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Home Burglary');
                              // if (await confirmed(context)) _authController.requestHelp(description: 'send help', requestType: 'Home Burglary');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Assault',
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Assault');
                              // if (await confirmed(context)) _authController.requestHelp(description: 'send help', requestType: 'Assault');
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

  _showWorkPlaceEmergencyDialogue({required BuildContext context}) {
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
                            text: 'Workplace Accident',
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Workplace Accident');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Medical Emergencies',
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Medical Emergencies');
                              // if (await confirmed(context)) _authController.requestHelp(description: 'send help', requestType: 'Accident');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Cyber Emergencies',
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Cyber Emergencies');
                              // if (await confirmed(context)) _authController.requestHelp(description: 'send help', requestType: 'Road Robbery');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Physical Attack',
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Physical Attack');
                              // if (await confirmed(context)) _authController.requestHelp(description: 'send help', requestType: 'Home Burglary');
                            },
                          ),
                          SizedBox(height: 10.h),
                          MightyButtonOutlined(
                            text: 'Legal Emergencies',
                            onTap: () async {
                              _showRequestHelpDialogue(context: context, requestType: 'Legal Emergencies');
                              // if (await confirmed(context)) _authController.requestHelp(description: 'send help', requestType: 'Assault');
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
                              onTap: () async {
                                if (Get.find<PermissionsController>().canRequestForImmediateHelp(requestType)) {
                                  if (await confirmed(context)) {
                                    _authController.requestHelp(requestType: requestType, description: 'send help');
                                  }
                                } else {
                                  showUpgradeAccountDialogue(context);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: MightyButton(
                              text: 'Notify Contacts',
                              onTap: () async {
                                if (Get.find<PermissionsController>().canNotifyContacts(requestType)) {
                                  if (await confirmed(context)) {
                                    _authController.requestHelp(requestType: requestType, description: 'notify contacts');
                                  }
                                } else {
                                  showUpgradeAccountDialogue(context);
                                }
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

Future<bool> confirmed(BuildContext context, [String? message]) async {
  bool answer = false;
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
        Text("Are you sure?"),
        Text(
          message ?? "Please confirm if you need help sent immediately.",
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(kdPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: MightyButton(
                  text: 'Yes',
                  onTap: () {
                    answer = true;
                    Get.back();
                  },
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: MightyButton(
                  text: 'No',
                  onTap: () {
                    Get.back();
                  },
                  backgroundGradient: Colors.blue,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
  return answer;
}
