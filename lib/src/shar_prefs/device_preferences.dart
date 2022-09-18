
import 'package:shared_preferences/shared_preferences.dart';

class DevicePreferences{

  static final DevicePreferences _instance = DevicePreferences._internal();
  DevicePreferences._internal();
  factory DevicePreferences(){
    return _instance;
  }

  late SharedPreferences _prefs;

  initPrefs()async{ 
    _prefs = await SharedPreferences.getInstance();  
  }

  String get uuid => _prefs.getString('uuid') ?? '';

  set uuid(String uuid) {
     _prefs.setString('uuid', uuid);
  }

  String get deviceName => _prefs.getString('device') ?? '';

  set deviceName(String device) {
     _prefs.setString('device', device);
  }
}