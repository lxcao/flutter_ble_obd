final Map<String, List<int>> obdATCommand = {
  "ATZ": [0x41, 0x54, 0x5A, 0x0D], //eml327 v2.2 step1
  "ATE0": [0x41, 0x54, 0x45, 0x30, 0x0D],
  "ATE1": [0x41, 0x54, 0x45, 0x31, 0x0D],
  "ATH1": [0x41, 0x54, 0x48, 0x31, 0x0D],
  "ATL0": [0x41, 0x54, 0x4C, 0x30, 0x0D],
  "ATSP0": [0x41, 0x54, 0x53, 0x50, 0x30, 0x0D] //eml327 v2.2 step2
};

final Map<String, List<int>> obdDataCommand = {
  "RPM": [0x30, 0x31, 0x30, 0x43, 0x0D],
  "SPD": [0x30, 0x31, 0x30, 0x44, 0x0D],
  "TMP": [0x30, 0x31, 0x30, 0x35, 0x0D],
  "VIN": [0x30, 0x39, 0x30, 0x32, 0x0D], //09 02 5 next 5 lines
  "GEN": [0x30, 0x31, 0x30, 0x30, 0x0D]
};

final String returnSymbol = '\r';
final String promptSymbol = '>';
final String spaceSymbol = ' ';
final String atCommandSymbol = 'AT';
final String colonSymbol = ':';

final Map<String, String> elm327CommandSymbol = {
  'reset': 'Z', //eml327 v2.2 step1
  'echo OFF': 'E0',
  'echo ON': 'E1',
  'headers ON': 'H1',
  'linefeeds off': 'L0',
  'repeat': '\r',
  'version ID': 'I',
  'protocol AUTO': 'SP0' //eml327 v2.2 step2
};

final Map<String, String> obdRequestSymbol = {
  "RPM": '010C',
  "SPD": '010D',
  "TMP": '0105',
  "VIN": '0902', //09 02 5 next 5 lines
  "GEN": '0100'
};
