import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MightyPopupDialogue extends StatelessWidget {
  final List<Widget> content;
  const MightyPopupDialogue({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 1.0,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      content: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: content,

          // [
          //   Container(
          //     height: 40,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(20),
          //       border: Border.all(
          //         color: Colors.black,
          //       ),
          //     ),
          //     child: Center(
          //       child: Text(
          //         "Kidnapping",
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     height: 10,
          //   ),
          //   Container(
          //     height: 40,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(20),
          //       border: Border.all(
          //         color: Colors.black,
          //       ),
          //     ),
          //     child: Center(
          //       child: Text(
          //         "Accident",
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     height: 10,
          //   ),
          //   Container(
          //     height: 40,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(20),
          //       border: Border.all(
          //         color: Colors.black,
          //       ),
          //     ),
          //     child: Center(
          //       child: Text(
          //         "Road Robbery",
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     height: 10,
          //   ),
          //   Stack(
          //     children: [
          //       Image.asset("assets/images/Rectangle 4.png"),
          //       Positioned.fill(
          //         child: Align(
          //           alignment: Alignment.center,
          //           child: Text(
          //             "Assault",
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ],
        ),
      ),
    );
  }

  // Future<String?> OpenDialog() => showDialog<String>(
  //       context: context,
  //       builder: (context) =>
  //     );
}
