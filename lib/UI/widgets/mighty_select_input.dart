import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/styles.dart';

class MightySelectInput extends StatelessWidget {
  MightySelectInput({
    Key? key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.validator,
    this.value,
  }) : super(key: key);

  final String hintText;
  final List<DropdownMenuItem<String>> items;
  final void Function(dynamic) onChanged;
  final String? Function(String?)? validator;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: kdPadding.w),
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kdBorderRadius.r),
            border: Border.all(
              color: Colors.black45,
            ),
          ),
          child: DropdownButton(
            style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.black87, fontSize: 12.sp),
            underline: SizedBox(),
            onChanged: onChanged,
            // showSelectedItem: false,
            isExpanded: true,
            value: value,
            hint: Text("Type"),
            items: items,
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
