import 'package:get/get.dart';
import '../models/permision.dart';

import '../models/emergency_contact.dart';
import '../utils/api_helper.dart';
import '../utils/global_helpers.dart';

class PermissionsController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<Permissions?> permissionManager = Rx(null);

  fetchMyPlan() async {
    try {
      isLoading(true);
      var response = await ApiHelper().postDataAuthenticated('viewYourPlan');

      permissionManager.value = Permissions(currentPlan: response['data'][0]['plan_title']);
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  bool canAddContact(List<EmergencyContact> contacts) {
    if (permissionManager.value == null) return false;

    if (permissionManager.value!.planType == PlanType.Basic && contacts.length < 5) return true;

    if (permissionManager.value!.planType == PlanType.Basic && contacts.length < 5) return true;

    if (permissionManager.value!.planType == PlanType.Premium && contacts.length < 5) return true;

    if (permissionManager.value!.planType == PlanType.FamilyPlan && contacts.length < 5) return true;

    return false;
  }
}
