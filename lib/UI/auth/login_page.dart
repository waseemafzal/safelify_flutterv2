import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/global_helpers.dart';
import '../styles/styles.dart';
import '../widgets/mighty_button.dart';
import '../widgets/mighty_text_field.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController _authController = Get.find();

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey();

  final RxBool shouldShowPassword = false.obs;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _emailEditingController.text = 'muzammil@gmail.com';
      _passwordEditingController.text = '12345678';
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Form(
        key: _form,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 110.h),
            Text(
              "Welcome Back",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Text(
              "Login to your account",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 36.h),
            MightyTextField(
              placeHolder: "Email or Mobile Number",
              controller: _emailEditingController,
              validator: (value) => GetUtils.isEmail(_emailEditingController.text) ? null : 'Invalid email address',
            ),
            Obx(() {
              return MightyTextField(
                  placeHolder: "Password",
                  controller: _passwordEditingController,
                  obscureText: shouldShowPassword.value,
                  validator: (value) => _passwordEditingController.text.length < 4 ? "Password too short" : null,
                  suffix: GestureDetector(
                    onTap: () => shouldShowPassword.value = !shouldShowPassword.value,
                    child: Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Icon(!shouldShowPassword.value ? Icons.remove_red_eye : Icons.visibility_off_rounded, size: 15),
                    ),
                  ));
            }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kdPadding.w),
              child: Obx(() {
                return _authController.isLoading.value
                    ? getLoading()
                    : MightyButton(
                        onTap: () {
                          if (_form.currentState!.validate()) {
                            _authController.login(
                              email: _emailEditingController.text,
                              password: _passwordEditingController.text,
                            );
                          }
                        },
                        text: "Login",
                      );
              }),
            ),
            SizedBox(height: 25.h),
            GestureDetector(
              onTap: () => Get.to(() => ForgotPasswordPage()),
              child: Text(
                'Forgot your password?',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 54.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account ?"),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () => Get.to(() => RegisterPage()),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
