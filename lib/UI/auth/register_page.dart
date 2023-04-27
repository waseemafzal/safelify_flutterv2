import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../Other/legal_reports.dart';
import '../widgets/mighty_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/config.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/global_helpers.dart';
import '../styles/styles.dart';
import '../widgets/mighty_button.dart';
import '../widgets/mighty_text_field.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  AuthController _authController = Get.find();

  final TextEditingController _fullNameEditingController = TextEditingController();
  final TextEditingController _mobileEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _dobEditingController = TextEditingController();
  final TextEditingController _allergiesEditingController = TextEditingController();
  RxString _selectedBloodGroupType = ''.obs;
  RxString _selectedGender = 'male'.obs;
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _passwordConfirmationEditingController = TextEditingController();
  final TextEditingController _healthConditionEditingController = TextEditingController();
  final TextEditingController _vehicleMakeModelEditingController = TextEditingController();
  final TextEditingController _medicationsEditingController = TextEditingController();
  final TextEditingController _medicalInsuranceEditingController = TextEditingController();
  final TextEditingController _vehicleInsuranceEditingController = TextEditingController();
  final TextEditingController _nextOfKinEditingController = TextEditingController();
  final RxString _selectedCountry = ''.obs;

  final GlobalKey<FormState> _form = GlobalKey();
  RxBool _acceptedTermsAndConditions = false.obs;

  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 60),
          child: Form(
            key: _form,
            child: Column(
              children: [
                SizedBox(height: kdPadding),
                Text(
                  "Sign Up",
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: kdPadding),
                MightyTextField(
                  placeHolder: "Full Name",
                  controller: _fullNameEditingController,
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your name.' : null,
                ),
                MightyTextField(
                  placeHolder: "Mobile",
                  controller: _mobileEditingController,
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your mobile number.' : null,
                ),
                MightyTextField(
                  placeHolder: "Email",
                  controller: _emailEditingController,
                  validator: (value) => GetUtils.isEmail(_emailEditingController.text) ? null : "Invalid email address.",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: kdPadding, right: kdPadding, bottom: kdPadding),
                  child: Row(
                    children: [
                      Text("Country: "),
                      SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            showCountryPicker(
                                context: context,
                                onSelect: (value) {
                                  _selectedCountry.value = value.name;
                                });
                          },
                          child: Obx(() {
                            return Text(
                              _selectedCountry.value.length == 0 ? "Select your country of residence" : _selectedCountry.value,
                              style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.blue),
                              textAlign: TextAlign.end,
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                MightyTextField(
                  placeHolder: "Date of Birth",
                  controller: _dobEditingController,
                  enabled: false,
                  onTap: () async {
                    DateTime? time = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1960), lastDate: DateTime.now());
                    if (time == null) return;
                    _dobEditingController.text = DateFormat('${DateFormat.DAY}-MM-y').format(time);
                  },
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your Date of birth.' : null,
                ),
                MightyTextField(
                  placeHolder: "Allergies",
                  controller: _allergiesEditingController,
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your allergies.' : null,
                ),
                bloodGroupTypeField(),
                genderField(context),
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
                  withBottomPadding: false,
                ),
                SizedBox(height: kdPadding),
                MightyTextField(
                  placeHolder: "Health Condition",
                  controller: _healthConditionEditingController,
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your health condition..' : null,
                ),
                MightyTextField(
                  placeHolder: "Vehicle Year, Make and Model",
                  controller: _vehicleMakeModelEditingController,
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your vehicle info.' : null,
                ),
                MightyTextField(
                  placeHolder: "Medications if any",
                  controller: _medicationsEditingController,
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your vehicle modifications.' : null,
                ),
                MightyTextField(
                  placeHolder: "Medical Insurance if any",
                  controller: _medicalInsuranceEditingController,
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your medical insurance.' : null,
                ),
                MightyTextField(
                  placeHolder: "Vehicle Insurance if any",
                  controller: _vehicleInsuranceEditingController,
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your vehicle insurance.' : null,
                ),
                MightyTextField(
                  placeHolder: "Next of Kin",
                  controller: _nextOfKinEditingController,
                  validator: (value) => value == null || value.length == 0 ? 'Please enter your next of kin.' : null,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kdPadding.w, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Obx(() {
                        return Checkbox(
                          value: _acceptedTermsAndConditions.value,
                          onChanged: (value) => _acceptedTermsAndConditions.value = !_acceptedTermsAndConditions.value,
                          visualDensity: VisualDensity.compact,
                          overlayColor: MaterialStateProperty.resolveWith((states) => kcSecondaryColor),
                          fillColor: MaterialStateProperty.resolveWith((states) => kcPrimaryGradient),
                        );
                      }),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Wrap(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // textBaseline: TextBaseline.ideographic,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            runSpacing: 3,
                            children: [
                              Text(
                                "I agree to the ",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(kTermAndConditionsURL), mode: LaunchMode.externalApplication);
                                },
                                child: Text(
                                  "Terms & Conditions ",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: kcPrimaryGradient),
                                ),
                              ),
                              Text(
                                "and ",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(kPrivacyPolicyURL), mode: LaunchMode.externalApplication);
                                },
                                child: Text(
                                  "Privacy Policy",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: kcPrimaryGradient),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // SizedBox(height: kdPadding.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kdPadding.w),
                  child: Obx(() {
                    return _authController.isLoading.value
                        ? getLoading()
                        : MightyButton(
                            onTap: () {
                              if (_selectedCountry.value.length == 0) return showMightySnackBar(message: "Please select your country of residence");
                              if (_mobileEditingController.text.length == 0) return showMightySnackBar(message: "Please enter your mobile number.");
                              if (_selectedBloodGroupType.value.length == 0) return showMightySnackBar(message: "Please select your blood type.");
                              if (_form.currentState!.validate()) {
                                if (!_acceptedTermsAndConditions.value) return showMightySnackBar(message: "Please accept our terms and conditions to continue.");

                                _authController.register(
                                  name: _fullNameEditingController.text,
                                  mobile: _mobileEditingController.text,
                                  email: _emailEditingController.text,
                                  dob: _dobEditingController.text,
                                  allergies: _allergiesEditingController.text,
                                  bloodGroup: _selectedBloodGroupType.value,
                                  gender: _selectedGender.value,
                                  password: _passwordEditingController.text,
                                  healthConditions: _healthConditionEditingController.text,
                                  modelOfVehicle: _vehicleMakeModelEditingController.text,
                                  medications: _medicationsEditingController.text,
                                  medicalInsurance: _medicalInsuranceEditingController.text,
                                  vehicleInsurance: _vehicleInsuranceEditingController.text,
                                  nextOfKin: _nextOfKinEditingController.text,
                                  country: _selectedCountry.value,
                                );
                              }
                            },
                            text: "Sign Up",
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
        ),
      ),
    );
  }

  Padding genderField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: kdPadding, right: kdPadding, bottom: kdPadding),
      child: Row(
        children: [
          Text("Gender :"),
          SizedBox(width: 45),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      visualDensity: VisualDensity.compact,
                      value: _selectedGender.value,
                      groupValue: "male",
                      onChanged: (value) => _selectedGender.value = 'male',
                    ),
                    Text(
                      "Male",
                      style: Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      visualDensity: VisualDensity.compact,
                      value: _selectedGender.value,
                      groupValue: "female",
                      onChanged: (value) => _selectedGender.value = 'female',
                    ),
                    Text(
                      "Female",
                      style: Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  Padding bloodGroupTypeField() {
    return Padding(
      padding: const EdgeInsets.only(left: kdPadding, right: kdPadding, bottom: kdPadding),
      child: Row(
        children: [
          Text("Blood Group:"),
          SizedBox(width: 30),
          Expanded(
            child: Obx(() {
              return DropdownButton<String>(
                alignment: Alignment.center,
                isExpanded: true,
                hint: Text("Select One"),
                value: _selectedBloodGroupType.value.length == 0 ? null : _selectedBloodGroupType.value,
                items: bloodTypes.map((e) => DropdownMenuItem<String>(child: Text(e), value: e)).toList(),
                onChanged: (value) => _selectedBloodGroupType.value = value!,
              );
            }),
          )
        ],
      ),
    );
  }
}
