import 'package:flutter/material.dart';
import 'package:flutter_ble_obd/commands/obd_commands.dart';
import 'package:flutter_ble_obd/controllers/bluetooth_device_service_characteristic_controller.dart';
import 'package:flutter_ble_obd/utils/string_util.dart';
import 'package:flutter_ble_obd/widgets/descriptor_tile_widget.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class ELM327CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  // final List<DescriptorTile> descriptorTiles;
  // final VoidCallback onReadPressed;
  // final VoidCallback onWritePressed;
  // final VoidCallback onNotificationPressed;

  const ELM327CharacteristicTile({Key key, this.characteristic})
      // this.descriptorTiles,
      // this.onReadPressed,
      // this.onWritePressed,
      // this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build Char is : ${characteristic.uuid.toString()}');
    BluetoothDeviceCharacteristicController bluetoothCharacteristicController =
        Get.put(BluetoothDeviceCharacteristicController(characteristic),
            tag: characteristic.uuid.toString());
    var blueCharacteristicValue =
        bluetoothCharacteristicController.bluetoothCharacteristicValue;
    var bluetoothCharacteristicReadValue =
        bluetoothCharacteristicController.bluetoothCharacteristicReadValue;
    // return StreamBuilder<List<int>>(
    //   stream: characteristic.value,
    //   initialData: characteristic.lastValue,
    //   builder: (c, snapshot) {
    //     final value = snapshot.data;
    //     return ExpansionTile(
    //       title: ListTile(
    //         title: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             Text('Characteristic'),
    //             Text(
    //                 '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
    //                 style: Theme.of(context).textTheme.bodyText2.copyWith(
    //                     color: Theme.of(context).textTheme.caption.color))
    //           ],
    //         ),
    //         subtitle: Text(value.toString()),
    //         contentPadding: EdgeInsets.all(0.0),
    //       ),
    //       trailing: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           Container(
    //             height: 20,
    //             width: 40,
    //             child: RaisedButton(
    //               child: Text(
    //                 'ATZ',
    //                 style: TextStyle(color: Colors.black, fontSize: 4),
    //               ),
    //               onPressed: () async {
    //                 await characteristic.write(obdATCommand['ATZ'],
    //                     withoutResponse: true);
    //                 await characteristic.read();
    //               },
    //             ),
    //           ),
    //           Container(
    //             height: 20,
    //             width: 40,
    //             child: RaisedButton(
    //               child: Text(
    //                 'ATP',
    //                 style: TextStyle(color: Colors.black, fontSize: 4),
    //               ),
    //               onPressed: () async {
    //                 await characteristic.write(obdATCommand['ATSP0'],
    //                     withoutResponse: true);
    //                 await characteristic.read();
    //               },
    //             ),
    //           ),
    //           Container(
    //             height: 20,
    //             width: 40,
    //             child: RaisedButton(
    //               child: Text(
    //                 '0100',
    //                 style: TextStyle(color: Colors.black, fontSize: 4),
    //               ),
    //               onPressed: () async {
    //                 await characteristic.write(obdDataCommand['GEN'],
    //                     withoutResponse: true);
    //                 await characteristic.read();
    //               },
    //             ),
    //           ),
    //           Container(
    //             height: 20,
    //             width: 40,
    //             child: RaisedButton(
    //               child: Text(
    //                 '010C',
    //                 style: TextStyle(color: Colors.black, fontSize: 4),
    //               ),
    //               onPressed: () async {
    //                 await characteristic.write(obdDataCommand['PRM'],
    //                     withoutResponse: true);
    //                 await characteristic.read();
    //               },
    //             ),
    //           ),
    //           // IconButton(
    //           //   icon: Icon(
    //           //     Icons.file_download,
    //           //     color: Theme.of(context).iconTheme.color.withOpacity(0.5),
    //           //   ),
    //           //   onPressed: onReadPressed,
    //           // ),
    //           // IconButton(
    //           //   icon: Icon(Icons.file_upload,
    //           //       color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
    //           //   onPressed: onWritePressed,
    //           // ),
    //           // IconButton(
    //           //   icon: Icon(
    //           //       characteristic.isNotifying
    //           //           ? Icons.sync_disabled
    //           //           : Icons.sync,
    //           //       color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
    //           //   onPressed: onNotificationPressed,
    //           // )
    //         ],
    //       ),
    //       //children: descriptorTiles,
    //     );
    //   },
    // );
    return Obx(() {
      return ExpansionTile(
        title: ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Characteristic'),
              Text(
                  '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Theme.of(context).textTheme.caption.color))
            ],
          ),
          subtitle: Text(blueCharacteristicValue.toString()),
          contentPadding: EdgeInsets.all(0.0),
        ),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'ATZ',
                    ),
                    onPressed: () async {
                      print(transferString2ListInt(atCommandSymbol +
                          elm327CommandSymbol['reset'] +
                          returnSymbol));
                      await bluetoothCharacteristicController
                          .writeCharacteristicData(transferString2ListInt(
                              atCommandSymbol +
                                  elm327CommandSymbol['reset'] +
                                  returnSymbol));
                      print(transferListInt2String(transferString2ListInt(
                          atCommandSymbol +
                              elm327CommandSymbol['reset'] +
                              returnSymbol)));
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'ATSP0',
                    ),
                    onPressed: () async {
                      print(transferString2ListInt(atCommandSymbol +
                          elm327CommandSymbol['protocol AUTO'] +
                          returnSymbol));
                      await bluetoothCharacteristicController
                          .writeCharacteristicData(transferString2ListInt(
                              atCommandSymbol +
                                  elm327CommandSymbol['protocol AUTO'] +
                                  returnSymbol));
                      print(transferListInt2String(transferString2ListInt(
                          atCommandSymbol +
                              elm327CommandSymbol['protocol AUTO'] +
                              returnSymbol)));
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'ATI',
                    ),
                    onPressed: () async {
                      print(transferString2ListInt(atCommandSymbol +
                          elm327CommandSymbol['version ID'] +
                          returnSymbol));
                      await bluetoothCharacteristicController
                          .writeCharacteristicData(transferString2ListInt(
                              atCommandSymbol +
                                  elm327CommandSymbol['version ID'] +
                                  returnSymbol));
                      print(transferListInt2String(transferString2ListInt(
                          atCommandSymbol +
                              elm327CommandSymbol['version ID'] +
                              returnSymbol)));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'GEN',
                    ),
                    onPressed: () async {
                      print(transferString2ListInt(
                          obdRequestSymbol['GEN'] + returnSymbol));
                      await bluetoothCharacteristicController
                          .writeCharacteristicData(transferString2ListInt(
                              obdRequestSymbol['GEN'] + returnSymbol));
                      print(transferListInt2String(transferString2ListInt(
                          obdRequestSymbol['GEN'] + returnSymbol)));
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'VIN',
                    ),
                    onPressed: () async {
                      print(transferString2ListInt(
                          obdRequestSymbol['VIN'] + returnSymbol));
                      await bluetoothCharacteristicController
                          .writeCharacteristicData(transferString2ListInt(
                              obdRequestSymbol['VIN'] + returnSymbol));
                      print(transferListInt2String(transferString2ListInt(
                          obdRequestSymbol['VIN'] + returnSymbol)));
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'SPD',
                    ),
                    onPressed: () async {
                      print(transferString2ListInt(
                          obdRequestSymbol['SPD'] + returnSymbol));
                      await bluetoothCharacteristicController
                          .writeCharacteristicData(transferString2ListInt(
                              obdRequestSymbol['SPD'] + returnSymbol));
                      print(transferListInt2String(transferString2ListInt(
                          obdRequestSymbol['SPD'] + returnSymbol)));
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'RPM',
                    ),
                    onPressed: () async {
                      print(transferString2ListInt(
                          obdRequestSymbol['RPM'] + returnSymbol));
                      await bluetoothCharacteristicController
                          .writeCharacteristicData(transferString2ListInt(
                              obdRequestSymbol['RPM'] + returnSymbol));
                      print(transferListInt2String(transferString2ListInt(
                          obdRequestSymbol['RPM'] + returnSymbol)));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text('Read: ${transferListInt2String(blueCharacteristicValue)}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Theme.of(context).textTheme.caption.color))
            ],
          ),
        ],
        //children: descriptorTiles,
      );
    });
  }
}
