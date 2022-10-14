import 'package:get/get.dart';
import '../models/notification.dart';

import '../utils/api_helper.dart';
import '../utils/global_helpers.dart';

class NotificationsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Notification> notifications = RxList();

  fechNotifications() async {
    try {
      isLoading(true);
      var response = await ApiHelper().postDataAuthenticated('getNotifications', {});
      notifications.value = Notification.listFromMap(response['data']);
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }
}
