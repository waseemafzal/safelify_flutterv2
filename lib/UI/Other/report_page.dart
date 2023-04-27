import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_lify/controllers/app_controller.dart';
import '../../models/report_category.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/global_helpers.dart';

import '../../controllers/report_controller.dart';
import '../styles/styles.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Rx<File?> selectFile = Rx(null);

  AuthController _authController = Get.find();

  ReportController _reportController = Get.find()..fetchReportCategories();

  GlobalKey<FormState> _form = GlobalKey();

  TextEditingController _reportEditingController = TextEditingController();

  final Rx<ReportCategory?> _selectedCategory = Rx(null);

  @override
  void initState() {
    super.initState();
    _reportController.fetchReportCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Report',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.grey.shade100,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: kcPrimaryGradient),
            onPressed: () {
              AppController appController = Get.find();
              appController.currentBottomNavIndex.value = 0;
              // appController.currentBottomNavIndex.refresh();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(children: [
            SizedBox(
              height: 30.h,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), border: Border.all(color: Colors.grey), shape: BoxShape.rectangle),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: AssetImage('assets/images/avatar.png'),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "${_authController.user.value!.name}",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("Category :"),
                        SizedBox(width: 10),
                        Expanded(
                          child: Obx(() {
                            return DropdownButton<ReportCategory>(
                              isExpanded: true,
                              value: _selectedCategory.value,
                              hint: Text("Select a category"),
                              items: _reportController.categories
                                  .map(
                                    (element) => DropdownMenuItem<ReportCategory>(
                                      value: element,
                                      child: Text(element.category),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                _selectedCategory.value = value;
                              },
                            );
                          }),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _form,
                            child: TextFormField(
                              controller: _reportEditingController,
                              maxLines: 4,
                              decoration: InputDecoration(border: InputBorder.none, hintText: 'Enter Text...'),
                            ),
                          ),
                        ) /*Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Enter Text....',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black12),
                        ),
                      ),*/
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return _reportController.isLoading.value
                          ? getLoading()
                          : Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (_form.currentState!.validate()) {
                                      await _reportController.addReport(selectFile.value, _reportEditingController.text, _authController.user.value!.accessToken, _selectedCategory.value!.id);
                                      _reportEditingController.clear();
                                      selectFile.value = null;
                                    }
                                  },
                                  child: Container(
                                    height: 35.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: kcPrimaryGradient,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: Text(
                                          'Post',
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Obx(() {
                                  return selectFile.value == null
                                      ? SizedBox()
                                      : Expanded(
                                          child: Text(
                                            "${selectFile.value!.path.split('/')[selectFile.value!.path.split('/').length - 1]}",
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        );
                                }),
                                SizedBox(width: 5.w),
                                GestureDetector(
                                  onTap: () async {
                                    XFile? result = await ImagePicker.platform.getVideo(source: ImageSource.camera);

                                    if (result != null) {
                                      File file = File(result.path);
                                      selectFile.value = file;
                                    } else {}
                                  },
                                  child: Image.asset(
                                    'assets/icons/camera_icon.png',
                                    height: 19.h,
                                    width: 19.w,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 15.w,
                                // ),
                                // Image.asset(
                                //   'assets/icons/headphone_icon.png',
                                //   height: 19.h,
                                //   width: 19.w,
                                // ),
                                // SizedBox(
                                //   width: 10,
                                // ),
                              ],
                            );
                    })
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
