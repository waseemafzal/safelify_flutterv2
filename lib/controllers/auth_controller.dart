import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restart_app/restart_app.dart';
import 'package:safe_lify/UI/packages/choose_package_page.dart';
import 'package:safe_lify/UI/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../UI/Other/report_page.dart';
import '../UI/auth/login_page.dart';
import '../UI/main_page.dart';
import '../config/config.dart';
import '../models/permision.dart';
import '../models/user.dart';
import '../utils/api_helper.dart';
import '../utils/global_helpers.dart';
import '../utils/mighty_exception.dart';
import 'permissions_controller.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRequestingHelp = false.obs;
  Rx<User?> user = Rx(null);
  ConnectivityResult _currentConnection = ConnectivityResult.none;

  AuthController() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      printApiResponse("Connection Changed :: ${result}");
      this._currentConnection = result;
    });
  }

  register({
    required String name,
    required String email,
    required String password,
    required String mobile,
    required String bloodGroup,
    required String dob,
    required String allergies,
    required String gender,
    required String healthConditions,
    required String modelOfVehicle,
    required String medications,
    required String medicalInsurance,
    required String vehicleInsurance,
    required String nextOfKin,
    required String country,
  }) async {
    try {
      isLoading(true);
      final fcmToken = await FirebaseMessaging.instance.getToken();
      var response = await ApiHelper().postData('signup', {
        'name': name,
        'email': email,
        'password': password,
        'mobile': mobile,
        'image': '',
        'devicetype': 'android',
        'device_id': fcmToken,
        'plan_id': '1',
        'dob': dob,
        'allergies': allergies,
        'gender': gender,
        'health_conditions': healthConditions,
        'year': DateFormat('${DateFormat.YEAR}').format(DateTime.now()),
        'model_of_vehicle': modelOfVehicle,
        'medications': medications,
        'medical_insurance': medicalInsurance,
        'vehicle_insurance': vehicleInsurance,
        'next_of_kin': nextOfKin,
        'country': country,
      });
      Get.to(() => LoginPage());
      showMightySnackBar(message: response['message']);
    } on MightyException catch (e) {
      showMightySnackBar(message: e.toString());
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  forgotPassword({required String email}) async {
    try {
      isLoading(true);
      var response = await ApiHelper().postData('forgotPassword', {
        'email': email,
      });
      Get.to(() => LoginPage());
      showMightySnackBar(message: response['message']);
    } on MightyException catch (e) {
      showMightySnackBar(message: e.toString());
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  login({required String email, required String password}) async {
    try {
      isLoading(true);

      Position location = await _getGeoLocationPosition();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (_currentConnection == ConnectivityResult.none || _currentConnection == ConnectivityResult.bluetooth) {
        user.value = User.fromMap(await getAuthDataFromLocalStorage());
      } else {
        var response = await ApiHelper().postData('login', {
          'email': email,
          'password': password,
          'devicetype': 'android',
          'device_id': fcmToken,
          'social_type': 'normal',
          'latitude': location.longitude.toString(),
          'longitude': location.latitude.toString(),
        });
        user.value = User.fromMap(response);
        user.value!.password = password;
        PermissionsController permissionsController = Get.find();
        permissionsController.fetchMyPlan();
      }

      await storeAuthData(user.value!.toMap());

      isLoading(false);

      Get.offAll(() => MainPage());
      if (await isFirstTimeLogin()) {
        Get.to(() => ChoosePackagePage());
      }
      // showMightySnackBar(message: response['message']);
    } on MightyException catch (e) {
      showMightySnackBar(message: e.toString());
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<bool> attemptLogin({required String email, required String password}) async {
    await this.login(email: email, password: password);

    if (user.value == null) return false;
    return true;
  }

  logOut() async {
    var box = GetStorage();
    await box.erase();
    this.user.value = null;
    // Future.delayed(Duration(seconds: 1));
    // Restart.restartApp();
    Get.offAll(() => LoginPage());
  }

  requestHelp({
    required String requestType,
    required String description,
    String? successMessage,
  }) async {
    try {
      if (_currentConnection == ConnectivityResult.bluetooth || _currentConnection == ConnectivityResult.none) {
        final box = GetStorage();
        final Position position = await _getGeoLocationPosition();
        String divider = GetPlatform.isIOS ? '&' : '?';
        final uri = Uri.parse('sms:${user.value!.sms_to}${divider}body=I have an ${requestType} emergency. Please send help asap!. Location is ${position.latitude}, ${position.longitude}');

        if (await canLaunchUrl(uri)) {
          launchUrl(uri);
          return;
        }
      }
      isRequestingHelp(true);
      Position position = await _getGeoLocationPosition();
      var response = await ApiHelper().postDataAuthenticated(
        'requestHelp',
        {
          'request_type': requestType,
          'description': description,
          'latlon': '${position.latitude},${position.longitude}',
        },
      );
      Get.back();
      showMightySnackBar(message: successMessage ?? response['message']);
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isRequestingHelp(false);
    }
  }

  updateProfile({required String name, required String phone, required String address, XFile? image, required String password}) async {
    try {
      isLoading(true);
      var uri = Uri.parse("${kcBaseAPIUrl}updateProfile");
      var request = new http.MultipartRequest("POST", uri);
      if (image != null) {
        var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
        // get file length
        var length = await image.length();
        var multipartFile = new http.MultipartFile('image', stream, length, filename: image.path);

        request.files.add(multipartFile);

        printApiResponse("UPLOADING FILE AS WELL");
      }

      request.headers["accesstoken"] = this.user.value!.accessToken;
      request.headers["enctype"] = "multipart/formdata";

      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['address'] = address;

      if (password.length > 0) {
        request.fields['password'] = password;
        user.value!.password = password;
        await storeAuthData(user.value!.toMap());
      }

      var response = await request.send();
      print(response.statusCode);
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        showMightySnackBar(message: '${jsonDecode(value)['message']}');
        printApiResponse("UPDATED PROFILE :: ${jsonDecode(value)['message']}");
        Restart.restartApp();
      });
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      isLoading(true);
      Map<String, dynamic> response = await ApiHelper().postDataAuthenticated('profile', {});
      return response;
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  deleteMyAccount() async {
    try {
      isLoading(true);
      Map<String, dynamic> response = await ApiHelper().postDataAuthenticated('deleteAccount', {});
      showMightySnackBar(message: response['message']);
      this.logOut();
    } catch (e) {
      printError(info: e.toString());
      showMightySnackBar(message: e.toString());
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  becomeReporter({required String value}) async {
    isLoading(true);
    try {
      var reponse = await ApiHelper().postDataAuthenticated('becomeGuestReporter', {
        'guest_repoter': value.capitalize,
      });
      if (value.capitalize == 'Yes') {
        showMightySnackBar(message: "Congratulations! you are now a reporter.", color: Colors.green);
      } else {
        showMightySnackBar(message: "You are no longer a reporter!");
      }
    } catch (e) {
      printApiResponse(e.toString());
      if (value.capitalize == 'Yes') {
        showMightySnackBar(message: "You are already a reporter.");
      } else {
        showMightySnackBar(message: "You are no longer a reporter!");
      }
    } finally {
      isLoading(false);
    }
  }
}

Future<Position> _getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
