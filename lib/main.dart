import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/providers/bluetooht_provider.dart';
import 'package:checkme_pro_develop/src/providers/checkme_channel_provider.dart';
import 'package:checkme_pro_develop/src/routes/routes.dart';
import 'package:checkme_pro_develop/src/shar_prefs/device_preferences.dart';
import 'package:checkme_pro_develop/src/theme/theme.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  // load shared preferences 
  final devicePrefs = DevicePreferences();
  await devicePrefs.initPrefs();

  runApp(
    const MyApp()
  );
} 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        // providers 
        ChangeNotifierProvider(create: (_) => CheckmeChannelProvider() ),
        ChangeNotifierProvider(create: (_) => BluetoothProvider() ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hoy RPM CheckmePRO',
        initialRoute: 'home', // initial route 
        routes: routes(), // routes 
        theme: themeData() 
      ),
    );
  }
}