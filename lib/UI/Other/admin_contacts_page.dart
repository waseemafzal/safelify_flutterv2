import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../models/admin_contact.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/config.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/emergency_contact_controller.dart';
import '../../models/emergency_contact.dart';
import '../../utils/global_helpers.dart';
import '../styles/styles.dart';

class AdminContactsPage extends StatefulWidget {
  AdminContactsPage({Key? key, required this.contactType}) : super(key: key);

  final String contactType;

  @override
  State<AdminContactsPage> createState() => _AdminContactsPageState();
}

class _AdminContactsPageState extends State<AdminContactsPage> {
  final EmergencyContactController _emergencyContactController = Get.find();

  @override
  void initState() {
    _emergencyContactController.fetchAdminContacts(widget.contactType);
    super.initState();
  }

  final RefreshController _refreshController = RefreshController();
  RxString currentCity = ''.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          title: Text(
            "${widget.contactType.capitalize} Contacts",
            style: TextStyle(
              color: kcPrimaryGradient,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          iconTheme: IconThemeData(color: kcPrimaryGradient),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Obx(() {
                  return PopupMenuButton(
                      child: Container(
                        child: Chip(
                          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.w),
                          label: Text(currentCity.value.length == 0 ? "Cities" : currentCity.value),
                          labelStyle: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      itemBuilder: (context) {
                        return _emergencyContactController.adminContacts.value!.cities
                            .map(
                              (e) => PopupMenuItem(
                                onTap: () {
                                  if (currentCity.value == e.city) {
                                    currentCity.value = '';
                                    _emergencyContactController.fetchAdminContacts(widget.contactType, e.city);
                                    return;
                                  }
                                  currentCity.value = e.city;
                                  _emergencyContactController.fetchAdminContacts(widget.contactType, e.city);
                                },
                                child: Text(e.city),
                              ),
                            )
                            .toList();
                      });
                }),
              ),
            ),
            Obx(() {
              return _emergencyContactController.isLoading.value
                  ? getLoading()
                  : _emergencyContactController.adminContacts.value!.contacts.length == 0
                      ? Expanded(child: Center(child: Text("Not Contacts Found")))
                      : Expanded(
                          child: SmartRefresher(
                            controller: _refreshController,
                            onRefresh: () {
                              _emergencyContactController.fetchAdminContacts(widget.contactType);
                            },
                            child: ListView.builder(
                                padding: EdgeInsets.all(kdPadding - 10),
                                itemCount: _emergencyContactController.adminContacts.value!.contacts.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return EmergencyContactCard(contact: _emergencyContactController.adminContacts.value!.contacts[index]);
                                }),
                          ),
                        );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String text, bool isSelected, void Function() onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 90.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? kcPrimaryGradient : Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Text(
                text,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: isSelected ? Colors.white : null),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyContactCard extends StatelessWidget {
  EmergencyContactCard({
    Key? key,
    required this.contact,
  }) : super(key: key);
  final Contact contact;

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('${contact.image}'),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  contact.contact,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color: Colors.grey),
                ),
                SizedBox(
                  height: 7.h,
                ),
                GestureDetector(
                  onTap: () {
                    if (contact.email != 'Not Provided') {
                      launchUrl(Uri.parse('mailto:${contact.email}'));
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 15,
                        color: Color(0xff434444),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        contact.email,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.black54),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      contact.address,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Color(0xff434444)),
                    )
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse('tel:${contact.contact}'));
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), shape: BoxShape.circle),
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      'assets/icons/phone.png',
                      height: 15.h,
                      width: 15.w,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
