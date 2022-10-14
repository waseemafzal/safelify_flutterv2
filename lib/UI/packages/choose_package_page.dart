import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../main_page.dart';
import '../../controllers/payment_controller.dart';
import '../../models/plan.dart';
import '../../utils/global_helpers.dart';

import '../styles/styles.dart';
import '../widgets/app_bar.dart';

class ChoosePackagePage extends StatelessWidget {
  ChoosePackagePage({super.key});

  final PaymentController _paymentController = Get.find()
    ..fetchPlans()
    ..fetchMyPlan();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: getAppBar(context: context),
      body: Obx(
        () {
          return _paymentController.isLoading.value
              ? getLoading()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Choose Package",
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kdPadding + 10),
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Your current plan is  ",
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.end,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              '${_paymentController.mySubscription.value}',
                              style: TextStyle(color: kcPrimaryGradient, fontWeight: FontWeight.bold, fontSize: 18.sp),
                            )
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: _paymentController.plans.length,
                        itemBuilder: (context, index) {
                          Plan plan = _paymentController.plans[index];
                          return PackageCard(
                            plan: plan,
                          );
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  PackageCard({
    Key? key,
    required this.plan,
  }) : super(key: key);

  final Plan plan;
  final PaymentController _paymentController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kdPadding.w, vertical: 7.h),
      child: InkWell(
        onTap: () => _paymentController.subscribeToPlan(plan.planId),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(color: Colors.white, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16.h,
                decoration: BoxDecoration(
                  color: plan.name == _paymentController.mySubscription.value ? kcPrimaryGradient : Colors.grey[400],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2.r),
                    topRight: Radius.circular(2.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 15.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan.name,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        Text(
                          plan.price,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                    // SizedBox(height: 20.h),
                    Html(data: plan.description)
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
