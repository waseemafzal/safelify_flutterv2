import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_lify/controllers/auth_controller.dart';
import 'package:safe_lify/utils/api_helper.dart';
import 'package:safe_lify/utils/global_helpers.dart';
import '../styles/styles.dart';
import '../widgets/app_bar.dart';
import '../widgets/mighty_button.dart';

class BecomeReporterPage extends StatelessWidget {
  BecomeReporterPage({super.key});
  final RxString _selectedOption = 'no'.obs;

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: kcPrimaryGradient),
        title: Text(
          "Reporter",
          style: TextStyle(
            color: kcPrimaryGradient,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kdPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You can become a guest reporter with safelify and be compensated for good stories submitted.",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: kdPadding),
            Text(
              "Want to become a reporter?",
              style: Theme.of(context).textTheme.headline1,
            ),
            Obx(() {
              return Row(
                children: [
                  Radio(
                      value: _selectedOption.value,
                      groupValue: 'yes',
                      onChanged: (value) {
                        _selectedOption.value = 'yes';
                      }),
                  SizedBox(width: 10),
                  Text("Yes", style: Theme.of(context).textTheme.headline2),
                ],
              );
            }),
            Obx(() {
              return Row(
                children: [
                  Radio(
                      value: _selectedOption.value,
                      groupValue: 'no',
                      onChanged: (value) {
                        _selectedOption.value = 'no';
                      }),
                  SizedBox(width: 10),
                  Text("No", style: Theme.of(context).textTheme.headline2),
                ],
              );
            }),
            SizedBox(height: kdPadding),
            Obx(() {
              return _authController.isLoading.value
                  ? getLoading()
                  : MightyButton(
                      text: "Submit Request",
                      onTap: () {
                        _authController.becomeReporter(value: _selectedOption.value);
                      },
                    );
            })
          ],
        ),
      ),
    );
  }
}
