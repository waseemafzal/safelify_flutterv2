import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import '../../controllers/permissions_controller.dart';
import 'popUp.dart';
import '../home_page.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/global_helpers.dart';
import '../profile/profile_page.dart';
import '../styles/styles.dart';
import '../widgets/app_bar.dart';
import '../widgets/mighty_button.dart';
import '../widgets/mighty_button_outlined.dart';
import '../widgets/mighty_drawer.dart';

const InternationalServicesUpgradePrompt = 'To access this feature you will need to upgrade your account.\nYou you like to upgrade your account?';

class InternationalServicesPage extends StatelessWidget {
  InternationalServicesPage({super.key});

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                  iconPath: 'assets/icons/plane.png',
                  title: 'Airport Protocol\nConcierge',
                  onTap: () {
                    // _appController.currentBottomNavIndex.value = 1;
                    _showRequestHelpDialogue(context: context, requestType: "Airport Protocol");
                  },
                ),
                _buildHomePageItem(
                  bgPath: 'assets/images/rect_red.png',
                  iconPath: 'assets/icons/car-rental.png',
                  title: 'Car Rental',
                  onTap: () {
                    // _appController.currentBottomNavIndex.value = 1;
                    _showRequestHelpDialogue(context: context, requestType: "Car Rental");
                  },
                ),
                _buildHomePageItem(
                  bgPath: 'assets/images/rect_green.png',
                  iconPath: 'assets/icons/driver.png',
                  title: 'Dedicated\nDriver Only',
                  onTap: () {
                    // _appController.currentBottomNavIndex.value = 1;
                    _showRequestHelpDialogue(context: context, requestType: "Driver Only");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildHomePageItem({
    required String bgPath,
    required String iconPath,
    required String title,
    required Function() onTap,
  }) {
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
            // Text("On Your Action"),
            Text(
              "Please confirm if you would like to make a reservation.",
              textAlign: TextAlign.center,
            ),
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
                              text: 'Get In Touch',
                              onTap: () async {
                                if (Get.find<PermissionsController>().canAccessInternationalServices()) {
                                  if (await confirmed(context, "Are you sure you want to make reservation?")) {
                                    _authController.requestHelp(requestType: requestType, description: 'send help', successMessage: "Request received.");
                                  }
                                } else {
                                  showUpgradeAccountDialogue(context, InternationalServicesUpgradePrompt);
                                }
                              },
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
