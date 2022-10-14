import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color kcPrimaryGradient = Color(0xffFF1313);
Color kcSecondaryGradient = Color(0xffFF6C69);
Color kcBackGroundGradient = Color(0xffF5F5F5);
Color kcSecondaryColor = Color.fromARGB(255, 99, 99, 99);
LinearGradient kcVerticalGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomRight,
  colors: [
    kcPrimaryGradient,
    kcSecondaryGradient,
  ],
);

const kdPadding = 28.0;
const kdBorderRadius = 30.0;
