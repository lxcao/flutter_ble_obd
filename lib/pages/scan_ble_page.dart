import 'package:flutter/material.dart';
import 'package:flutter_ble_obd/controllers/bluetooth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_ble_obd/pages/bluetooth_off_page.dart';
import 'package:flutter_ble_obd/pages/find_devices_page.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ScanBlePage extends StatelessWidget {
  const ScanBlePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BlueToothController bluetoothController =
        Get.put(BlueToothController());
    return GetMaterialApp(
      color: Colors.lightBlue,
      home: Obx(() {
        final state = bluetoothController.bluetoothstate.value;
        print(state);
        if (state == BluetoothState.on) {
          return FindDevicesPage();
        }
        return BluetoothOffPage(state: state);
      }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     color: Colors.lightBlue,
  //     home: StreamBuilder<BluetoothState>(
  //         stream: FlutterBlue.instance.state,
  //         initialData: BluetoothState.unknown,
  //         builder: (c, snapshot) {
  //           final state = snapshot.data;
  //           if (state == BluetoothState.on) {
  //             return FindDevicesPage();
  //           }
  //           return BluetoothOffPage(state: state);
  //         }),
  //   );
  // }

}
