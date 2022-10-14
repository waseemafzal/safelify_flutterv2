import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/styles.dart';

class MightyButtonOutlined extends StatelessWidget {
  MightyButtonOutlined({
    Key? key,
    required this.text,
    required this.onTap,
    this.backgroundGradient = kcPrimaryGradient,
  }) : super(key: key);

  final String text;
  final void Function() onTap;
  Color? backgroundGradient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kdBorderRadius),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kdBorderRadius),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
