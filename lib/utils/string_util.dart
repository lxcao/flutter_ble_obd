List<int> transferString2ListInt(String stringData) {
  return stringData.codeUnits;
}

String transferListInt2String(List<int> listIntData) {
  return String.fromCharCodes(listIntData);
}

List<String> transferListInt2ListString(
    List<int> listIntData, String splitSymbol) {
  String stringValue = String.fromCharCodes(listIntData);
  List<String> stringList = stringValue.split(splitSymbol);
  return stringList;
}
