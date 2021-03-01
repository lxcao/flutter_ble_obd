import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

class BleDataModel {
  /*
  蓝牙参数
  */
  FlutterBlue flutterBlue;
  BluetoothDevice device;
  Map<String, ScanResult> scanResults;
  List allBleNameAry;
  BluetoothCharacteristic mCharacteristic;
}

//蓝牙数据模型
BleDataModel model = new BleDataModel();

void initBle() {
  BluetoothDevice device;
  Map<String, ScanResult> scanResults = new Map();
  List allBleNameAry = [];
  BluetoothCharacteristic mCharacteristic;

  model.flutterBlue = FlutterBlue.instance;
  model.device = device;
  model.scanResults = scanResults;
  model.allBleNameAry = allBleNameAry;
  model.mCharacteristic = mCharacteristic;
}

void startBle() async {
  // 开始扫描
  model.flutterBlue.startScan(timeout: Duration(seconds: 10));
  // 监听扫描结果
  model.flutterBlue.scanResults.listen((results) {
    // 扫描结果 可扫描到的所有蓝牙设备
    for (ScanResult r in results) {
      model.scanResults[r.device.name] = r;
      if (r.device.name.length > 0) {
        // print('${r.device.name} found! rssi: ${r.rssi}');
        model.allBleNameAry.add(r.device.name);
        getBleScanNameAry();
      }
    }
  });
}

List getBleScanNameAry() {
  //更新过滤蓝牙名字
  List distinctIds = model.allBleNameAry.toSet().toList();
  model.allBleNameAry = distinctIds;
  return model.allBleNameAry;
}

void connectionBle(int chooseBle) {
  for (var i = 0; i < model.allBleNameAry.length; i++) {
    bool isBleName = model.allBleNameAry[i].contains("GTRS");
    if (isBleName) {
      ScanResult r = model.scanResults[model.allBleNameAry[i]];
      model.device = r.device;

      // 停止扫描
      model.flutterBlue.stopScan();

      discoverServicesBle();
    }
  }
}

void discoverServicesBle() async {
  print("连接上蓝牙设备...延迟连接");
  await model.device
      .connect(autoConnect: false, timeout: Duration(seconds: 10));
  List<BluetoothService> services = await model.device.discoverServices();
  services.forEach((service) {
    var value = service.uuid.toString();
    print("所有服务值 --- $value");
    if (service.uuid.toString().toUpperCase().substring(4, 8) == "FFF0") {
      List<BluetoothCharacteristic> characteristics = service.characteristics;
      characteristics.forEach((characteristic) {
        var valuex = characteristic.uuid.toString();
        print("所有特征值 --- $valuex");
        if (characteristic.uuid.toString() ==
            "0000fff1-0000-1000-8000-xxxxxxxxx") {
          print("匹配到正确的特征值");
          model.mCharacteristic = characteristic;

          const timeout = const Duration(seconds: 30);
          Timer(timeout, () {
            dataCallbackBle();
          });
        }
      });
    }
    // do something with service
  });
}

dataCallsendBle(List<int> value) {
  model.mCharacteristic.write(value);
}

dataCallbackBle() async {
  await model.mCharacteristic.setNotifyValue(true);
  model.mCharacteristic.value.listen((value) {
    // do something with new value
    // print("我是蓝牙返回数据 - $value");
    if (value == null) {
      print("我是蓝牙返回数据 - 空！！");
      return;
    }
    List data = [];
    for (var i = 0; i < value.length; i++) {
      String dataStr = value[i].toRadixString(16);
      if (dataStr.length < 2) {
        dataStr = "0" + dataStr;
      }
      String dataEndStr = "0x" + dataStr;
      data.add(dataEndStr);
    }
    print("我是蓝牙返回数据 - $data");
  });
}

void endBle() {
  model.device.disconnect();
}
