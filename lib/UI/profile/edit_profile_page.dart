import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/global_helpers.dart';
import '../styles/styles.dart';
import '../widgets/mighty_button.dart';
import '../widgets/mighty_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  AuthController _authController = Get.find();

  final TextEditingController _fullEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _addressEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _passwordConfirmationEditingController = TextEditingController();

  // final AuthController _authController = Get.find();

  final GlobalKey<FormState> _form = GlobalKey();

  ImagePicker _imagePicker = ImagePicker();

  Rx<XFile?> image = Rx(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: kcPrimaryGradient),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: kcPrimaryGradient,
          ),
        ),
      ),
      backgroundColor: kcBackGroundGradient,
      body: Form(
        key: _form,
        child: FutureBuilder(
            future: _authController.fetchProfile(),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.hasError) return Text('There was an error retrieving your information');

              if (!snapshot.hasData) return getLoading();

              _fullEditingController.text = snapshot.data!['user']['name'];
              _addressEditingController.text = snapshot.data!['user']['address'];
              _phoneEditingController.text = snapshot.data!['user']['phone'];

              return ListView(
                children: [
                  SizedBox(height: 50.h),
                  Obx(() {
                    return GestureDetector(
                      onTap: () async {
                        image.value = await _imagePicker.pickImage(source: ImageSource.gallery);
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 5,
                            )
                          ],
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: image.value == null
                            ? Image.network(
                                '${_authController.user.value!.profilePic}',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(image.value!.path),
                                height: 100,
                                width: 100,
                              ),
                      ),
                    );
                  }),
                  SizedBox(height: 50.h),
                  MightyTextField(
                    placeHolder: "Full Name",
                    controller: _fullEditingController,
                    validator: (value) => _fullEditingController.text.trim().length == 0 ? "Please enter your full name" : null,
                  ),
                  MightyTextField(
                    placeHolder: "Phone",
                    controller: _phoneEditingController,
                    validator: (value) => _phoneEditingController.text.trim().length == 0 ? "Please enter your phone name" : null,
                  ),
                  MightyTextField(
                    placeHolder: "Address",
                    controller: _addressEditingController,
                    validator: (value) => _addressEditingController.text.trim().length == 0 ? "Please enter your address." : null,
                  ),
                  MightyTextField(
                    placeHolder: "New Password",
                    controller: _passwordEditingController,
                  ),
                  MightyTextField(
                    placeHolder: "Confirm New Password",
                    controller: _passwordConfirmationEditingController,
                    validator: (value) {
                      if (_passwordEditingController.text.trim().length == 0) return null;

                      if (_passwordEditingController.text.trim().length < 6) return "Password must be at least 6 characters";

                      if (_passwordConfirmationEditingController.text.trim() != _passwordEditingController.text.trim()) return "Passwords do not match";

                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kdPadding.w),
                    child: Obx(() {
                      return _authController.isLoading.value
                          ? getLoading()
                          : MightyButton(
                              text: "Update",
                              onTap: () {
                                if (_form.currentState!.validate()) {
                                  _authController.updateProfile(
                                    name: _fullEditingController.text,
                                    phone: _phoneEditingController.text,
                                    address: _addressEditingController.text,
                                    image: image.value,
                                    password: _passwordConfirmationEditingController.text.trim(),
                                  );
                                }
                              });
                    }),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
