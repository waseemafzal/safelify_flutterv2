import 'package:get/get.dart';

import '../models/chat.dart';
import '../utils/api_helper.dart';
import '../utils/global_helpers.dart';

class ChatController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Chat?> chat = Rx(null);

  fetchInitialChat() async {
    try {
      isLoading(true);
      DateTime dateTime = DateTime.now();
      String timezone = dateTime.timeZoneName;

      var response = await ApiHelper().postDataAuthenticated('messages', {
        'receiverId': '1',
        'timezone': timezone,
      });
      chat.value = Chat.fromMap(response);
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  refreshChat() async {
    try {
      DateTime dateTime = DateTime.now();
      String timezone = dateTime.timeZoneName;

      var response = await ApiHelper().postDataAuthenticated('messages', {
        'receiverId': '1',
        'timezone': timezone,
      });
      chat.value = Chat.fromMap(response);
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {}
  }

  sendMessage(String message, receiverId) async {
    try {
      isLoading(true);
      var response = await ApiHelper().postDataAuthenticated('chat', {
        'message': message,
        'receiverId': receiverId,
      });
      this.refreshChat();
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }
}
