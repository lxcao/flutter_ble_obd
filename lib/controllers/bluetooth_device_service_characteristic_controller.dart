import 'package:flutter_ble_obd/commands/obd_commands.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/state_manager.dart';

class BluetoothDeviceCharacteristicController extends GetxController {
  BluetoothCharacteristic bluetoothCharacteristic;
  BluetoothDeviceCharacteristicController(
      BluetoothCharacteristic bluetoothCharacteristic) {
    this.bluetoothCharacteristic = bluetoothCharacteristic;
  }

  var bluetoothCharacteristicValue = List<int>().obs;
  var bluetoothCharacteristicReadValue = List<int>().obs;

  Stream<List<int>> bluetoothCharacterReadStream;

  @override
  void onInit() {
    setCharacteristicNotifications(true);
    createCharacteristicReadStream();
    fetchCharacteristicValue();
    fetchCharacteristicReadValue();
    super.onInit();
  }

  setCharacteristicNotifications(bool isNotify) async {
    await bluetoothCharacteristic.setNotifyValue(isNotify);
  }

  writeCharacteristicData(List<int> data) async {
    await bluetoothCharacteristic.write(data, withoutResponse: true);
  }

  fetchCharacteristicValue() async {
    bluetoothCharacteristic.value.listen((event) {
      var eventFirstElement = String.fromCharCode(event.first);
      if (eventFirstElement != returnSymbol &&
          eventFirstElement != promptSymbol)
        bluetoothCharacteristicValue.assignAll(event);
    });
  }

  createCharacteristicReadStream() async {
    bluetoothCharacterReadStream =
        Stream<List<int>>.fromFuture(bluetoothCharacteristic.read());
    print("created ReadStream for  ${bluetoothCharacteristic.uuid.toString()}");
  }

  fetchCharacteristicReadValue() async {
    bluetoothCharacterReadStream.listen((event) {
      bluetoothCharacteristicReadValue.assignAll(event);
    });
  }
}
