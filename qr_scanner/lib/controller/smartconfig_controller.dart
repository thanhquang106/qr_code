import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wifi_iot/wifi_iot.dart';

class SmartconfigController {
  Future<void> checkConnectWifi({required String ssid,
    required String bssid,

    required String password}) async {
    EasyLoading.show(status: "Loading");
    if (await WiFiForIoTPlugin.isConnected() &&
        ssid == await WiFiForIoTPlugin.getSSID() &&
        bssid.toUpperCase() == await WiFiForIoTPlugin.getBSSID()) {
      sendSmartConfig(ssid: ssid, bssid: bssid, password: password);
    } else {
      WiFiForIoTPlugin.connect(ssid, password: password, bssid: bssid)
          .then((value) async {
        if (value) {
          Future.delayed(Duration(seconds: 5), () async {
            if (await WiFiForIoTPlugin.isConnected()) {
              sendSmartConfig(ssid: ssid, bssid: bssid, password: password);
            }
          });
        } else {
          EasyLoading.showError("Password failed");
        }
      });
    }
  }

  Future<void> sendSmartConfig({required String ssid,
    required String bssid,
    required String password}) async {
    final provisioner = Provisioner.espTouch();
    bool isDone = false;
    provisioner.listen((response) {
      if (response.ipAddressText != null) {
        isDone = true;
        EasyLoading.showSuccess("Done", dismissOnTap: true);
        provisioner.stop();
      }
    });

    try {
      await provisioner.start(ProvisioningRequest.fromStrings(
        ssid: ssid,
        bssid: bssid,
        password: password,
      ));

      // If you are going to use this library in Flutter
      // this is good place to show some Dialog and wait for exit
      //
      // Or simply you can delay with Future.delayed function
      await Future.delayed(Duration(seconds: 30), () {
        if (!isDone) {
          provisioner.stop();
          EasyLoading.showInfo("check password or device");
        }
      });
    } catch (e, s) {
      EasyLoading.showError(e.toString());
    }
  }
}
