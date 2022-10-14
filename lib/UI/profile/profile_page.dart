import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_lify/UI/profile/edit_profile_page.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            Text(
              "${_authController.user.value!.name}",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w400,
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
            SizedBox(
              height: 20.h,
            ),
            _buildProfileMenuOption(
              icon: Icons.power_settings_new_outlined,
              text: "Logout",
              onTap: () => _authController.logOut(),
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
