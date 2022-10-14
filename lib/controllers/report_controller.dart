import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../models/get_community_reports_model.dart';
import '../utils/api_helper.dart';
import '../utils/global_helpers.dart';
import 'auth_controller.dart';

class ReportController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isCorroborating = false.obs;

  RxList<CommunityReport> communityReports = RxList([]);

  addReport(File? imageFile, String title, token) async {
    // open a bytestream
    try {
      isLoading(true);
      var uri = Uri.parse("${kcBaseAPIUrl}postReport");
      var request = new http.MultipartRequest("POST", uri);
      if (imageFile != null) {
        var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        // get file length
        var length = await imageFile.length();
        var multipartFile = new http.MultipartFile('file', stream, length, filename: imageFile.path);

        request.files.add(multipartFile);
      }

      // string to uri

      // create multipart request
      request.headers["accesstoken"] = token;
      // multipart that takes file

      // add file to multipart
      request.fields['title'] = title;
      // request.
      // send
      var response = await request.send();
      print(response.statusCode);
      showMightySnackBar(message: 'Report added');
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  fetchCommunityReports({
    bool loadMine = false,
    String city = '',
  }) async {
    try {
      isLoading(true);
      communityReports.clear();
      var resp = await ApiHelper().getData('getCommunityReports');

      communityReports.value = CommunityReport.listFromMap(resp['data']);

      if (loadMine) {
        AuthController authController = Get.find();
        communityReports.value = this.communityReports.where((element) => element.userId == authController.user.value!.userId).toList();
      } else if (city.length > 0) {
        communityReports.value = this.communityReports.where((element) => element.city == city || element.city.length == 0).toList();
      }
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  corroborate({required String id, required String status}) async {
    try {
      isCorroborating(true);
      var resp = await ApiHelper().postDataAuthenticated('reportStatus', {
        'report_id': id,
        'status': status,
      });
      showMightySnackBar(message: resp['message']);
    } catch (e) {
    } finally {
      isCorroborating(false);
    }
  }

  List<CommunityReport> get allReports {
    return this.allReports.toList();
  }
}
