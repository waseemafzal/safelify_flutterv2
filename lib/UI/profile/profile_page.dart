import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'become_reported_page.dart';
import 'edit_profile_page.dart';
import '../../config/config.dart';
import '../../utils/global_helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Other/notifcations_page.dart';
import '../packages/choose_package_page.dart';
import '../../controllers/auth_controller.dart';

import '../styles/styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: kcPrimaryGradient),
        title: Text(
          'Profile',
          style: TextStyle(
            color: kcPrimaryGradient,
          ),
        ),
      ),
      backgroundColor: kcBackGroundGradient,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: (kdPadding - 8).w),
        child: ListView(
          children: [
            SizedBox(height: 60.h),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 10,
                  )
                ],
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 50.r,
                backgroundImage: NetworkImage('${_authController.user.value!.profilePic}'),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "${_authController.user.value!.name}",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            _buildProfileMenuOption(
              icon: Icons.compare_arrows_rounded,
              text: "Edit Profile",
              onTap: () => Get.to(() => EditProfilePage()),
            ),
            SizedBox(
              height: 20,
            ),
            _buildProfileMenuOption(
              icon: Icons.compare_arrows_rounded,
              text: "View your plan",
              onTap: () => Get.to(() => ChoosePackagePage()),
            ),
            SizedBox(
              height: 20,
            ),
            _buildProfileMenuOption(
              icon: Icons.notifications_outlined,
              text: "Notifications",
              onTap: () => Get.to(() => NotificationsPage()),
            ),
            SizedBox(height: 20.h),
            _buildProfileMenuOption(
              icon: Icons.gavel_outlined,
              text: "Terms & Conditions",
              onTap: () {
                launchUrl(Uri.parse(kTermAndConditionsURL), mode: LaunchMode.externalApplication);
              },
            ),
            SizedBox(height: 20.h),
            _buildProfileMenuOption(
              icon: Icons.shield_outlined,
              text: "Privacy Policy",
              onTap: () {
                launchUrl(Uri.parse(kPrivacyPolicyURL), mode: LaunchMode.externalApplication);
              },
            ),
            SizedBox(height: 20.h),
            _buildProfileMenuOption(
              icon: Icons.perm_contact_calendar_rounded,
              text: "Become a Reporter",
              onTap: () {
                Get.to(() => BecomeReporterPage());
                // launchUrl(Uri.parse(kPrivacyPolicyURL), mode: LaunchMode.externalApplication);
              },
            ),
            SizedBox(height: 20.h),
            _buildProfileMenuOption(
              icon: Icons.power_settings_new_outlined,
              text: "Logout",
              onTap: () => _authController.logOut(),
            ),
            SizedBox(
              height: 20.h,
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Obx(() {
                      return _authController.isLoading.value
                          ? getLoading()
                          : AlertDialog(
                              content: Text("Are you sure you want to delete you account?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green),
                                  ),
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _authController.deleteMyAccount();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith((states) => kcPrimaryGradient),
                                  ),
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                    });
                  },
                );
              },
              child: Text(
                "Delete My Account",
                style: TextStyle(color: kcPrimaryGradient),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuOption({required String text, required IconData icon, required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Color.fromARGB(255, 223, 222, 222), spreadRadius: 0.8, blurRadius: 5, offset: Offset(0, 3))],
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomWidget(String url, String title) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Color.fromARGB(255, 223, 222, 222), spreadRadius: 0.8, blurRadius: 5, offset: Offset(0, 3))],
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Image.asset(
                "$url",
                height: 18.h,
                width: 18.w,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "$title",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
