import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_scanner/controller/authentication_controller.dart';
import 'package:qr_scanner/controller/device_controller.dart';
import 'package:qr_scanner/model/device_model.dart';
import 'package:qr_scanner/ui/screen/login/login_screen.dart';
import 'package:qr_scanner/ui/screen/qr_scanner/qr_scanner_screen.dart';

import '../../components/rounded_button.dart';

// ignore: camel_case_types
class ScreenListDevices extends StatefulWidget {
  const ScreenListDevices({Key? key}) : super(key: key);

  @override
  State<ScreenListDevices> createState() => _ScreenListDevicesState();
}

// ignore: camel_case_types
class _ScreenListDevicesState extends State<ScreenListDevices> {
  static final List<String> value = [
    'meter-MIND_1_PHASE',
    'meter-MIND_3_PHASES',
    'meter-MIND_VIRTUAL',
    'gateway-OTHER',
    'gateway-MIND',
  ];
  RxString dropdownValue = value.first.obs;
  AuthenticationController authentication = Get.find();

  String name = "";
  String address = "";
  String type = "";
  final DeviceController _deviceController = Get.find();

  // String firstName = "";
  // String lastName = "";
  // String email = "";
  // final Authentication _auth = Authentication();

  final RxList<DeviceModel> _devicetList = <DeviceModel>[].obs;

  set deviceList(value) => _devicetList.value = value;

  // ignore: invalid_use_of_protected_member
  List<DeviceModel> get deviceList => _devicetList.value;

  @override
  void initState() {
    // TODO: implement initState
    initData();
    super.initState();
  }

  initData() async {
    deviceList = await _deviceController.getDeviceList(
        pageSize: 50, page: 0, gateway: '');
    // print(deviceList.length);
  }

  dialogCreateDevice() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Obx(
              () => SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Name Device',
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        onChanged: (value) {
                          address = value;
                        },
                        decoration: const InputDecoration(hintText: 'Address'),
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
                        items:
                            value.map<DropdownMenuItem<String>>((String value) {
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
                                    _deviceController
                                        .createDevice(
                                            name: name,
                                            address: address,
                                            type: type)
                                        .then((value) {
                                      if (value) {
                                        setState(() async {
                                          deviceList = await _deviceController
                                              .getDeviceList(
                                                  pageSize: 50,
                                                  page: 0,
                                                  gateway: '');
                                        });
                                      }
                                    });
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
                                  })),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const QrScannerScreen();
                    },
                  ),
                );
                // dialogCreateDevice();
              }),
          IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              Get.offAll(() => const LoginScreen());
            },
          )
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: deviceList.length,
          itemBuilder: (context, index) {
            DeviceModel deviceModel = deviceList[index];
            return Dismissible(
              background: Container(
                alignment: Alignment.centerRight,
                color: const Color.fromARGB(255, 153, 22, 13),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              direction: DismissDirection.endToStart,
              key: UniqueKey(),
              confirmDismiss: (direction) {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Device?"),
                      content: const Text("Are you sure to device data?"),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 100,
                              child: RoundedButton(
                                text: ('Yes'),
                                press: () async {
                                  bool response = await _deviceController
                                      .deleteDevice(deviceModel.id.toString());
                                  if (response) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context, true);
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context, false);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              height: 80,
                              width: 100,
                              child: RoundedButton(
                                text: ('No'),
                                press: () {
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        // onTap: () {

                        // },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                "assets/icons/chip.png",
                                width: size.width * 0.1,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      deviceList[index].name!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Name: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            deviceList[index].name!,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Type: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            deviceList[index].type!,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Cteated_time:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat('dd - MM - yyyy').format(
                                              DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      deviceList[index]
                                                              .created_time! *
                                                          1000)),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
