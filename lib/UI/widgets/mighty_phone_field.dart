import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../styles/styles.dart';

class MightyPhoneField extends StatelessWidget {
  const MightyPhoneField({
    super.key,
    this.controller,
    this.validator,
  });
  final TextEditingController? controller;
  final FutureOr<String?>? Function(PhoneNumber?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: kdPadding),
      child: IntlPhoneField(
        disableLengthCheck: true,
        controller: controller,
        validator: validator,
        // flagsButtonMargin: EdgeInsets.symmetric(horizontal: 10),

        showDropdownIcon: false,
        showCountryFlag: false,
        dropdownTextStyle: TextStyle(fontSize: 12),
        flagsButtonPadding: EdgeInsets.only(left: 10),
        pickerDialogStyle: PickerDialogStyle(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 10),
          hintText: 'Mobile',
          hintStyle: TextStyle(fontSize: 12),
          alignLabelWithHint: true,
          // fillColor: kcGreyColor,
          // filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.circular(kdBorderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.circular(kdBorderRadius),
          ),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(kdBorderRadius),
          //   borderSide: BorderSide.none,
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(kdBorderRadius),
          //   borderSide: BorderSide(color: kcSecondaryColor),
          // ),
        ),
        initialCountryCode: 'PK',
        onChanged: (phone) {
          print(phone.completeNumber);
        },
      ),
    );
  }
}
