// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qr_scanner/internal/constants.dart';
import 'package:qr_scanner/model/device_model.dart';
import 'package:qr_scanner/model/userid_model.dart';
import 'package:qr_scanner/ui/screen/device_screen/device_screen.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
// login////////////
  Future<void> login(
      {required String email,
      required password,
      required BuildContext context}) async {
    try {
      final uri = Uri.parse("${AppConstants.API_URL}/auth/login");
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{"username": email, "password": password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        String token = data['access_token'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("authToken", token);
        Fluttertoast.showToast(
            msg: "Login Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        Get.offAll(() => const ScreenListDevices());
      } else {
        Fluttertoast.showToast(
            msg: "Login account, wrong password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

// getUserInfo//////////
  Future<UserModel?> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString("authToken");
    final uri = Uri.parse("${AppConstants.API_URL}/auth/user_info");
    final reponse = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (reponse.statusCode == 200) {
      final json = jsonDecode(reponse.body);
      return UserModel.fromJson(json);
    } else {
      print('#######################');
    }
  }
}
