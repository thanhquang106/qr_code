// Usually, I would prefer splitting up an app into smaller files, but as this
// is an example app for a published plugin, it's better to have everything in
// one file so that all of the examples are visible on https://pub.dev/packages/esptouch_flutter/example

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_scanner/controller/smartconfig_controller.dart';
import 'package:qr_scanner/internal/constants.dart';
import 'package:wifi_iot/wifi_iot.dart';

const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.WPA;

class EspSmartconfigScreen extends StatefulWidget {
  final String ssid;
  final String bssid;

  const EspSmartconfigScreen({
    Key? key,
    required this.ssid,
    required this.bssid,
  }) : super(key: key);

  @override
  State<EspSmartconfigScreen> createState() => _EspSmartconfigScreenState();
}

class _EspSmartconfigScreenState extends State<EspSmartconfigScreen> {
  SmartconfigController _smartconfigController = SmartconfigController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController ssid = TextEditingController();
  final TextEditingController bssid = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _isEnabled = false;
  bool _isConnected = false;
  bool _isWiFiAPEnabled = false;
  bool _isWiFiAPSSIDHidden = false;
  bool _isWifiAPSupported = true;
  bool _isWifiEnableOpenSettings = false;
  bool _isWifiDisableOpenSettings = false;

  @override
  void initState() {
    ssid.text = widget.ssid;
    bssid.text = widget.bssid;
    // TODO: implement initState

    WiFiForIoTPlugin.isEnabled().then((val) {
      _isEnabled = val;
    });

    WiFiForIoTPlugin.isConnected().then((val) {
      _isConnected = val;
    });

    WiFiForIoTPlugin.isWiFiAPEnabled().then((val) {
      _isWiFiAPEnabled = val;
    }).catchError((val) {
      _isWifiAPSupported = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    ssid.dispose();
    bssid.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESP"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(child: form(context)),
    );
  }

  Widget form(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[
            TextFormField(
              controller: ssid,
              decoration: const InputDecoration(
                labelText: 'SSID',
                hintText: 'Tony\'s iPhone',
                helperText: AppConstants.helperSSID,
              ),
            ),
            TextFormField(
              controller: bssid,
              decoration: const InputDecoration(
                labelText: 'BSSID',
                hintText: '00:a0:c9:14:c8:29',
                helperText: AppConstants.helperBSSID,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'AES Key',
                hintText: '00:a0:c9:14:c8:29',
                helperText: AppConstants.helperBSSID,
              ),
            ),
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: r'V3Ry.S4F3-P@$$w0rD',
                helperText: AppConstants.helperPassword,
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  _smartconfigController.checkConnectWifi(
                      ssid: widget.ssid,
                      bssid: widget.bssid,
                      password: password.text);
                },
                child: const Text('Execute'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
