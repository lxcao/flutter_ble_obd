import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/state_manager.dart';

class BluetoothDeviceStateController extends GetxController {
  BluetoothDevice bluetoothdevice;
  BluetoothDeviceStateController(BluetoothDevice bluetoothdevice) {
    this.bluetoothdevice = bluetoothdevice;
  }

  var bluetoothDeviceState = BluetoothDeviceState.disconnected.obs;
  var bluetoothDeviceIsDiscoveringServices = false.obs;
  var bluetoothDeviceMTU = 0.obs;
  var bluetoothDeviceServices = List<BluetoothService>().obs;

  @override
  void onInit() {
    fetchBluetoothDeviceState();
    isDeviceDiscoveringServices();
    obtainDeviceMTU();
    fetchDeviceServices();
    super.onInit();
  }

  fetchBluetoothDeviceState() async {
    bluetoothdevice.state.listen((event) {
      bluetoothDeviceState.value = event;
    });
  }

  isDeviceDiscoveringServices() async {
    bluetoothdevice.isDiscoveringServices.listen((event) {
      bluetoothDeviceIsDiscoveringServices.value = event;
    });
  }

  obtainDeviceMTU() async {
    bluetoothdevice.mtu.listen((event) {
      bluetoothDeviceMTU.value = event;
    });
  }

  setDeviceMTU() async {
    print('set MTU to 256 to ${bluetoothdevice.name}');
    await bluetoothdevice.requestMtu(256);
  }

  fetchDeviceServices() async {
    bluetoothdevice.services.listen((event) {
      bluetoothDeviceServices.assignAll(event);
    });
  }
}
