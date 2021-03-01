import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/state_manager.dart';

class BlueToothController extends GetxController {
  Stream<BluetoothState> bluetoothstatestream = FlutterBlue.instance.state;

  var bluetoothstate = BluetoothState.off.obs;

  @override
  onInit() {
    fetchBlueToothState();
    super.onInit();
  }

  fetchBlueToothState() async {
    bluetoothstatestream.listen((value) {
      bluetoothstate.value = value;
    });
  }
}
