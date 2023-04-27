import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../controllers/auth_controller.dart';
import 'global_helpers.dart';
import 'mighty_exception.dart';

class ApiHelper {
  postData(String url, [Map<String, dynamic> data = const {}]) async {
    try {
      final String finalUrl = kcBaseAPIUrl + url;
      printApiResponse("Api call --> ${finalUrl}");

      var res = await http.post(Uri.parse(finalUrl), body: data, headers: {'accept': 'application/json'});
      printApiResponse("API :: ${finalUrl} :: Data :: ${data} :: Response :: ${res.body}");
      var body = jsonDecode(res.body);

      if (body['status'] != 200) throw MightyException(body['message']);

      return body;
    } on FormatException catch (e) {
      showMightySnackBar(message: "Unknown Error");
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: "API HELPER ${e.toString()}");
      rethrow;
    }
  }

  getData(String url, [Map<String, dynamic> data = const {}]) async {
    try {
      final String finalUrl = kcBaseAPIUrl + url;

      var res = await http.get(Uri.parse(finalUrl), headers: {'accept': 'application/json'});
      printApiResponse("API :: ${finalUrl} :: Data :: ${data} :: Response :: ${res.body}");
      var body = jsonDecode(res.body);

      if (body['status'] != 200) throw MightyException(body['message']);

      return body;
    } on FormatException catch (e) {
      showMightySnackBar(message: "Unknown Error");
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: "API HELPER");
      rethrow;
    }
  }

  postDataAuthenticated(String url, [Map<String, dynamic> data = const {}]) async {
    try {
      final String finalUrl = kcBaseAPIUrl + url;

      AuthController authController = Get.find();

      var res = await http.post(
        Uri.parse(finalUrl),
        body: data,
        headers: {'accept': 'application/json', 'accesstoken': authController.user.value!.accessToken},
      );
      printApiResponse("API :: ${finalUrl} :: Data :: ${data} :: Response :: ${res.body}");
      var body = jsonDecode(res.body);

      print("STATU CODE :: ${body['status']}");
      if (body['status'] != 200 && body['status'] != null) throw MightyException(body['message'] ?? 'An error occurred.');

      return body;
    } on FormatException catch (e) {
      showMightySnackBar(message: "Unknown Error");
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: "API HELPER");
      rethrow;
    }
  }
}
