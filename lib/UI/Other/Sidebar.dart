import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/styles.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 227, 227),
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          elevation: 5,
          backgroundColor: Color.fromARGB(255, 240, 240, 240),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 22.0,
                  left: 22.0,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/icons/safe_life_text.png"),
                    CircleAvatar(
                        backgroundColor: kcPrimaryGradient,
                        radius: 15,
                        child: Center(
                            child: Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.white,
                        ))),
                  ],
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Container(
                margin: EdgeInsets.only(right: 50.w),
                decoration: BoxDecoration(
                    color: kcPrimaryGradient,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/community.png"),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Community",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 22.0),
                child: Column(
                  children: [
                    CustomListTile(
                      image: "assets/icons/report.png",
                      text: "Report",
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomListTile(
                      image: "assets/icons/legal.png",
                      text: "Legal Support",
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomListTile(
                      image: "assets/icons/medical_assistance.png",
                      text: "Medical Support",
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomListTile(
                      image: "assets/icons/road_assistance.png",
                      text: "Road Assistance",
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomListTile(
                      image: "assets/icons/contact.png",
                      text: "Contact us",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String text;
  // final String image;
  final String image;
  final void Function()? onTap;
  final bool isSelected;
  const CustomListTile({
    Key? key,
    required this.image,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        splashColor: Colors.white,
        onTap: onTap,
        child: Container(
          height: 37.h,
          color: isSelected ? null : kcPrimaryGradient,
          child: Row(
            children: [
              Image.asset(
                image,
                height: 18.h,
                width: 18.w,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              SizedBox(
                width: 5.w,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
