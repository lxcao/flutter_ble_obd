import 'package:flutter_ble_obd/commands/obd_commands.dart';
import 'package:flutter_ble_obd/utils/ascii_util.dart';
import 'package:flutter_ble_obd/utils/string_util.dart';

class ObdParseService {
  List<int> buffer;
  List<String> stringList;
  ObdParseService({
    this.buffer,
  }) {
    buffer = this.buffer;
  }

  int parseRPM() {
    stringList = transferListInt2ListString(this.buffer, spaceSymbol);
    return (transferHexString2DecInt(stringList[2] + stringList[3]) ~/ 4);
  }

  int parseSpeed() {
    stringList = transferListInt2ListString(this.buffer, spaceSymbol);
    return transferHexString2DecInt(stringList[2]);
  }

  double parseFuelLevel() {
    stringList = transferListInt2ListString(this.buffer, spaceSymbol);
    return (100.0 * transferHexString2DecInt(stringList[2]) / 255.0);
  }

  int parseTemperature() {
    stringList = transferListInt2ListString(this.buffer, spaceSymbol);
    return (transferHexString2DecInt(stringList[2]) - 40);
  }

  String parseVIN() {
    stringList = transferListInt2ListString(this.buffer, colonSymbol);
    List<String> finalStringList = List<String>();
    List<String> stringList2 = stringList[1].split(' ').sublist(4, 7);
    finalStringList.addAll(stringList2);
    List<String> stringList3 = stringList[2].split(' ').sublist(1, 8);
    finalStringList.addAll(stringList3);
    List<String> stringList4 = stringList[3].split(' ').sublist(1, 8);
    finalStringList.addAll(stringList4);
    List<int> finalIntList = List<int>();
    finalStringList.forEach(
        (element) => {finalIntList.add(int.parse(element, radix: 16))});
    return String.fromCharCodes(finalIntList);
  }
}
