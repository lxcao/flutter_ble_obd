import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ble_obd/controllers/bluetooth_device_state_controller.dart';
import 'package:flutter_ble_obd/widgets/elm327_characteristic_tile_widget.dart';
import 'package:flutter_ble_obd/widgets/elm327_service_tile_widget.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class ELM327DevicePage extends StatelessWidget {
  const ELM327DevicePage({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ELM327ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => ELM327CharacteristicTile(
                    characteristic: c,
                    // onReadPressed: () => c.read(),
                    // onWritePressed: () async {
                    //   await c.write(_getRandomBytes(), withoutResponse: true);
                    //   await c.read();
                    // },
                    // onNotificationPressed: () async {
                    //   await c.setNotifyValue(!c.isNotifying);
                    //   await c.read();
                    // },
                    // descriptorTiles: c.descriptors
                    //     .map(
                    //       (d) => DescriptorTile(
                    //         descriptor: d,
                    //         onReadPressed: () => d.read(),
                    //         onWritePressed: () => d.write(_getRandomBytes()),
                    //       ),
                    //     )
                    //    .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final BluetoothDeviceStateController bluetoothDeviceStateController =
        Get.put(BluetoothDeviceStateController(device));
    final bluetoothDeviceStatus =
        bluetoothDeviceStateController.bluetoothDeviceState;
    final isbluetoothDeviceServiceDiscovering =
        bluetoothDeviceStateController.bluetoothDeviceIsDiscoveringServices;
    final bluetoothDeviceMTU =
        bluetoothDeviceStateController.bluetoothDeviceMTU;
    final bluetoothDeviceServices =
        bluetoothDeviceStateController.bluetoothDeviceServices;
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          // StreamBuilder<BluetoothDeviceState>(
          //   stream: device.state,
          //   initialData: BluetoothDeviceState.connecting,
          //   builder: (c, snapshot) {
          //     VoidCallback onPressed;
          //     String text;
          //     switch (snapshot.data) {
          //       case BluetoothDeviceState.connected:
          //         onPressed = () => device.disconnect();
          //         text = 'DISCONNECT';
          //         break;
          //       case BluetoothDeviceState.disconnected:
          //         onPressed = () => device.connect();
          //         text = 'CONNECT';
          //         break;
          //       default:
          //         onPressed = null;
          //         text = snapshot.data.toString().substring(21).toUpperCase();
          //         break;
          //     }
          //     return FlatButton(
          //         onPressed: onPressed,
          //         child: Text(
          //           text,
          //           style: Theme.of(context)
          //               .primaryTextTheme
          //               .button
          //               .copyWith(color: Colors.white),
          //         ));
          //   },
          // ),
          Obx(() {
            VoidCallback onPressed;
            String text;
            switch (bluetoothDeviceStatus.value) {
              case BluetoothDeviceState.connected:
                onPressed = () => device.disconnect();
                text = 'DISCONNECT';
                break;
              case BluetoothDeviceState.disconnected:
                onPressed = () => device.connect();
                text = 'CONNECT';
                break;
              default:
                onPressed = null;
                text = bluetoothDeviceStatus.value
                    .toString()
                    .substring(21)
                    .toUpperCase();
                break;
            }
            return FlatButton(
                onPressed: onPressed,
                child: Text(
                  text,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .button
                      .copyWith(color: Colors.white),
                ));
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // StreamBuilder<BluetoothDeviceState>(
            //   stream: device.state,
            //   initialData: BluetoothDeviceState.connecting,
            //   builder: (c, snapshot) => ListTile(
            //     leading: (snapshot.data == BluetoothDeviceState.connected)
            //         ? Icon(Icons.bluetooth_connected)
            //         : Icon(Icons.bluetooth_disabled),
            //     title: Text(
            //         'Device is ${snapshot.data.toString().split('.')[1]}.'),
            //     subtitle: Text('${device.id}'),
            //     trailing: StreamBuilder<bool>(
            //       stream: device.isDiscoveringServices,
            //       initialData: false,
            //       builder: (c, snapshot) => IndexedStack(
            //         index: snapshot.data ? 1 : 0,
            //         children: <Widget>[
            //           IconButton(
            //             icon: Icon(Icons.refresh),
            //             onPressed: () => device.discoverServices(),
            //           ),
            //           IconButton(
            //             icon: SizedBox(
            //               child: CircularProgressIndicator(
            //                 valueColor: AlwaysStoppedAnimation(Colors.grey),
            //               ),
            //               width: 18.0,
            //               height: 18.0,
            //             ),
            //             onPressed: null,
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Obx(() {
              return ListTile(
                leading: (bluetoothDeviceStatus.value ==
                        BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${bluetoothDeviceStatus.value.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: Obx(() {
                  return IndexedStack(
                    index: isbluetoothDeviceServiceDiscovering.value ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  );
                }),
                // StreamBuilder<bool>(
                //   stream: device.isDiscoveringServices,
                //   initialData: false,
                //   builder: (c, snapshot) => IndexedStack(
                //     index: snapshot.data ? 1 : 0,
                //     children: <Widget>[
                //       IconButton(
                //         icon: Icon(Icons.refresh),
                //         onPressed: () => device.discoverServices(),
                //       ),
                //       IconButton(
                //         icon: SizedBox(
                //           child: CircularProgressIndicator(
                //             valueColor: AlwaysStoppedAnimation(Colors.grey),
                //           ),
                //           width: 18.0,
                //           height: 18.0,
                //         ),
                //         onPressed: null,
                //       )
                //     ],
                //   ),
                // ),
              );
            }),
            // StreamBuilder<int>(
            //   stream: device.mtu,
            //   initialData: 0,
            //   builder: (c, snapshot) => ListTile(
            //     title: Text('MTU Size'),
            //     subtitle: Text('${snapshot.data} bytes'),
            //     trailing: IconButton(
            //       icon: Icon(Icons.edit),
            //       onPressed: () => device.requestMtu(223),
            //     ),
            //   ),
            // ),
            Obx(() {
              return ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${bluetoothDeviceMTU.value} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    bluetoothDeviceStateController.setDeviceMTU();
                  }, //256
                ),
              );
            }),
            // StreamBuilder<List<BluetoothService>>(
            //   stream: device.services,
            //   initialData: [],
            //   builder: (c, snapshot) {
            //     return Column(
            //       children: _buildServiceTiles(snapshot.data),
            //     );
            //   },
            // ),
            Obx(() {
              return Column(
                children: _buildServiceTiles(bluetoothDeviceServices),
              );
            }),
          ],
        ),
      ),
    );
  }
}
