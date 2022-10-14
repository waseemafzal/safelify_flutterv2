import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_bar.dart';
import '../../controllers/payment_controller.dart';
import 'package:webviewx/webviewx.dart';

class VerifyPaymentPage extends StatelessWidget {
  VerifyPaymentPage({super.key});

  final PaymentController _paymentController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _paymentController.verifyPayment();
        return true;
      },
      child: Scaffold(
        appBar: getAppBar(context: context),
        body: WebViewX(
          initialContent: _paymentController.subscription['authorization_url'],
          width: Get.width,
          height: Get.height,
        ),
      ),
    );
  }
}
