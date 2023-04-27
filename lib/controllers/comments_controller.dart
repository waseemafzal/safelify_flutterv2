import 'package:get/get.dart';

import '../models/get_comments.dart';
import '../utils/api_helper.dart';
import '../utils/global_helpers.dart';

class CommentsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Comment> comments = RxList([]);

  getComments(report_id) async {
    try {
      isLoading(true);
      var resp = await ApiHelper().postData('getComments', {
        'report_id': report_id,
      });
      comments.value = Comment.listFromMap(resp['data']);
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  addComments(body, report_id) async {
    try {
      isLoading(true);
      var resp = await ApiHelper().postDataAuthenticated('postComment', {
        'body': body,
        'report_id': report_id,
      });
      showMightySnackBar(message: resp['message']);
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  updateComments({required String id, required String body}) async {
    try {
      isLoading(true);
      var resp = await ApiHelper().postDataAuthenticated('editComment', {
        'id': id,
        'body': body,
      });
      for (int i = 0; i < comments.length; i++) {
        if (comments[i].id == id) {
          comments[i].body = body;
        }
      }
      comments.refresh();
      showMightySnackBar(message: resp['message']);
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  deleteComments(id) async {
    try {
      isLoading(true);
      var resp = await ApiHelper().postDataAuthenticated('deleteComment', {
        'id': id,
      });
      // getCommentsModel.value = GetCommentsModel.fromJson(resp);
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }
}
