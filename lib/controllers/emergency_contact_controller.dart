import 'package:get/get.dart';
import '../models/admin_contact.dart';
import 'auth_controller.dart';
import 'payment_controller.dart';
import 'permissions_controller.dart';
import '../models/emergency_contact.dart';
import '../utils/global_helpers.dart';

import '../utils/api_helper.dart';

class EmergencyContactController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isContactBeingAdded = false.obs;
  RxList<EmergencyContact> contacts = RxList([]);
  Rx<AdminContacts?> adminContacts = Rx(null);

  fetchEmergencyContacts() async {
    try {
      isLoading(true);
      var response = await ApiHelper().postDataAuthenticated('getContacts', {});

      contacts.value = EmergencyContact.listFromMap(response['data'] == null ? [] : response['data']);
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  fetchAdminContacts(String type, [String city = '']) async {
    try {
      isLoading(true);
      var response = await ApiHelper().postDataAuthenticated('emergencyContacts', {'type': type});
      adminContacts.value = AdminContacts.fromJson(response);
      if (city.length != 0) {
        adminContacts.value!.contacts = adminContacts.value!.contacts.where((element) => element.city == city).toList();
      }
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  addContact({required String name, required String number, required String address, required String email, required String type}) async {
    try {
      isContactBeingAdded(true);

      await ApiHelper().postDataAuthenticated('addContact', {
        'name': name,
        'contact': number,
        'address': address,
        'email': email,
        'type': type,
      });

      Get.back();
      showMightySnackBar(message: "Contact added successfully.");
      this.fetchEmergencyContacts();
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isContactBeingAdded(false);
    }
  }

  updateContact({required String name, required String number, required String id, required String address, required String email, required String type}) async {
    try {
      isContactBeingAdded(true);
      await ApiHelper().postDataAuthenticated('editContact', {
        'name': name,
        'contact': number,
        'address': address,
        'email': email,
        'type': type,
        'id': id,
      });

      Get.back();
      showMightySnackBar(message: "Contact update successfully.");
      this.fetchEmergencyContacts();
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isContactBeingAdded(false);
    }
  }
}
