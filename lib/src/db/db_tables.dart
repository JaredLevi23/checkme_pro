
class DbTables{

  static const String usersTable = '''
    CREATE TABLE IF NOT EXISTS Users(
                  id INTEGER PRIMARY KEY,
                  userId INTEGER,
                  userName TEXT,
                  birthDay TEXT,
                  gender TEXT,
                  weight TEXT,
                  height TEXT,
                  age TEXT,
                  iconID TEXT,
                  upload INTEGER
                )
  ''';

  static const String ecgTable = '''
    CREATE TABLE IF NOT EXISTS Ecg(
      id INTEGER PRIMARY KEY,
      dtcDate TEXT,
      userId INTEGER,
      haveVoice INTEGER,
      enLeadKind INTEGER,
      enPassKind INTEGER,
      upload INTEGER
    )
  ''';

  static const String dlcTable = '''
    CREATE TABLE IF NOT EXISTS Dlc(
      id INTEGER PRIMARY KEY,
      dtcDate TEXT,
      pIndex REAL,
      haveVoice INTEGER,
      bpFlag INTEGER,
      bpValue INTEGER,
      hrValue INTEGER,
      hrResult INTEGER,
      spo2Result INTEGER,
      spo2Value INTEGER,
      userId INTEGER,
      upload INTEGER
    )
  ''';

  static const String tmpTable = '''
    CREATE TABLE IF NOT EXISTS Tmp(
      id INTEGER PRIMARY KEY,
      dtcDate TEXT,
      userId INTEGER,
      tempValue REAL,
      measureMode INTEGER,
      enPassKind INTEGER,
      upload INTEGER
    )
  ''';

  static const String spoTable = '''
    CREATE TABLE IF NOT EXISTS Spo(
      id INTEGER PRIMARY KEY,
      dtcDate TEXT,
      userId INTEGER,
      spo2Value INTEGER,
      prValue INTEGER,
      enPassKind INTEGER,
      pIndex REAL,
      upload INTEGER
    )
  ''';

  static const String pedTable = '''
    CREATE TABLE IF NOT EXISTS Ped(
      id INTEGER PRIMARY KEY,
      dtcDate TEXT,
      calorie REAL,
      distance REAL,
      fat REAL,
      speed REAL,
      steps INTEGER,
      totalTime INTEGER,
      userId INTEGER,
      upload INTEGER
    )
  ''';

  static const String slmTable = '''
    CREATE TABLE IF NOT EXISTS Slm(
      id INTEGER PRIMARY KEY,
      dtcDate TEXT,
      enPassKind INTEGER,
      lowOxNumber INTEGER,
      lowOxTime INTEGER,
      lowestOx INTEGER,
      averageOx INTEGER,
      totalTime INTEGER,
      userId INTEGER,
      upload INTEGER
    )
  ''';


  static const String ecgDetailsTable = '''
    CREATE TABLE IF NOT EXISTS EcgDetails(
      id INTEGER PRIMARY KEY,
      dtcDate TEXT,
      hrValue INTEGER,
      stValue INTEGER,
      qrsValue INTEGER,
      qtValue INTEGER,
      qtcValue INTEGER,
      pvcsValue INTEGER,
      timeLength INTEGER,
      arrEcg TEXT,
      arrHR TEXT,
      upload INTEGER
    )
  ''';
}