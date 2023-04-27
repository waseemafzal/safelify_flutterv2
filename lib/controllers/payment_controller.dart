import 'package:get/get.dart';

import '../UI/packages/verify_payment_page.dart';
import '../models/plan.dart';
import '../utils/api_helper.dart';
import '../utils/global_helpers.dart';

class PaymentController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<Plan> plans = RxList();
  RxMap<String, dynamic> subscription = RxMap();

  RxString mySubscription = ''.obs;

  fetchPlans() async {
    try {
      isLoading(true);
      var response = await ApiHelper().postDataAuthenticated('getPlans', {});
      plans.value = Plan.listFromMap(response['data']);
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  subscribeToPlan(String planId) async {
    if (planId == '1') return;
    try {
      isLoading(true);

      var response = await ApiHelper().postDataAuthenticated('paystackSubscription', {
        'plan_id': planId,
      });
      subscription.value = RxMap.from(response);
      Get.to(() => VerifyPaymentPage());
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  verifyPayment() async {
    try {
      isLoading(true);
      var response = await ApiHelper().getData('verify?reference=${subscription['reference']}', {});
      showMightySnackBar(message: response['message']);
      subscription.value = {};
      await this.fetchMyPlan();
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  fetchMyPlan() async {
    try {
      isLoading(true);
      var response = await ApiHelper().postDataAuthenticated('viewYourPlan');

      mySubscription.value = response['data'][0]['plan_title'];
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }
}
