import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/state_manager.dart';

class ScanResultController extends GetxController {
  static FlutterBlue flutterBlueInstance = FlutterBlue.instance;
  Stream<List<ScanResult>> scanResultStream = flutterBlueInstance.scanResults;
  Stream<bool> isScanningStream = flutterBlueInstance.isScanning;

  var scanResultList = List<ScanResult>().obs;
  var isScanning = false.obs;

  @override
  void onInit() {
    scanBlueToothDevice();
    isScanningProcess();
    super.onInit();
  }

  scanBlueToothDevice() async {
    scanResultStream.listen((value) => scanResultList.assignAll(value));
  }

  isScanningProcess() async {
    isScanningStream.listen((event) {
      isScanning(event);
    });
  }

  startScan() {
    flutterBlueInstance.startScan(timeout: Duration(seconds: 15));
  }

  stopScan() {
    flutterBlueInstance.stopScan();
  }
}
