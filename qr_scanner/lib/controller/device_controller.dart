import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_scanner/internal/constants.dart';
import 'package:qr_scanner/model/device_model.dart';

import 'package:qr_scanner/ui/screen/wifi_screen/scanner_wifi_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DeviceController extends GetxController {
  Future<List<DeviceModel>?> getDeviceList(
      {required int pageSize,
      required int page,
      required String gateway}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString("authToken");
    // UserModel? user = await getUserInfo();
    final uri = Uri.parse(
        "${AppConstants.API_URL}/device?page_size=${pageSize}&page=${page}&type=${gateway}");
    final reponse = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (reponse.statusCode == 200) {
      final json = jsonDecode(reponse.body);
      List data = json['data'];
      List<DeviceModel> devicetList = [];
      if (data.isNotEmpty) {
        for (var da in data) {
          devicetList.add(DeviceModel.fromJson(da));
        }
      }
      return devicetList;
    } else {
      print('#######################11');
    }
  }

// createDevice//////////////
  Future<bool> createDevice({
    required String name,
    required String address,
    required String type,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = await prefs.getString("authToken");
      final uri = Uri.parse("${AppConstants.API_URL}/device");

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "name": name,
          "type": type,
          "additional_info": {
            "address": address,
            "location": "string",
            "description": {}
          }
        }),
      );
      if (response.statusCode == 200) {
        Get.back();
        Fluttertoast.showToast(
            msg: "Create Device Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Create Device Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

// deleteDevice
  Future deleteDevice(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString("authToken");
    final uri = Uri.parse("${AppConstants.API_URL}/device/$id");
    final response = await http.delete(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("failed");
    }
  }

// Update tokenDevice
  Future<void> createTokenDevice({
    required String modelDevice,
    required String tokenDevice,
    required String address,
    required String type,
    required BuildContext context,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final queryParamester = tokenDevice;
    String? token = await prefs.getString("authToken");
    final uri = Uri.parse(
        "${AppConstants.API_URL}/device/quang-cc?access_token=${queryParamester}");
    final reponse = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "access_token": tokenDevice,
        "name": modelDevice,
        "type": type,
        "additional_info": {
          "address": address,
          "location": "location",
          "description": {}
        }
      }),
    );
    print(tokenDevice);
    print("111111111111111111111111111111111111");
    print(modelDevice);
    print(address);

    print(type);
    print(reponse.statusCode);
    if (reponse.statusCode == 200) {
      Get.to(() => const ScannerWifiScreen());
      Fluttertoast.showToast(
          msg: "Create Device Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Create Device Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
