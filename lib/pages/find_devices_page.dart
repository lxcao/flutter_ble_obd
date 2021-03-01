import 'package:flutter/material.dart';
import 'package:flutter_ble_obd/controllers/bluetooth_device_state_controller.dart';
import 'package:flutter_ble_obd/controllers/bluetooth_devices_controller.dart';
import 'package:flutter_ble_obd/controllers/scanresult_controller.dart';
import 'package:flutter_ble_obd/pages/elm327_device_page.dart';
import 'package:flutter_ble_obd/widgets/scan_result_tile_widget.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class FindDevicesPage extends StatelessWidget {
  const FindDevicesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanResultController scanResultController =
        Get.put(ScanResultController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () => scanResultController.startScan(),
        child: SingleChildScrollView(
          physics: new AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              // StreamBuilder<List<BluetoothDevice>>(
              //   stream: Stream.periodic(Duration(seconds: 10))
              //       .asyncMap((_) => FlutterBlue.instance.connectedDevices),
              //   initialData: [],
              //   builder: (c, snapshot) => Column(
              //     children: snapshot.data
              //         .map((d) => ListTile(
              //               title: Text(d.name),
              //               subtitle: Text(d.id.toString()),
              //               trailing: StreamBuilder<BluetoothDeviceState>(
              //                 stream: d.state,
              //                 initialData: BluetoothDeviceState.disconnected,
              //                 builder: (c, snapshot) {
              //                   if (snapshot.data ==
              //                       BluetoothDeviceState.connected) {
              //                     return RaisedButton(
              //                       child: Text('OPEN'),
              //                       onPressed: () => Navigator.of(context).push(
              //                           MaterialPageRoute(
              //                               builder: (context) =>
              //                                   DevicePage(device: d))),
              //                     );
              //                   }
              //                   return Text(snapshot.data.toString());
              //                 },
              //               ),
              //             ))
              //         .toList(),
              //   ),
              // ),
              Obx(() {
                final BluetoothDevicesController bluetoothDevicesController =
                    Get.put(BluetoothDevicesController());
                final bluetoothDevices =
                    bluetoothDevicesController.bluetoothDeviceList;
                return Column(
                    children: bluetoothDevices
                        .map((d) => ListTile(
                              title: Text(d.name),
                              subtitle: Text(d.id.toString()),
                              trailing: Obx(() {
                                final BluetoothDeviceStateController
                                    bluetoothDeviceStateController =
                                    Get.put(BluetoothDeviceStateController(d));
                                final bluetoothDeviceStatus =
                                    bluetoothDeviceStateController
                                        .bluetoothDeviceState;
                                if (bluetoothDeviceStatus.value ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                      child: Text('OPEN'),
                                      onPressed: () =>
                                          Get.to(ELM327DevicePage(device: d)));
                                }
                                return Text(
                                    bluetoothDeviceStatus.value.toString());
                              }),
                            ))
                        .toList());
              }),
              // StreamBuilder<List<ScanResult>>(
              //   stream: FlutterBlue.instance.scanResults,
              //   initialData: [],
              //   builder: (c, snapshot) => Column(
              //     children: snapshot.data
              //         .map(
              //           (r) => ScanResultTile(
              //             result: r,
              //             onTap: () => Navigator.of(context)
              //                 .push(MaterialPageRoute(builder: (context) {
              //               r.device.connect();
              //               return DevicePage(device: r.device);
              //             })),
              //           ),
              //         )
              //         .toList(),
              //   ),
              // ),
              Obx(() {
                final scanResult = scanResultController.scanResultList;
                return Column(
                  children: scanResult
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () {
                            r.device.connect();
                            Get.to(ELM327DevicePage(device: r.device));
                          },
                        ),
                      )
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
      // floatingActionButton: StreamBuilder<bool>(
      //   stream: FlutterBlue.instance.isScanning,
      //   initialData: false,
      //   builder: (c, snapshot) {
      //     if (snapshot.data) {
      //       return FloatingActionButton(
      //         child: Icon(Icons.stop),
      //         onPressed: () => FlutterBlue.instance.stopScan(),
      //         backgroundColor: Colors.red,
      //       );
      //     } else {
      //       return FloatingActionButton(
      //           child: Icon(Icons.search),
      //           onPressed: () => FlutterBlue.instance
      //               .startScan(timeout: Duration(seconds: 40)));
      //     }
      //   },
      // ),
      floatingActionButton: Obx(() {
        final isScanning = scanResultController.isScanning.value;
        print("isScanning: $isScanning");
        if (isScanning) {
          return FloatingActionButton(
            child: Icon(Icons.stop),
            onPressed: () => scanResultController
                .stopScan(), //FlutterBlue.instance.stopScan(),
            backgroundColor: Colors.red,
          );
        } else {
          return FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () => scanResultController.startScan(),
          );
        }
      }),
    );
  }
}
