import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/styles.dart';

class MightyTextField extends StatelessWidget {
  const MightyTextField({
    Key? key,
    required this.placeHolder,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.suffix,
    this.withBottomPadding = true,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);

  final String placeHolder;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffix;
  final bool withBottomPadding;
  final void Function()? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kdPadding.w),
          child: GestureDetector(
            onTap: onTap,
            child: TextFormField(
              enabled: enabled,
              validator: validator,
              controller: controller,
              cursorColor: kcSecondaryGradient,
              obscureText: obscureText,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                hintText: placeHolder,
                hintStyle: TextStyle(fontSize: 11.sp, color: Colors.black),
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.circular(kdBorderRadius),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(kdBorderRadius),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.circular(kdBorderRadius),
                ),
                focusColor: kcPrimaryGradient,
                suffix: suffix,
              ),
            ),
          ),
        ),
        SizedBox(height: withBottomPadding ? 36.h : 0),
      ],
    );
  }
}
