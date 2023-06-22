import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/controller/device_controller.dart';

import '../../../controller/authentication_controller.dart';
import '../../components/rounded_button.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  static final List<String> value = [
    'gateway-MIND',
    'meter-MIND_1_PHASE',
    'meter-MIND_3_PHASES',
    'meter-MIND_VIRTUAL',
    'gateway-OTHER',
  ];
  RxString dropdownValue = value.first.obs;

  AuthenticationController authentication = Get.find();
  String accessToken = "";
  String name = "";
  String address = "";
  String type = "";
  final DeviceController _deviceController = Get.find();
  final TextEditingController _token = TextEditingController();
  final TextEditingController _model = TextEditingController();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  dialogCreateDevice() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _model,
                          // onChanged: (value) {
                          //   name = value;
                          // },
                          decoration: const InputDecoration(hintText: 'Name'),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          onChanged: (value) {
                            address = value;
                          },
                          decoration:
                              const InputDecoration(hintText: 'Address'),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownValue.value,
                          onChanged: (value) {
                            type = dropdownValue.value;
                            dropdownValue.value = value!;
                          },
                          items: value
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                type = value,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                height: 80,
                                width: 100,
                                child: RoundedButton(
                                    text: "Creater",
                                    press: () {
                                      print(_model.text);
                                      _deviceController.createTokenDevice(
                                        tokenDevice: _token.text,
                                        modelDevice: _model.text,
                                        address: address,
                                        type: dropdownValue.value,
                                        context: context,
                                      );
                                    })),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              height: 80,
                              width: 100,
                              child: RoundedButton(
                                text: "Cancel",
                                press: () {
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
            icon: const Icon(Icons.flash_on_outlined),
          ),
          IconButton(
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
              icon: const Icon(Icons.camera_alt))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         if (result != null)
          //           Text('Data: ${result!.code}')
          //         else
          //           const Text('Scan a code'),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.pauseCamera();
          //                 },
          //                 child: const Text('pause',
          //                     style: TextStyle(fontSize: 20)),
          //               ),
          //             ),
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.resumeCamera();
          //                 },
          //                 child: const Text('resume',
          //                     style: TextStyle(fontSize: 20)),
          //               ),
          //             )
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 100.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (scanData != null) {
        String? data = scanData.code;
        // Chuyển đổi chuỗi JSON sang đối tượng Map Dart
        Map<String, dynamic> jsonMap = jsonDecode(data!);

        // Truy cập giá trị của trường "SC"
        String tokenDevice = jsonMap['SC'];
        String model = jsonMap['DT'];
        _token.text = tokenDevice;
        _model.text = model;

        print(tokenDevice);
        print(model);

        dialogCreateDevice();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
