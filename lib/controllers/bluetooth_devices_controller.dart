import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/state_manager.dart';

class BluetoothDevicesController extends GetxController {
  Stream<List<BluetoothDevice>> bluetoothdeviceStream =
      Stream.periodic(Duration(seconds: 10))
          .asyncMap((_) => FlutterBlue.instance.connectedDevices);

  var bluetoothDeviceList = List<BluetoothDevice>().obs;

  @override
  void onInit() {
    fetchBluetoothDevice();
    super.onInit();
  }

  fetchBluetoothDevice() async {
    bluetoothdeviceStream.listen((event) {
      bluetoothDeviceList.assignAll(event);
    });
  }
}
