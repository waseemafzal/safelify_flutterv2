import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/global_helpers.dart';
import '../styles/styles.dart';
import '../widgets/mighty_button.dart';
import '../widgets/mighty_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final AuthController _authController = Get.find();

  final TextEditingController _emailEditingController = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Form(
        key: _form,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 110.h),
            Text(
              "Forgot your password?",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Text(
              "Enter your email address",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 36.h),
            MightyTextField(
              placeHolder: "Email Address",
              controller: _emailEditingController,
              validator: (value) => GetUtils.isEmail(_emailEditingController.text) ? null : 'Invalid email address',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kdPadding.w),
              child: Obx(() {
                return _authController.isLoading.value
                    ? getLoading()
                    : MightyButton(
                        onTap: () {
                          if (_form.currentState!.validate()) {
                            _authController.forgotPassword(email: _emailEditingController.text);
                          }
                        },
                        text: "Submit",
                      );
              }),
            ),
            SizedBox(height: 25.h),
            GestureDetector(
              onTap: () => Get.back(),
              child: Text(
                'Go Back',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
