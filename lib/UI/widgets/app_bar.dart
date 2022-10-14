import 'package:flutter/material.dart';

AppBar getAppBar({
  required BuildContext context,
  Color? color,
  Widget? leading,
  Text? title,
  Color iconColor = Colors.black,
  List<Widget> actions = const [],
}) {
  Color? bcColor = color ?? Theme.of(context).backgroundColor;

  return AppBar(
    elevation: 0.0,
    backgroundColor: bcColor,
    leading: leading,
    title: title,
    centerTitle: true,
    iconTheme: IconThemeData(color: iconColor),
    actions: actions,
  );
}
