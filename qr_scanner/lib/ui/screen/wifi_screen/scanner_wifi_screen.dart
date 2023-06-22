import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_scanner/ui/components/rounded_button.dart';
import 'package:qr_scanner/ui/screen/device_screen/device_screen.dart';
import 'package:qr_scanner/ui/screen/wifi_screen/esp_smartconfig_screen.dart';
import 'package:wifi_scan/wifi_scan.dart';

class ScannerWifiScreen extends StatefulWidget {
  const ScannerWifiScreen({Key? key}) : super(key: key);

  @override
  State<ScannerWifiScreen> createState() => _ScannerWifiScreenState();
}

class _ScannerWifiScreenState extends State<ScannerWifiScreen> {
  // //////////////
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;

  bool get isStreaming => subscription != null;

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();
      setState(() => accessPoints = results);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // stop subscription for scanned results
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting Wifi"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
            Get.offAll(() => ScreenListDevices());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 300,
                  child: RoundedButton(
                    text: "Scanner Wifi",
                    press: () async => _getScannedResults(context),
                  ),
                ),
              ],
            ),
            const Divider(),
            Flexible(
              child: Center(
                child: accessPoints.isEmpty
                    ? const Text("NO SCANNED RESULTS")
                    : ListView.builder(
                        itemCount: accessPoints.length,
                        itemBuilder: (context, i) => _AccessPointTile(
                          accessPoint: accessPoints[i],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessPointTile extends StatefulWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({
    Key? key,
    required this.accessPoint,
  }) : super(key: key);

  @override
  State<_AccessPointTile> createState() => _AccessPointTileState();
}

class _AccessPointTileState extends State<_AccessPointTile> {
  @override
  Widget build(BuildContext context) {
    final title = widget.accessPoint.ssid.isNotEmpty
        ? widget.accessPoint.ssid
        : "**EMPTY**";
    final signalIcon = widget.accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      subtitle: Text(widget.accessPoint.capabilities),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EspSmartconfigScreen(
              ssid: widget.accessPoint.ssid, bssid: widget.accessPoint.bssid);
        }));
      },
    );
  }
}

/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}
