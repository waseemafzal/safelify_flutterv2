import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safe_lify/UI/Other/international_services.dart';
import 'package:safe_lify/UI/Other/popUp.dart';
import 'package:safe_lify/UI/packages/choose_package_page.dart';
import 'package:safe_lify/controllers/permissions_controller.dart';
import 'package:safe_lify/models/permision.dart';
import 'package:safe_lify/utils/global_helpers.dart';

import '../Other/Sidebar.dart';
import '../Other/admin_contacts_page.dart';
import '../chat/chat_page.dart';
import '../../controllers/auth_controller.dart';

import '../../controllers/app_controller.dart';
import '../styles/styles.dart';
import 'mighty_button.dart';

class MightyDrawer extends StatelessWidget {
  MightyDrawer({
    Key? key,
  }) : super(key: key);

  final AppController _appController = Get.find();
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      elevation: 5,
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 22.0.h,
              left: 22.0.w,
              right: 10.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/icons/safe_life_text.png"),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: CircleAvatar(
                    backgroundColor: kcPrimaryGradient,
                    radius: 15,
                    child: Center(
                      child: Icon(
                        Icons.clear,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          DrawerItem(
            image: 'assets/icons/home.png',
            title: "Home",
            isSelected: true,
            onTap: () => Get.back(),
          ),
          SizedBox(height: 20.h),
          DrawerItem(
            image: 'assets/icons/report.png',
            title: "Report",
            onTap: () {
              _appController.currentBottomNavIndex.value = 1;
            },
          ),
          SizedBox(height: 20.h),
          DrawerItem(
            image: 'assets/icons/balance.png',
            title: "Legal Assistance",
            onTap: () => Get.to(
              () => AdminContactsPage(
                contactType: 'legal',
              ),
            ),
          ),
          SizedBox(height: 20.h),
          DrawerItem(
              image: 'assets/icons/plane.png',
              title: "International Services",
              onTap: () {
                Get.to(() => InternationalServicesPage());
              }),
          SizedBox(height: 20.h),
          DrawerItem(
            image: 'assets/icons/medical_assistance.png',
            title: "Medical Assistance",
            onTap: () => Get.to(
              () => AdminContactsPage(
                contactType: 'medical',
              ),
            ),
          ),
          SizedBox(height: 20.h),
          DrawerItem(
            image: 'assets/icons/road_assistance.png',
            title: "Road Assistance",
            onTap: () => Get.to(() => AdminContactsPage(contactType: 'road')),
          ),
          SizedBox(height: 20.h),
          DrawerItem(
            image: 'assets/icons/contact.png',
            title: "Contact us",
            onTap: () => Get.to(() => ChatPage()),
          ),
          SizedBox(height: 20.h),
          DrawerItem(
            image: 'assets/icons/power.png',
            title: "Logout",
            onTap: () => _authController.logOut(),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.image,
    required this.title,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 50.w),
        decoration: BoxDecoration(
          color: isSelected ? kcPrimaryGradient : Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 4.w),
              Image.asset(
                image,
                width: 20.w,
                height: 20.h,
                color: isSelected ? Colors.white : Colors.black,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
