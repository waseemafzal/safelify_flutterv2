import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:safe_lify/controllers/permissions_controller.dart';
import '../widgets/mighty_select_input.dart';
import '../../controllers/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/emergency_contact_controller.dart';
import '../../models/emergency_contact.dart';
import '../../utils/global_helpers.dart';
import '../styles/styles.dart';
import '../widgets/mighty_button.dart';
import '../widgets/mighty_text_field.dart';
import 'popUp.dart';

class EmergencyContactPage extends StatelessWidget {
  EmergencyContactPage({Key? key}) : super(key: key);

  final EmergencyContactController _emergencyContactController = Get.find()..fetchEmergencyContacts();
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Emergency Contact",
            style: TextStyle(
              color: Colors.red,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: Obx(() {
          return _emergencyContactController.isLoading.value
              ? getLoading()
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () {
                    _emergencyContactController.fetchEmergencyContacts();
                  },
                  child: ListView.builder(
                      padding: EdgeInsets.all(kdPadding - 10),
                      itemCount: _emergencyContactController.contacts.length == 0 ? 1 : _emergencyContactController.contacts.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (_emergencyContactController.contacts.length == 0) return _buildAddContactButton(context);

                        if (index == _emergencyContactController.contacts.length - 1) {
                          return Column(
                            children: [
                              EmergencyContactCard(contact: _emergencyContactController.contacts[index]),
                              SizedBox(
                                height: 20,
                              ),
                              _buildAddContactButton(context)
                            ],
                          );
                        }
                        return EmergencyContactCard(contact: _emergencyContactController.contacts[index]);
                      }),
                );
        }),
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

  _buildAddContactButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!Get.find<PermissionsController>().canAddContact(_emergencyContactController.contacts)) {
          showUpgradeAccountDialogue(context);
          return;
        }
        await showAddUpdateContactPopup(context: context);
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(11)),
        height: 40,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              "Add",
              style: TextStyle(fontSize: 16, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

showAddUpdateContactPopup({required BuildContext context, EmergencyContact? contact}) async {
  await showDialog(
    context: context,
    builder: (context) {
      final GlobalKey<FormState> addContactForm = GlobalKey();
      final TextEditingController contactNameEditingController = TextEditingController(text: contact == null ? null : contact.name);
      final TextEditingController contactNumberEditingController = TextEditingController(text: contact == null ? null : contact.contact);
      final TextEditingController addressEditingController = TextEditingController(text: contact == null ? null : contact.address);
      final TextEditingController emailEditingController = TextEditingController(text: contact == null ? null : contact.email);

      EmergencyContactController _emergencyContactController = Get.find();

      return StatefulBuilder(builder: (context, update) {
        return Form(
          key: addContactForm,
          child: MightyPopupDialogue(
            content: [
              SizedBox(height: 15.h),
              Text(
                "${contact == null ? 'Add' : 'Edit'} Emergency Contact",
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(height: 15.h),
              MightyTextField(
                placeHolder: "Name",
                controller: contactNameEditingController,
                validator: (value) => contactNameEditingController.text.length == 0 ? "Please enter contact number." : null,
              ),
              MightyTextField(
                placeHolder: "Contact Number",
                controller: contactNumberEditingController,
                validator: (value) => contactNumberEditingController.text.length != 11 ? "Contact number must be 11 digits" : null,
              ),
              MightyTextField(
                placeHolder: "Email",
                controller: emailEditingController,
                validator: (value) => GetUtils.isEmail(emailEditingController.text) ? null : 'Invalid email address.',
              ),
              MightyTextField(
                placeHolder: "Address",
                controller: addressEditingController,
                validator: (value) => addressEditingController.text.length == 0 ? "Please enter address" : null,
              ),
              // MightySelectInput(
              //   hintText: "Contact type",
              //   value: contactType,
              //   items: [
              //     DropdownMenuItem(
              //       child: Text("Legal Support"),
              //       value: 'legal',
              //     ),
              //     DropdownMenuItem(
              //       child: Text("Medical Support"),
              //       value: 'medical',
              //     ),
              //     DropdownMenuItem(
              //       child: Text("Road Assistance"),
              //       value: 'road',
              //     ),
              //   ],
              //   onChanged: (value) {
              //     update(() {
              //       contactType = value;
              //     });
              //   },
              // ),
              Padding(
                padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 20.h),
                child: Obx(() {
                  return _emergencyContactController.isContactBeingAdded.value
                      ? getLoading()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MightyButton(
                                text: "Cancel",
                                onTap: () => Get.back(),
                                backgroundGradient: kcSecondaryColor,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: MightyButton(
                                text: "${contact == null ? 'Add' : 'Edit'}",
                                onTap: () {
                                  if (addContactForm.currentState!.validate()) {
                                    if (contact == null) {
                                      _emergencyContactController.addContact(
                                        name: contactNameEditingController.text,
                                        number: contactNumberEditingController.text,
                                        address: addressEditingController.text,
                                        email: emailEditingController.text,
                                        type: 'contactType',
                                      );
                                    } else {
                                      _emergencyContactController.updateContact(
                                        name: contactNameEditingController.text,
                                        number: contactNumberEditingController.text,
                                        address: addressEditingController.text,
                                        email: emailEditingController.text,
                                        type: 'contactType',
                                        id: contact.id,
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                }),
              )
            ],
          ),
        );
      });
    },
  );
}

class EmergencyContactCard extends StatelessWidget {
  EmergencyContactCard({
    Key? key,
    required this.contact,
  }) : super(key: key);
  final EmergencyContact contact;

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
              backgroundImage: NetworkImage(
                contact.image ?? '',
              ),
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
                GestureDetector(
                  onTap: () {
                    showAddUpdateContactPopup(context: context, contact: contact);
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.red, fontSize: 14, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
