import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qr_scanner/controller/authentication_controller.dart';
import 'package:qr_scanner/controller/device_controller.dart';
import 'package:qr_scanner/ui/screen/login/login_screen.dart';
import 'package:qr_scanner/ui/screen/splash_screen/splash_screen.dart';
import 'package:qr_scanner/ui/screen/wifi_screen/scanner_wifi_screen.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      initialBinding: Binding(),
      builder: EasyLoading.init(),
    );
  }
}

class Binding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthenticationController>(AuthenticationController());
    Get.put<DeviceController>(DeviceController());
  }
}
