import 'dart:async';

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

    if (permissionManager.value!.planType == PlanType.Free) return false;

    return true;
  }

  bool canAccessInternationalServices() {
    if (permissionManager.value == null) return false;

    if (permissionManager.value!.planType != PlanType.Diaspora) return false;

    return true;
  }

  bool canNotifyContacts(String requestType) {
    // Workplace emergency is only for business
    print("Requesting canNotifyContacts for :: ${requestType}");
    if (this._workPlaceEmergency(requestType) && permissionManager.value!.planType != PlanType.Business) return false;

    if (permissionManager.value == null) return false;
    if (permissionManager.value!.planType == PlanType.Free) return false;
    if (permissionManager.value!.planType == PlanType.Basic) return false;

    return true;
  }

  bool canRequestForImmediateHelp(String requestType) {
    // Workplace emergency is only for business
    print("Requesting canRequestForImmediateHelp for :: ${requestType}");
    if (this._workPlaceEmergency(requestType) && permissionManager.value!.planType != PlanType.Business) return false;

    if (permissionManager.value == null) return false;
    if (permissionManager.value!.planType == PlanType.Free) return false;
    if (permissionManager.value!.planType == PlanType.Basic) return false;

    return true;
  }

  bool _workPlaceEmergency(String type) {
    if (type == 'Workplace Accident' || type == 'Medical Emergencies' || type == 'Cyber Emergencies' || type == 'Physical Attack' || type == 'Legal Emergencies') {
      return true;
    }

    return false;
  }
}
