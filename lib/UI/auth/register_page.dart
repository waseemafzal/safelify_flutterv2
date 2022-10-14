import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/global_helpers.dart';
import 'login_page.dart';
import '../styles/styles.dart';

import '../widgets/mighty_button.dart';
import '../widgets/nighty_text_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  AuthController _authController = Get.find();

  final TextEditingController _fullNameEditingController = TextEditingController();
  final TextEditingController _mobileEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _passwordConfirmationEditingController = TextEditingController();

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
            SizedBox(height: 50.h),
            Text(
              "Sign Up",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60.h),
            MightyTextField(
              placeHolder: "Full Name",
              controller: _fullNameEditingController,
              validator: (value) => _fullNameEditingController.text.length < 3 ? "Name is too short." : null,
            ),
            MightyTextField(
              placeHolder: "Mobile",
              controller: _mobileEditingController,
              validator: (value) => _mobileEditingController.text.length != 11 ? "Invalid phone number." : null,
            ),
            MightyTextField(
              placeHolder: "Email",
              controller: _emailEditingController,
              validator: (value) => GetUtils.isEmail(_emailEditingController.text) ? null : "Invalid email address.",
            ),
            MightyTextField(
              placeHolder: "Password",
              controller: _passwordEditingController,
              validator: (value) => _passwordEditingController.text.length < 8 ? "Password must be at least 8 characters" : null,
              obscureText: true,
            ),
            MightyTextField(
              placeHolder: "Confirm Password",
              controller: _passwordConfirmationEditingController,
              validator: (value) => _passwordEditingController.text != _passwordConfirmationEditingController.text ? "Passwords do not match" : null,
              obscureText: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kdPadding.w),
              child: Obx(() {
                return _authController.isLoading.value
                    ? getLoading()
                    : MightyButton(
                        onTap: () {
                          if (_form.currentState!.validate()) {
                            _authController.register(
                              name: _fullNameEditingController.text,
                              mobile: _mobileEditingController.text,
                              email: _emailEditingController.text,
                              password: _passwordEditingController.text,
                            );
                          }
                        },
                        text: "Sing Up",
                      );
              }),
            ),
            SizedBox(height: 54.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () => Get.to(() => LoginPage()),
                  child: Text(
                    'Login',
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
